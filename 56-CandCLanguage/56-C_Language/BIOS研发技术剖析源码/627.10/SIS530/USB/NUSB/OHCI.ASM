;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;

;---------------------------------------;
include cssgpm.dat

include makeflag.equ
include ohci.equ
include usb.equ
include pci.equ
include	usbdata.dat

;---------------------------------------;

	public _UsbHcInit
	public _UsbHcClose
	public _UsbActivatePolling
	public _UsbDeactivatePolling

	public UsbDeviceRequest
	public UsbGetRootHubPortStatus
	public UsbEnableRootHubPort
	public UsbDisableRootHubPort

;---------------------------------------;

	extrn UsbDataInit		:near
	extrn UsbHubPortChange		:near

	extrn OneSecondPeriodicHandler 	:near
	extrn PeriodicInterruptHandler 	:near
	extrn EnableKBCTraps		:near

	extrn pm_fixed_delay		:near
	extrn smi_pci_read_cfg		:near
	extrn smi_pci_write_cfg		:near
	extrn smi_pci_find_device	:near
;;;;	extrn cpu_gen_purpose_reg_entry	:abs

	extrn UsbGetHostControllerId	:near
	extrn UsbHcChipsetInit		:near
	extrn UsbHcChipsetShutdown	:near
	extrn UsbHcChipsetGetStatus	:near
	extrn UsbHcChipsetHandler	:near

;---------------------------------------;


cgroup	group	_text
_text 	segment word public 'CODE'

	assume	cs:cgroup
	assume	ds:usbdgroup
	assume	es:usbdgroup
.386

;---------------------------------------;
; UsbHcHandler                          ;
;---------------------------------------;--------------------------------------;
; Input: DS = PM BIOS Data segment in SMRam                                    ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Any general purpose                                                ;
;------------------------------------------------------------------------------;
UsbHcHandler	proc near
;	mov	dx,USB_COMMAND_REG
;	call	ReadUsbIoRegWord		;AX = contents of USB command reg
;	test	ax,CONFIGURE_FLAG
;	jnz	@f				;Br if USB HC is already configured
;	call	_UsbHcInit			;Re-Init the USB HC after O/S shutdown
;	ret
;@@:
	mov	bx, UsbHcBusDevFuncNum		;BX = bus/dev/func of USB HC
	call	UsbHcChipsetHandler
	ret
UsbHcHandler	endp


;---------------------------------------;
; UsbActivatePolling                    ;
;---------------------------------------;--------------------------------------;
; This function activates a polling TD for the given device so the host        ;
; controller will run an interrupt transaction to the device according to the  ;
; schedule that was setup in UsbHcInit.  This routine is used to activate      ;
; polling for HID devices and Hubs.                                            ;
;                                                                              ;
; Input:  SI = Pointer to device table entry                                   ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbActivatePolling	proc near
	push	eax
	push	di

; Get a pointer to the device's TD in the TdPool and make the TD active in the
; TD's TD_Control and CSReloadValue.

	mov	eax, NOT_ACCESSED shl 28

	mov	di, (DeviceTableEntry ptr [si]).TdPoolPtr
	or	(General_Transfer_Descriptor ptr [di]).GTD_CONTROL, eax
	or	(General_Transfer_Descriptor ptr [di]).CSReloadValue, eax
	mov	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Get a pointer to the device's ED in the EdPool and set the address, endpoint,
; and speed fields in the ED.

	movzx	eax,(DeviceTableEntry ptr [si]).LowSpeedFlag  ;EAX[13] = 0/1 for full/low
	shl	eax, 6
	or	al, (DeviceTableEntry ptr [si]).EndpointNum   ;EAX[10:7] = Endp
	shl	eax, 7
	or	al, (DeviceTableEntry ptr [si]).DeviceAddress ;EAX[6:0] = Addr

	mov	di, (DeviceTableEntry ptr [si]).EdPoolPtr
	and	(Endpoint_Descriptor ptr [di]).ED_Control, (not ENDPOINT) and (not LOW_SPEED) and (not FUNCTION_ADDRESS)
	or	(Endpoint_Descriptor ptr [di]).ED_Control, eax

; Finally clear the Skip bit in the device's ED.  This will cause the HC
; to process the ED and TD.

	and	(Endpoint_Descriptor ptr [di]).ED_Control, NOT SKIP_TDQ

	pop	di
	pop	eax
	ret
_UsbActivatePolling	endp


;---------------------------------------;
; UsbDeactivatePolling                  ;
;---------------------------------------;--------------------------------------;
; This function deactivates the polling TD for the given device.               ;
;                                                                              ;
; Input:  SI = Pointer to device table entry                                   ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbDeactivatePolling	proc near
	push	di

; Get a pointer to the device's ED in the EdPool and set its Skip bit.

	mov	di, (DeviceTableEntry ptr [si]).EdPoolPtr
	or 	(Endpoint_Descriptor ptr [di]).ED_Control, SKIP_TDQ

; Get a pointer to the device's TD in the TdPool and make it inactive.

	mov	di, (DeviceTableEntry ptr [si]).TdPoolPtr
	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	pop	di
	ret
_UsbDeactivatePolling	endp


;---------------------------------------;
; UsbDeviceRequest                      ;
;---------------------------------------;--------------------------------------;
; This function executes a device request command transaction on the USB.      ;
; One setup packet is generated containing the device request parameters       ;
; supplied by the caller.  The setup packet may be followed by data in or      ;
; data out packets containing data sent from the host to the device or vice-   ;
; versa.  This function will not return until the request either completes     ;
; successfully or completes in error (due to time out, etc.)                   ;
;                                                                              ;
; Input: AL = Destination USB device address (valid range: 00h - 7Fh)          ;
;        AH = Destination endpoint within the device (valid range 00h - 0Fh)   ;
;        BL = Request type                                                     ;
;               Bit 7:   Data direction                                        ;
;                          0 = Host sending data to device                     ;
;                          1 = Device sending data to host                     ;
;               Bit 6-5: Type                                                  ;
;                          00 = Standard USB request                           ;
;                          01 = Class specific                                 ;
;                          10 = Vendor specific                                ;
;                          11 = Reserved                                       ;
;               Bit 4-0: Recipient                                             ;
;                          00000 = Device                                      ;
;                          00001 = Interface                                   ;
;                          00010 = Endpoint                                    ;
;                          00011 = Other                                       ;
;                          00100 - 11111 = Reserved                            ;
;        BH = Request code, a one byte code describing the actual device       ;
;             request to be executed (ex: get configuration, set address, etc.);
;        CX = wValue request parameter (meaning varies with each request type) ;
;        DX = wIndex request parameter (meaning varies with each request type) ;
;        SI = wLength request parameter, number of bytes of data to be         ;
;             transferred in or out of the host controller                     ;
;        ES:DI = Seg:Offset of buffer containing data to be sent to the device ;
;                or space to be used to receive data from the device           ;
;                                                                              ;
; Output: CF = Clear if device request completed successfully                  ;
;              Set if device request completed with error or timed out         ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbDeviceRequest	proc near
	pushad

	push	cx
	mov 	cx, 0C8h		;3ms / 15us
	call	pm_fixed_delay		;Delay 10ms
	pop	cx

	xor	ebp, ebp		;Build abs addr of data area in EBP
	mov	bp, es
	shl	ebp, 4
	movzx	edi, di
	add	ebp, edi		;EBP = abs addr of data area

; Build the device request in the data area of the TdControlSetup

	mov	di, offset TdControlSetup.GTD_Setup
	mov	(DeviceRequest ptr [di]).RequestType, bl
	mov	(DeviceRequest ptr [di]).RequestCode, bh
	mov	(DeviceRequest ptr [di]).Value, cx
	mov	(DeviceRequest ptr [di]).Index, dx
	mov	(DeviceRequest ptr [di]).DataLength, si

; Prepare some registers that will be used in building the TDs below.
; SI  contains the data length.
; EBP contains the absolute address of the data buffer.
; DL  will contain the request type (bit 7 = 0/1 for Out/In).
; ECX will contain the device address and endpoint shifted and ready to go
;     into the ED's ED_Control field.
; BX  will contain a pointer to the DeviceTableEntry for the given device.
; DI  will be left free to use as a pointer to the TD being built.
; EAX will be left free to use as a scratch register.

	movzx	dx, ah			;DX[3:0] = Endpoint (0-F)
	shl	dx, 7			;DX[10:7] = Endpoint (0-F)
	movzx	ecx, al 		;ECX[6:0] = Device address (00-7F)
	or	cx, dx			;ECX[10:0] = Device address / endpoint

	mov	dl, bl			;DL = Request type

	mov	bx, offset DeviceTable	;BX = ptr to DeviceTable[0]
DevReqFindEntryNextEntry:
	cmp	(DeviceTableEntry ptr [bx]).Present, TRUE
	jne	DevReqFindEntrySkipEntry ;Br if this DeviceTableEntry is not in use
	cmp	(DeviceTableEntry ptr [bx]).DeviceAddress, al
	clc				;Indicate entry found
	je	DevReqFindEntryDone	;Br if matching entry found

DevReqFindEntrySkipEntry:
	add	bx, size DeviceTableEntry
	cmp	bx, offset DeviceTableEnd
	jb	DevReqFindEntryNextEntry ;Br if more entries to check
	stc
	jmp	DeviceRequestDone	;Could not find matching DeviceTableEntry
DevReqFindEntryDone:

; Initialize the EdControl.
; The ED_Control field will be set so FUNCTION_ADDRESS/ENDPOINT_NUMBER = ECX,
;   DIRECTION=FROM TD, SPEED=DeviceTableEntry.LowSpeedFlag, SKIP=1,
;   FORMAT=0, MAX_PACK_SIZE=DeviceTableEntry.Endp0MaxPacket
; The TDQ_Head_Pointer field will be set to TdControlSetup
; The TDQ_Tail_Pointer field will be set to TERMINATE
; The Next_ED field will be set to TERMINATE

	mov	di, offset EdControl

	movzx	eax, (DeviceTableEntry ptr [bx]).Endp0MaxPacket
	cmp	ax, 40h			;ALI cannot handle packet size of 80h
	jbe	@f
	mov	ax, 40h
@@:
	shl	eax, 16			;EAX[26:16] = device's packet size
	movzx	ax, (DeviceTableEntry ptr [bx]).LowSpeedFlag ;AL = 0/1 for hi/lo
	shl	ax, 13			;EAX[13] = full/low speed flag
	or	eax, ecx		;EAX[10:0] = Endp/Addr
	or	eax, SKIP_TDQ
	mov	(Endpoint_Descriptor ptr [di]).ED_Control,eax

	mov	ax, offset TdControlSetup
	movzx	eax, ax
	add	eax, HcdDataArea
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Head_Pointer,eax

	mov	eax, TERMINATE
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Tail_Pointer, eax
	mov	(Endpoint_Descriptor ptr [di]).Next_ED, eax

; Fill in various fields in the TdControlSetup.
; The TD_Control field will be set so BUFFER_ROUNDING=1,
;   DIRECTION_PID=SETUP_PACKET, DELAY_INTERRUPT=IntD,
;   DATA_TOGGLE=SETUP_TOGGLE, ERROR_COUNT=NO_ERRORS, CONDITION_CODE=NOT_ACCESSED
; The GTD_Current_Buffer_Pointer field will point to the TD's GTD_Setup buffer
;   which was just initialized to contain a DeviceRequest struc.
; The GTD_Buffer_End field will point to the last byte of the TD's GTD_Setup
;   buffer.
; The GTD_Next_TD field will point to the TdControlData if data will
;   be sent/received or to the TdControlStatus if no data is expected.
; The CSReloadValue field will contain 0 because this is a "one shot" packet.
; The pCallback will be set to point to the ControlTdCallback routine.
; The ActiveFlag field will be set to TRUE.
; The DeviceAddress field does not need to be set since the Control TDs do
;   not need rebinding to the EdControl.

	mov	di, offset TdControlSetup ;DI = ptr to TdControlSetup

	mov	(General_Transfer_Descriptor ptr [di]).GTD_Control, BUFFER_ROUNDING or SETUP_PACKET or DELAY_INTERRUPT or SETUP_TOGGLE or NO_ERRORS or (NOT_ACCESSED shl 28)

	lea	ax, (General_Transfer_Descriptor ptr [di]).GTD_Setup ;AX = ptr to TD's data buffer
	movzx	eax, ax 		;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's 8 byte data buffer
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Current_Buffer_Pointer, eax
	add	eax, (size (General_Transfer_Descriptor ptr [di]).GTD_Setup) - 1
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Buffer_End, eax

	mov	eax, offset TdControlData ;EAX = offset of TdControlData
	or	si, si
	jnz	@f			;Br if data length is non-zero
	mov	eax, offset TdControlStatus ;EAX = offset of TdControlStatus
@@:	add	eax, HcdDataArea	;EAX = abs addr
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Next_TD, eax

	mov	(General_Transfer_Descriptor ptr [di]).CSReloadValue, 0
	mov	(General_Transfer_Descriptor ptr [di]).pCallback, offset cgroup:ControlTdCallback
	add	(General_Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Fill in various fields in the TdControlData.
; The TD_Control field will be set so BUFFER_ROUNDING=1,
;   DIRECTION_PID=OUT_PACKET/IN_PACKET, DELAY_INTERRUPT=IntD,
;   DATA_TOGGLE=DATA1_TOGGLE, ERROR_COUNT=NO_ERRORS, CONDITION_CODE=NOT_ACCESSED
; The GTD_Current_Buffer_Pointer field will point to the caller's buffer
;   which is now in EBP.
; The GTD_Buffer_End field will point to the last byte of the caller's buffer.
; The GTD_Next_TD field will point to the TdControlStatus.
; The CSReloadValue field will contain 0 because this is a "one shot" packet.
; The pCallback will be set to point to the ControlTdCallback routine.
; The ActiveFlag field will be set to TRUE.
; The DeviceAddress field does not need to be set since the Control TDs do
;   not need rebinding to the EdControl.

	or	si, si
	jz	DevReqSkipDataTd	;Br if no data transfer (data length=0)

	mov	di, offset TdControlData ;DI = ptr of TdControlData

	mov	eax, BUFFER_ROUNDING or OUT_PACKET or DELAY_INTERRUPT or DATA1_TOGGLE or NO_ERRORS or (NOT_ACCESSED shl 28)
	test	dl, 80h
	jz	@f			;Br if host sending data to device (OUT)
	mov	eax, BUFFER_ROUNDING or IN_PACKET  or IntD or DATA1_TOGGLE or NO_ERRORS or (NOT_ACCESSED shl 28)
@@:	mov	(General_Transfer_Descriptor ptr [di]).GTD_Control, eax

	mov	(General_Transfer_Descriptor ptr [di]).GTD_Current_Buffer_Pointer, ebp

	movzx	eax, si 		;ESI = data length
	cmp	ax, size DeviceRequestDataBuf
	jbe	@f			;Br if processedn data <= buffer size
	mov	ax, size DeviceRequestDataBuf
@@:	add	ebp, eax		;Update the buffer pointer
	dec	ebp
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Buffer_End, ebp

	mov	eax, HcdDataArea	;EAX = seg containing TDs
	add	eax, offset TdControlStatus ;EAX = abs addr of TdControlStatus
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Next_TD, eax

	mov	(General_Transfer_Descriptor ptr [di]).CSReloadValue, 0
	mov	(General_Transfer_Descriptor ptr [di]).pCallback, offset cgroup:ControlTdCallback
	add	(General_Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

DevReqSkipDataTd:

; Fill in various fields in the TdControlStatus.
; The TD_Control field will be set so BUFFER_ROUNDING=1,
;   DIRECTION_PID=IN_PACKET/OUT_PACKET, DELAY_INTERRUPT=IntD,
;   DATA_TOGGLE=DATA1_TOGGLE, ERROR_COUNT=NO_ERRORS, CONDITION_CODE=NOT_ACCESSED
; The GTD_Current_Buffer_Pointer field will point to NULL
; The GTD_Buffer_End field will point to NULL.
; The GTD_Next_TD field will point to TERMINATE.
; The CSReloadValue field will contain 0 because this is a "one shot" packet.
; The pCallback will be set to point to the ControlTdCallback routine.
; The ActiveFlag field will be set to TRUE.
; The DeviceAddress field does not need to be set since the Control TDs do
;   not need rebinding to the EdControl.

	mov	di, offset TdControlStatus ;DI = ptr to TdControlStatus

	mov	eax, BUFFER_ROUNDING or IN_PACKET or IntD or DATA1_TOGGLE or NO_ERRORS or (NOT_ACCESSED shl 28)
	test	dl, 80h
	jz	@f			;Br if host sending data to device (OUT)
	mov	eax, BUFFER_ROUNDING or OUT_PACKET  or IntD or DATA1_TOGGLE or NO_ERRORS or (NOT_ACCESSED shl 28)
@@:	mov	(General_Transfer_Descriptor ptr [di]).GTD_Control, eax

	xor	eax, eax
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Current_Buffer_Pointer, eax
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Buffer_End, eax
	mov	(General_Transfer_Descriptor ptr [di]).GTD_Next_TD, eax
	mov	(General_Transfer_Descriptor ptr [di]).CSReloadValue, eax

	mov	(General_Transfer_Descriptor ptr [di]).pCallback, offset cgroup:ControlTdCallback
	add	(General_Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Now complete the Control queue, so set SKIP_TDQ=0

	mov	di, offset EdControl
	and	(Endpoint_Descriptor ptr [di]).ED_Control,not SKIP_TDQ

; Set the HcControlHeadED register to point to the EdControl.

	mov	eax, offset EdControl
	add	eax, HcdDataArea
	mov	dx, OHCI_CONTROL_HEAD_ED
	call	WriteUsbOperRegDword

; Now put the TdControlSetup, TdControlData, and TdControlStatus into the
; HC's schedule by setting the ControllListFilled field of HcCommandStatus reg.
; This will cause the HC to execute the transaction in the next active frame.

	mov	eax, CONTROL_LIST_FILLED
	mov	dx, OHCI_COMMAND_STATUS
	call	WriteUsbOperRegDword

; Now wait for the TdControlStatus to complete.  When it has completed,
; the ControlTdCallback will its active flag to FALSE.

;	mov	bx, 20000d		;Repeat this loop this number of times
					; before giving up (~50us per iteration)
	mov	bx, 2500
WaitForComplete:
	mov	dx, OHCI_INTERRUPT_STATUS
	call	ReadUsbOperRegDword	;AX = value from status register
	test	eax, WRITEBACK_DONEHEAD
	jz	@f			;Br if HC is not asserting IRQ

ifdef DOS_DEBUG
	pushf				;Simulate IRQ from the HC
	push	cs
	cli
endif
	call	UsbHcIsr
@@:
	cmp	TdControlSetup.ActiveFlag, FALSE
	jne	DevReqNotComplete		;Br if TdControlSetup not completed
	cmp	TdControlData.ActiveFlag, FALSE
	jne	DevReqNotComplete		;Br if TdControlData not completed
	cmp	TdControlStatus.ActiveFlag, FALSE
	je	DevReqComplete			;Br if TdControlStatus completed

DevReqNotComplete:
;; for port 1 cannot work
	mov	cx, 3
;	mov	cx, 96*2
	call	pm_fixed_delay		;Delay 45us

	dec	bx			;Dec timeout counter
	jnz	WaitForComplete		;Br if not time to give up yet

	or	(General_Transfer_Descriptor ptr [di]).GTD_Control, (DEVICE_NOT_RESPOND shl 28)

DevReqComplete:

; Stop the HC from processing the EdControl by setting its Skip bit.

	mov	di, offset EdControl
	or	(Endpoint_Descriptor ptr [di]).ED_Control, SKIP_TDQ

; Finally check for any error bits set in both the TdControlStatus.
; If the TD did not complete successfully, return STC.

	mov	eax, TdControlStatus.GTD_Control
	shr	eax, 28			;AL[3:0] = Completion status
	or	al, al
	clc				;Indicate success
	jz	DeviceRequestDone	;Br if no error bits are set

	;----------------------------------------------------------------------
	; Patch for Compaq OHCI HC which reports DataUnderrun error on any
	; short packet (even if buffer rounding is enabled).
	ifdef HC_PATCH_COMPAQ_OHCI
	cmp	al, DATA_UNDERRUN
	clc				;Indicate success
	je	DeviceRequestDone	;Br if DataUnderrun error
	endif
	;----------------------------------------------------------------------

	stc				;Indicate error

DeviceRequestDone:
	popad
	ret
UsbDeviceRequest	endp


;---------------------------------------;
; UsbGetRootHubPortStatus               ;
;---------------------------------------;--------------------------------------;
; This function returns the status of one port on the root hub.                ;
;                                                                              ;
; Input:  AH = Port number within hub                                          ;
;                                                                              ;
; Output: BL = Port status flags                                               ;
;              Bit 0: Connect status                                           ;
;                      0 = No device is connected to port                      ;
;                      1 = A device is connected to port                       ;
;              Bit 1: Device speed                                             ;
;                      0 = Full speed device attached                          ;
;                      1 = Low speed device attached                           ;
;              Bit 2: Connect status change                                    ;
;                      0 = Connect status has not changed                      ;
;                      1 = Device has been attached/removed                    ;
;              Bit 3-7: Reserved                                               ;
;         CF = Clear if the hub port's status was determined successfully      ;
;              Set if the hub port's status cannot be determined               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbGetRootHubPortStatus	proc near
	push	eax
	push	dx

	shl 	ah, 2			;AH = 4/8 for port 1/2
	mov 	dx, OHCI_RH_PORT1_STATUS - 4
	add 	dl, ah			;DX = Port 1/2 control reg
	call	ReadUsbOperRegDword	;EAX = value from port control reg

	xor 	bl, bl			;Init the output values

	test	al, CURRENT_CONNECT_STATUS
	jz  	@f			;Br if no device present
	or  	bl, 00000001b		;Set connect status bit
@@:
	test	ax, LOW_SPEED_DEVICE_ATTACHED
	jz  	@f			;Br if high speed device
	or  	bl, 00000010b		;Set low speed bit
@@:
	test	eax, CONNECT_STATUS_CHANGE
	jz  	@f			;Br if no change in connect status
	or  	bl, 00000100b		;Set connect status change bit
@@:
	pop 	dx
	pop 	eax
	clc
	ret
UsbGetRootHubPortStatus	endp


;---------------------------------------;
; UsbEnableRootHubPort                  ;
;---------------------------------------;--------------------------------------;
; This function powers, resets, and enables one port on the root hub.          ;
;                                                                              ;
; Input: AH = Port number within hub                                           ;
;                                                                              ;
; Output: CF = Clear if the hub port was enabled successfully                  ;
;              Set if the hub port was not enabled                             ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbEnableRootHubPort	proc near
	pushad

	shl 	ah, 2			;AH = 4/8 for port 1/2
	mov 	dx, OHCI_RH_PORT1_STATUS - 4
	add 	dl, ah			;DX = Port 1/2 control reg

	mov  	eax, SET_PORT_ENABLE
	call	WriteUsbOperRegDword	;Enable the port

	mov 	cx, 29Ah		;10ms / 15us
	call	pm_fixed_delay		;Delay 10ms

	mov	eax, SET_PORT_RESET	;Make reset signaling active
	call	WriteUsbOperRegDword

EnablePortWaitForReset:
	call	ReadUsbOperRegDword
	test	eax, PORT_RESET_STATUS
	jnz	EnablePortWaitForReset	;Br if reset still active

	mov	eax, PORT_RESET_STATUS_CHANGE
	call	WriteUsbOperRegDword	;Clear reset status change bit

	mov	cx, (100 * 1000) / 15	;100ms / 15us
	call	pm_fixed_delay		;Delay 100ms

ifdef HC_PATCH_NAT_OHCI
	mov  	eax, SET_PORT_ENABLE
	call	WriteUsbOperRegDword	;Enable the port
endif

	popad
	clc
	ret
UsbEnableRootHubPort	endp


;---------------------------------------;
; UsbDisableRootHubPort                 ;
;---------------------------------------;--------------------------------------;
; This function disables one port on a USB hub or the root hub.                ;
;                                                                              ;
; Input: AH = Port number within hub                                           ;
;                                                                              ;
; Output: CF = Clear if the hub port was disabled successfully                 ;
;              Set if the hub port was not disabled                            ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbDisableRootHubPort	proc near
	pusha

	shl 	ah, 2			;AH = 4/8 for port 1/2
	mov 	dx, OHCI_RH_PORT1_STATUS - 4
	add 	dl, ah			;DX = Port 1/2 control reg
	call	ReadUsbOperRegDword	;AX = value from port control reg
	or 	eax, CLEAR_PORT_ENABLE	;Clear enable bit
	call	WriteUsbOperRegDword

	popa
	clc
	ret
UsbDisableRootHubPort	endp


;---------------------------------------;
; UsbHcCheckActive                      ;
;---------------------------------------;--------------------------------------;
; This function returns a flag indicating if the USB host controller is        ;
; currently active and under BIOS control.                                     ;
;                                                                              ;
; Input: Nothing (even DS and ES are undefined)                                ;
;                                                                              ;
; Output: CL = Flags                                                           ;
;                Bit[7:4] = Reserved                                           ;
;                Bit[3:1] = Number of ports on root hub of host controller     ;
;                Bit[0]   = 1 if USB BIOS is running host controller           ;
;                           0 if USB BIOS is not running host controller       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbHcCheckActive	proc near
	pushad

;...............................................
;	call	GetUsbHcBusDevFunc	;Returns BX = b/d/f, destroys AX,ECX,EDX
;
;	call	UsbHcChipsetGetStatus	;Returns CL[4:0] = USB & 60/64 r/w trap flags
;	test	cl, 00010000b		;Bit 4 enables SMI on HC IRQ if set
;	jz	CheckActiveNo		;Br if HC int not routed to SMI
;
;	mov	di, USB_BASE_ADDRESS
;	mov	si, PCI_REG_ADDRESS_WORD
;	call	smi_pci_read_cfg	;Returns CX = I/O base of HC
;	and	cl, 0FCh		;Mask out 2 reserved bits
;
;	mov	dx, USB_COMMAND_REG	;DX = command reg
;	add	dx, cx			;DX = command reg + USB HC base addr
;	in	ax, dx
;	test	ax, HOST_CONTROLLER_RUN
;	jz	CheckActiveNo		;Br if HC is not running

CheckActiveYes:
	popad
	mov	cl, 00000101b		;Indicate USB BIOS is in control and running
	ret				;   and HC has two root hub ports

CheckActiveNo:
	popad
	mov	cl, 00000100b		;Indicate USB BIOS is not in control or not running
	ret				;   and HC has two root hub ports
UsbHcCheckActive	endp


;---------------------------------------;
; GetUsbHcBusDevFunc                    ;
;---------------------------------------;--------------------------------------;
; This function returns the PCI bus, device, and function number of the USB    ;
; host controller.                                                             ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: BH = PCI Bus number                                                  ;
;         BL = Device / Function number                                        ;
;              Bits 7-3: PCI device number                                     ;
;              Bits 2-0: Function number within the device                     ;
;         CF = Clear if USB host controller was found, set if not found        ;
;                                                                              ;
; Destroys: AX, ECX, EDX                                                       ;
;------------------------------------------------------------------------------;
GetUsbHcBusDevFunc	proc near

; Find the PCI bus/device/function number of the USB host controller by calling
; a chipset hook to get the Device/Vendor ID of the USB HC and then search for
; that HC on the PCI bus.

ifdef DOS_DEBUG
	mov	ecx, USB_HC_CLASS_CODE	;Defined by UHCI.EQU or OHCI.EQU
	xor	si, si
	mov	ax, 0B103h		;PCI Find Class function
	int	1Ah			;Returns CF, BX=bus/dev/func of USB HC
else
	call	UsbGetHostControllerId	;Returns EDX = Vendor/Device ID
	or	edx, edx
	clc
	jz	UsbFindDone		;Br if hook returned bus/dev/func #
	call	smi_pci_find_device	;Returns CF, BX=bus/dev/func of USB HC
endif

UsbFindDone:
	ret
GetUsbHcBusDevFunc	endp


;---------------------------------------;
; UsbHcInit                             ;
;---------------------------------------;--------------------------------------;
; This function initializes the host controller, its schedule, and all other   ;
; associated data structures, and then starts the host controller.             ;
;                                                                              ;
; Input:  DS = ES = Usb Data Area                                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbHcInit	proc near
	pushad

ifdef DOS_DEBUG
	push	ds
	push	es
	push	DOS_DEBUG_DATA_AREA
	push	DOS_DEBUG_DATA_AREA
	pop	ds
	pop	es

	mov	InitializationFlags, 0	;Set to auto enum, beep
endif

	call	UsbDataInit		;Initialize any data structures

; Set the TdPoolPtr and EdPoolPtr fields in the DeviceTable array to each
; point to TD and ED in the TdPool / EdPool.

	mov	si, offset DeviceTable	;SI = ptr to entry for device address 0
	mov	di, offset TdPool	;DI = ptr to first entry in TdPool (TdDummy)
	mov	bx, offset EdPool	;BX = ptr to first entry in EdPool (EdDummy)
@@:
	mov	(DeviceTableEntry ptr [si]).TdPoolPtr, di
	mov	(DeviceTableEntry ptr [si]).EdPoolPtr, bx
	add	si, size DeviceTableEntry ;SI = ptr to next DeviceTableEntry
	add	di, size General_Transfer_Descriptor ;DI = ptr to next TD in TdPool
	add	bx, size Endpoint_Descriptor ;BX = ptr to next ED in EdPool
	cmp	si, offset DeviceTableEnd
	jb	@b			;Br if more DeviceTableEntries

; Initialize the flag StatusChangeInProgress to indicate that a root hub status
; change is in progress so that we will not try to process a root hub status
; change interrupt during initialization.

	mov	StatusChangeInProgress, TRUE

; Find the PCI bus/device/function number of the USB host controller and
; store it for later use.

	call	GetUsbHcBusDevFunc	;Returns BX = b/d/f, destroys AX,ECX,ESI
	jc	UsbInitDone		;Br if USB HC not found
	mov	UsbHcBusDevFuncNum, bx	;Save bus/dev/func for later

; Move OHCI memory mapped registers to C800:0 for debugging. - TEMPORARY

ifdef DOS_DEBUG
	mov	bx, UsbHcBusDevFuncNum	;BX = HC's PCI bus/dev/function number
	mov	di, USB_BASE_ADDRESS
	mov	ecx, 0C8000h
	mov	si, PCI_REG_ADDRESS_DWORD
	call	smi_pci_write_cfg
endif

; Get I/O base address of the HC and store it in the variable
; Oper_Reg_Base_Address in the USB data segment.

	mov	bx, UsbHcBusDevFuncNum	;BX = HC's PCI bus/dev/function number
	mov	di, PCI_REG_VENDID 
	mov	si, PCI_REG_ADDRESS_DWORD
	call	smi_pci_read_cfg	;Returns ECX = Vendor/Device ID
	inc	ecx
	jz	UsbInitDone		;Br if HC is disabled

	mov	di, USB_BASE_ADDRESS
	mov	si, PCI_REG_ADDRESS_DWORD
	call	smi_pci_read_cfg	;Returns ECX = memory base of HC
	and	cl, 0F0h		;Clear reserved bits
	mov	Oper_Reg_Base_Address, ecx

; Set ports 1 and 2 to Removable ;Need?.......................

	mov	dx, OHCI_RH_DESCRIPTOR_B ;set these ports removable
	call	ReadUsbOperRegDword
	and	ax, 0fff9h
	call	WriteUsbOperRegDword

; First stop the host controller if it is at all active
; 1.Software Reset the host controller -> USB Suspend state
;   This HC_RESET bit is cleaed by HC upon the completion of the reset operation
; 2.Then let HC go to UsbReset state to reset Root Hub and downstream ports,
;   and wait for the assertion of reset on the USB (P43).

	mov	dx, OHCI_COMMAND_STATUS	;Issue a software reset
	mov	eax, HC_RESET		;and HC go to UsbSuspend state
	call	WriteUsbOperRegDword

	mov	cx, 86h 		;wait for ensure HC stay in UsbSuspend > 2ms
	call	pm_fixed_delay		;134*15us = 2 ms, Delay 2ms (see p42)

	mov	dx, OHCI_CONTROL_REG	;let HC go to UsbReset state
	mov	eax, USBRESET		;for reset Root Hub and downstream ports
	call	WriteUsbOperRegDword	;(see p43)

	mov	cx, 029Ah		;wait 10ms for assertion of reset
	call	pm_fixed_delay		;Delay 10ms

; Set the HcHCCA register

	mov	eax, HcdDataArea	;EAX = absolute addr of HCCA
	mov	dx, OHCI_HCCA_REG
	call	WriteUsbOperRegDword	;Write addr of frame list into HC

;;;;; Pre initialize the periodic list to contain all TERMINATE entries.
;;;;; This will allow control transactions to take place, but will
;;;;; prevent any HID or Hub polling from taking place.  The HID and Hub polling
;;;;; TDs will be put into the schedule after the USB bus is initially enumerated.
;;;;
;;;;    mov     di, offset INTERRUPTLIST
;;;;PreInitInterruptListNextRepeat:
;;;;    mov     dword ptr [di], TERMINATE ;Set frame list entry to be idle
;;;;    add     di, 4                   ;DI = ptr to next frame list entry
;;;;    cmp     di, offset INTERRUPTLIST + (FRAME_LIST_SIZE * 4)
;;;;    jb      PreInitInterruptListNextRepeat  ;Br if entire frame list is not done

;Initial the periodic list
; Initialize the HccaInterruptTable's 32 entries

	mov	di, offset INTERRUPTLIST

InitInterruptListNextRepeat:
	mov	cx, ACTIVE_FRAMES	;CX = number of active frames
	mov	eax, HcdDataArea	;EAX = seg containing TD pool
	add	eax, offset EdPool	;EAX = addr of first ED in pool (EdDummy)
	add	eax, size Endpoint_Descriptor	;EAX = addr of next ED (EdHid[0])

InitInterruptListNextFrame:
	stosd				;Set frame list entry = ED[cx]
	add	eax, size Endpoint_Descriptor	;EAX = addr of next ED

	mov	bx, IDLE_FRAMES 	;BX = # of idle frames between actives
InitInterruptListNextIdle:
	mov	dword ptr [di], TERMINATE ;Set frame list entry to be idle
	add	di, 4			;DI = ptr to next frame list entry
	dec	bx			;Dec idle frame counter
	jnz	InitInterruptListNextIdle	;Br if more idle frames to insert

	loop	InitInterruptListNextFrame	;Loop for all active frames

	cmp	di, offset INTERRUPTLIST + (FRAME_LIST_SIZE * 4)
	jb	InitInterruptListNextRepeat	;Br if entire frame list is not done

; Now "hook" the first interrupt list entry and point it to the array of Hub
; EDs.  Then link the EDs in the EdHub array together in a linear linked list.

	mov	di, offset INTERRUPTLIST;DI = ptr to first interrupt list entry
	mov	ebx, dword ptr [di]	;Save contents of first interrupt list entry
	mov	eax, HcdDataArea	;EAX = seg containing EdPool
	add	eax, offset EdHub	;EAX = addr of first hub ED
	stosd				;Set frame list entry to point to root hub TD

	mov	di, offset EdHub	;DI = ptr to first ED in EdHub array
	movzx	eax, di
	add	eax, size Endpoint_Descriptor
	add	eax, HcdDataArea	;EAX = ptr to next ED
	mov	edx, offset TdHub	;EDX = offset within usbdseg of 1st Hub TD
	add	edx, HcdDataArea	;EDX = addr of 1st Hub TD
	mov	cx, HUB_DEVICE_LIMIT - 1

InitHubListNext:
	mov	(Endpoint_Descriptor ptr [di]).Next_ED, eax
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Head_Pointer, edx
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Tail_Pointer, TERMINATE
	add	eax, size Endpoint_Descriptor
	add	edx, size General_Transfer_Descriptor
	add	di, size Endpoint_Descriptor
	loop	InitHubListNext		;Fill all TdHub EDs except last

	; Link last hub ED to the saved contents of the first frame list entry
	mov	(Endpoint_Descriptor ptr [di]).Next_ED, ebx
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Head_Pointer, edx
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Tail_Pointer, TERMINATE

; Initialize the Endpoint Descriptors into a two dimensional array.  The
; array has ACTIVE_FRAMES number of rows (each row is headed by one frame list
; entry).  The array has TDS_PER_FRAME number of columns.  The last TD in each
; row has its link pointer set to point to the PeriodicTd.

	mov	cl, 0			;CL will be row counter (0..ACTIVE_FRAMES-1)

InitEdArrayNextRow:
	mov	ch, 0			;CH will be column counter (0..EDS_PER_FRAME-1)

InitEdArrayNextCol:
	mov	al, ACTIVE_FRAMES	;AL = number of rows
	mul	ch			;AL = index of ED in row 0 of cur column
	add	al, cl			;AL = index of ED in cur row of cur column
	mov	bl, size Endpoint_Descriptor
	mul	bl			;AX = offset within EdHid array of current ED
	add	ax, offset EdHid	;AX = offset within usbdseg of current ED
	mov	di, ax			;DI = offset within usbdseg of current ED

	mov	eax, TERMINATE		;EAX = ptr to NULL
	cmp	ch, EDS_PER_FRAME - 1
	jae	InitEdLastCol		;Br if cur ED is last col in its row

	movzx	eax, di 		;EAX = offset within usbdseg of current TD
	add	eax, size Endpoint_Descriptor * ACTIVE_FRAMES
	add	eax, HcdDataArea
					;EAX = abs addr of next ED in row
InitEdLastCol:
	mov	(Endpoint_Descriptor ptr [di]).Next_ED, eax ;Link the ED list
	;Link each InterruptEd with one InterruptTd
	mov	al, ACTIVE_FRAMES	;AL = number of rows
	mul	ch			;AL = index of ED in row 0 of cur column
	add	al, cl			;AL = index of ED in cur row of cur column
	mov	bl, size General_Transfer_Descriptor
	mul	bl			;AX = offset within TdHid array of current TD
	add	ax, offset TdHid	;AX = offset within usbdseg of current TD
	movzx	eax, ax
	add	eax, HcdDataArea	;EAX = addr of current TD
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Head_Pointer, eax
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Tail_Pointer, TERMINATE

	inc	ch
	cmp	ch, EDS_PER_FRAME
	jb	InitEdArrayNextCol	;Br if more cols to do

	inc	cl
	cmp	cl, ACTIVE_FRAMES
	jb	InitEdArrayNextRow	;Br if more rows to do

; Now "hook" the last HID ED in the first row of the HID array and point it
; to EdRepeat.

	mov	al, HID_DEVICE_LIMIT - ACTIVE_FRAMES ;AL = array index of last HidEd in first row
	mov	ah, size Endpoint_Descriptor
	mul	ah			;AX = offset of ED within HID ED array
	mov	di, ax
	add	di, offset EdHid	;DI = offset of last EdHid in first row

	mov	eax, HcdDataArea	;EAX = seg containing TDs
	add	eax, offset EdRepeat	;EAX = addr of EdRepeat
	xchg	(Endpoint_Descriptor ptr [di]).Next_ED, eax
	mov	di, offset EdRepeat
	mov	(Endpoint_Descriptor ptr [di]).Next_ED, eax
	mov	eax, HcdDataArea	;EAX = seg containing TDs
	add	eax, offset TdRepeat	;EAX = addr of TdRepeat
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Head_Pointer, eax
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Tail_Pointer, TERMINATE

; Initialize the body of each Endpoint Descriptor and its GTD in the HID/Hub
; list to perform an interrupt transaction on endpoint 0 of a device.  All EDs
; and GTDs in the list will initially be disabled (skip=true,ActiveFlag=FALSE).
; As devices are found that need to be polled, the ED/TD corresponding to the
; device's device table entry will be made active.

	mov	cl, 0			;CL will count EDs (0..MAX_DEVICES)
	mov	di, offset EdPool	;DI = offset of first ED in list
	mov	si, offset TdPool	;SI = offset of first TD in list

InitListNextEd:

	;Now nonactive,so skip ED, when device is connected then set to not skip

	mov	eax, SKIP_TDQ or ED_IN_PACKET or (DEFAULT_PACKET_LENGTH  shl 16) ;Set PID=In, and MaxLen
	mov	(Endpoint_Descriptor ptr [di]).ED_Control, eax

	; set Delay interrupt to 1,Condition code=not accessed
	; Data toggle=DATA0=00b,
	mov	eax, BUFFER_ROUNDING or IN_PACKET or IntD or (NOT_ACCESSED shl 28)
	mov	(General_Transfer_Descriptor ptr [si]).GTD_CONTROL,eax
	mov	(General_Transfer_Descriptor ptr [si]).CSReloadValue,eax

	; set GTD's data buffer to GTD_Setup[0]-[7],
	;     DeviceAddress for device address in UsbHcIsr,
	;     GTD_Setup[0] for ProcessKeyboardData in PollingTdCallback
	lea	ax, (General_transfer_Descriptor ptr [si]).GTD_Setup ;AX = ptr to TD's data buffer
	movzx	eax, ax 		;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(General_transfer_Descriptor ptr [si]).GTD_CURRENT_BUFFER_POINTER,eax
	add	eax, 7
	mov	(General_transfer_Descriptor ptr [si]).GTD_Buffer_End,eax
	mov	(General_transfer_Descriptor ptr [si]).GTD_Next_TD,TERMINATE
	mov	(General_Transfer_Descriptor ptr [si]).pCallback, offset cgroup:PollingTdCallback
	add	(General_Transfer_Descriptor ptr [si]).pCallback, orgbase
	mov	(General_Transfer_Descriptor ptr [si]).ActiveFlag, FALSE

	add	di, size Endpoint_Descriptor
	add	si, size General_Transfer_Descriptor
	inc	cl			;Inc ED counter(0-16 for device table entry 0-16)
	cmp	cl, MAX_DEVICES
	jbe	InitListNextEd		;Br if more EDs to init

; Setup EdRepeat and TdRepeat.  It will run a interrupt transaction to a
; nonexistant dummy device.  This will have the effect of generating a periodic
; interrupt used to generate keyboard repeat.  This ED/TD is normally inactive,
; and is only activated when a key is pressed.

	mov	di, offset EdRepeat	;DI = ptr to EdRepeat

	mov	(Endpoint_Descriptor ptr [di]).ED_Control, DUMMY_DEVICE_ADDR or ED_IN_PACKET or (DEFAULT_PACKET_LENGTH shl 16) or SKIP_TDQ
	mov	(Endpoint_Descriptor ptr [di]).Next_ED, TERMINATE
	mov	eax, HcdDataArea
	add	eax, offset TdRepeat
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Head_Pointer, eax
	mov	(Endpoint_Descriptor ptr [di]).TDQ_Tail_Pointer, TERMINATE

	mov	si, offset TdRepeat	;SI = ptr to TdRepeat
	mov	eax, BUFFER_ROUNDING or IN_PACKET or IntD or (NOT_ACCESSED shl 28) or ONE_ERROR
	mov	(General_Transfer_Descriptor ptr [si]).GTD_CONTROL, eax
	mov	(General_Transfer_Descriptor ptr [si]).CSReloadValue, eax

	lea	ax, (General_transfer_Descriptor ptr [si]).GTD_Setup ;AX = ptr to TD's data buffer
	movzx	eax, ax 		;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(General_transfer_Descriptor ptr [si]).GTD_CURRENT_BUFFER_POINTER, eax
	mov	(General_transfer_Descriptor ptr [si]).GTD_Buffer_End, eax
	mov	(General_transfer_Descriptor ptr [si]).GTD_Next_TD, TERMINATE
	mov	(General_Transfer_Descriptor ptr [si]).pCallback, offset cgroup:RepeatTdCallback
	add	(General_Transfer_Descriptor ptr [si]).pCallback, orgbase
	mov	(General_Transfer_Descriptor ptr [si]).ActiveFlag, TRUE

; Set the  periodic start time=2e67h(10% off from HcFmInterval)

	mov	dx, OHCI_PERIODIC_START
	mov	eax, 2e67h
	call	WriteUsbOperRegDword

; Read the HC's Root Hub Descriptor A register.  The lower 8 bits of this
; register indicate how many ports are on the HC's root hub.  Save this
; information for later use.

	mov 	dx, OHCI_RH_DESCRIPTOR_A
	call	ReadUsbOperRegDword	;EAX[7:0] = number of root hub ports
	mov	RootHubPortCount, al	;Save port count for later

; Hook the interrupt that has been assigned to the host controller.

ifdef DOS_DEBUG
	mov	bx, UsbHcBusDevFuncNum	;BX = HC's PCI bus/dev/function number
	mov	di, USB_IRQ_LEVEL
	mov	si, PCI_REG_ADDRESS_BYTE
	call	smi_pci_read_cfg	;Returns CL = IRQ level assigned to HC
	or	cl, cl
	jz	UsbInitDone		;Br if HC did not get an IRQ
	mov	HC_Interrupt_Level, cl

	add	cl, 8			;IRQ 0/1/../7 -> INT 8/9/../F
	cmp	cl, 10h
	jb	InitVector		;Br if IRQ 0..7
	add	cl, 70h - 10h		;Add offset of second 8259's vectors
InitVector:
	movzx	bx, cl			;BX = HC's interrupt vector
	shl	bx, 2			;BX = addr of interrupt vector to hook

	mov	ax, cs			;AX = CS
	shl	eax, 16 		;Put CS in upper half of EAX
	mov	ax, offset cgroup:UsbHcIsr ;EAX = CS:Offset of USB's ISR
	push	ds
	push	0			;Set DS = 0
	pop	ds
	mov	dword ptr [bx], eax	;Hook interrupt
	pop	ds
else

; Enable the HC's SMI generation on port 60/64 read/write and USB interrupt.
	mov	bx, UsbHcBusDevFuncNum
        call	EnableKBCTraps		;Returns CL[3:0] = 60/64 r/w trap flags
	or	cl, 10h			;Always enable SMI on USB interrupt
	call	UsbHcChipsetInit

endif

; Unmask the host controller's IRQ level in the 8259

ifdef DOS_DEBUG
	mov	cl, HC_Interrupt_Level	;CL = IRQ used by the HC (0..15)
	mov	bx, 1
	shl	bx, cl			;BX = bit map with one bit set
	not	bx			;BX = bit map with one bit clear

	in	al, 21h 		;AL = First 8259's mask reg
	and	al, bl			;Adjust mask
	out	21h, al 		;Write mask back

	in	al, 0A1h		;AL = Second 8259's mask reg
	and	al, bh			;Adjust mask
	out	0A1h, al		;Write mask back
endif

; Set the operational bit in the host controller so that power can be applied
; to the ports.

ifdef DOS_DEBUG
	mov	eax, USBOPERATIONAL
else
	mov	eax, USBOPERATIONAL or INTERRUPT_ROUTING
endif
	mov	dx, OHCI_CONTROL_REG
	call	WriteUsbOperRegDword	;Start the host controller running

; Enable global port power so that new devices can be detected.

	mov	dx, OHCI_RH_STATUS	;First enable global power
	mov	eax, SET_GLOBAL_POWER
	call	WriteUsbOperRegDword

	mov	cl, 1			;CL will count through port numbers
	mov 	dx, OHCI_RH_PORT1_STATUS;DX will count through port regs

EnablePowerNextPort:
	mov	eax, SET_PORT_POWER
	call	WriteUsbOperRegDword	;Enable individual port's power

ifdef HC_PATCH_NAT_OHCI
	push	cx
	mov	cx, 29Ah		;10ms / 15us
	call	pm_fixed_delay		;Delay 10ms
	pop	cx
endif

	add	dx, 4			;DX = next root hub status port
	inc	cl			;CL = next port number
	cmp	cl, RootHubPortCount
	jbe	EnablePowerNextPort	;Br if still more ports to check

	mov	cx, 29Ah		;10ms / 15us
	call	pm_fixed_delay		;Delay 10ms

; Set the HcFrameInterval register

	mov	dx, OHCI_FRAME_REMAINING
	call	ReadUsbOperRegDword	;EAX = HcFmRemaining register
	xor	eax, 80000000h		;Toggle FRT bit
	and	eax, 80000000h		;Save only FRT bit
	or	eax, 7FF82EDFh		;Set FSMPS to 7FFFh bits or 4095.7 bytes
	mov	dx, OHCI_FRAME_INTERVAL ;restore the HcFmInterval reg
	call	WriteUsbOperRegDword

; Start the host controller for control list only (no periodic list)

ifdef DOS_DEBUG
;        mov	eax, PERIODIC_LIST_ENABLE or CONTROL_LIST_ENABLE or USBOPERATIONAL
        mov	eax, CONTROL_LIST_ENABLE or USBOPERATIONAL
else
;        mov	eax, PERIODIC_LIST_ENABLE or CONTROL_LIST_ENABLE or USBOPERATIONAL or INTERRUPT_ROUTING
        mov	eax, CONTROL_LIST_ENABLE or USBOPERATIONAL or INTERRUPT_ROUTING
endif
	mov	dx, OHCI_CONTROL_REG
	call	WriteUsbOperRegDword	;Start the host controller running

; Check the root hub ports to see if a device is connected.  If so, then
; call UsbHubPortChange to handle the attachment of a new device.

	mov	cl, 1			;CL will count through port numbers
	mov 	dx, OHCI_RH_PORT1_STATUS;DX will count through port regs

InitRootHubNextPort:
	test	InitializationFlags, INIT_FLAG_ENUM_DISABLE
	jnz	@f			;Br if USB enum is disabled

	mov	al, 0FFh
	mov 	ah, cl			;AH = port number
	call	UsbGetRootHubPortStatus	;Returns BL,CF (ignore CF and BL bit 2)
	test	bl, 00000001b		;Test device connected bit
	jz	@f			;Br if no device connected

	call	UsbHubPortChange	;Process the connection/disconnection
@@:
	call	ReadUsbOperRegDword	;EAX = value from port 1 status reg
	and	eax, 0FFFF0000h		;Keep only the change indicator bits
	call	WriteUsbOperRegDword	;Write back to clear the change bits

	add	dx, 4			;DX = next root hub status port
	inc	cl			;CL = next port number
	cmp	cl, RootHubPortCount
	jbe	InitRootHubNextPort	;Br if still more ports to check

; Initialize the flag StatusChangeInProgress to indicate that a root hub status
; change is not in progress.

	mov	StatusChangeInProgress, FALSE

;Enable interrupts from the host controller

	mov	eax, MASTER_INTERRUPT_ENABLE or WRITEBACK_DONEHEAD_ENABLE or RH_STATUS_CHANGE_ENABLE or OWNERSHIP_CHANGE_ENABLE
	mov	dx, OHCI_INTERRUPT_ENABLE
	call	WriteUsbOperRegDword	;Enable SOF, WDH, RHSC interrupts

; Start the host controller for periodic list and control list.

ifdef DOS_DEBUG
        mov	eax, PERIODIC_LIST_ENABLE or CONTROL_LIST_ENABLE or USBOPERATIONAL
else
        mov	eax, PERIODIC_LIST_ENABLE or CONTROL_LIST_ENABLE or USBOPERATIONAL or INTERRUPT_ROUTING
endif
	mov	dx, OHCI_CONTROL_REG
	call	WriteUsbOperRegDword	;Start the host controller running

UsbInitDone:
ifdef DOS_DEBUG
	pop	es
	pop	ds
endif
	popad
	ret
_UsbHcInit	endp


;---------------------------------------;
; UsbHcClose                            ;
;---------------------------------------;--------------------------------------;
; This function shuts down and disables the USB host controller.               ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbHcClose	proc near
	pusha

ifdef DOS_DEBUG
	push	ds
	push	es
	push	DOS_DEBUG_DATA_AREA
	push	DOS_DEBUG_DATA_AREA
	pop	ds
	pop	es
endif

	push	edx
	call	GetUsbHcBusDevFunc	;Returns BX = b/d/f, destroys AX,ECX,EDX
	pop	edx
	jc	@f			;Br if USB HC not found

	mov	UsbHcBusDevFuncNum,bx

	mov	di, PCI_REG_VENDID 
	mov	si, PCI_REG_ADDRESS_DWORD
	call	smi_pci_read_cfg	;Returns ECX = Vendor/Device ID
	inc	ecx
	jz	UsbHcCloseDone		;Br if HC is disabled

	mov	di, USB_BASE_ADDRESS
	mov	si, PCI_REG_ADDRESS_DWORD
	call	smi_pci_read_cfg	;Returns ECX = memory base of HC
	and	cl, 0F0h		;Clear reserved bits
	mov	Oper_Reg_Base_Address, ecx
@@:

; Stop the host controller

	mov     eax, USBRESET
	mov 	dx, OHCI_CONTROL_REG
	call	WriteUsbOperRegDword	;Write to HC control reg

; Disable interrupts from the host controller

	mov     eax, 0ffffffffh
	mov 	dx,  OHCI_INTERRUPT_DISABLE
	call	WriteUsbOperRegDword	;Disable all HC interrupts

; Disable the HC's SMI generation on port 60/64 read/write and USB interrupt.
	mov	bx, UsbHcBusDevFuncNum
	call	UsbHcChipsetShutdown

; Mask the host controller's IRQ level in the 8259

ifdef DOS_DEBUG
	mov 	cl, HC_Interrupt_Level	;CL = IRQ used by the HC (0..15)
	mov 	bx, 1
	shl 	bx, cl			;BX = bit map with one bit set

	in  	al, 21h			;AL = First 8259's mask reg
	or  	al, bl			;Adjust mask
	out 	21h, al			;Write mask back

	in  	al, 0A1h		;AL = Second 8259's mask reg
	or  	al, bh			;Adjust mask
	out 	0A1h, al		;Write mask back
endif

UsbHcCloseDone:
ifdef DOS_DEBUG
	pop	es
	pop	ds
endif
	popa
	ret
_UsbHcClose	endp


;---------------------------------------;
; UsbHcIsr                              ;
;---------------------------------------;--------------------------------------;
; This is the main entry point that handles all interrupts generated by the    ;
; USB host controller.                                                         ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbHcIsr	proc near
	pushad

ifdef DOS_DEBUG
	push	ds
	push	es
	push	DOS_DEBUG_DATA_AREA
	push	DOS_DEBUG_DATA_AREA
	pop	ds
	pop	es
endif

; Check the interrupt status register for an ownership change.  If this bit is,
; set, it means that the O/S USB device driver is attempting to takeover control
; of the host controller.  In this case the host controller is shut down and the
; interrupt routing bit in the control register is cleared (this disables SMI
; generation and enebles standard IRQ generation from the USB host controller.

	mov	dx, OHCI_INTERRUPT_STATUS
	call	ReadUsbOperRegDword	;EAX = value from status register
	test	eax, OWNERSHIP_CHANGE
	jz	Check_root_hub_status	;Br if no O/S driver not taking control

	mov	dx, OHCI_HCCA_REG
	call	ReadUsbOperRegDword	;Read addr of USB data area
	cmp	eax, HcdDataArea
	jne	IsrReinit		;Br if O/S asking to re init USB BIOS
	call	_UsbHcClose		;Shut down the USB host controller
; Turn Off EV6 Mode
	mov	eax,80000084h
	mov	dx,0cf8h
	out	dx,eax
	jmp	short $+2
	mov	dl,0fch
	in	al,dx
	jmp	short $+2
	and	al,11101111b
	out	dx,al

        jmp     IsrTdsDone		;Exit from SMI

IsrReinit:
	cmp	byte ptr cs:[legacy_usb],0
 	jz	IsrTdsDone		;Br is USB BIOS setup Q is disabled
; Turn On EV6 Mode
	mov	eax,80000084h
	mov	dx,0cf8h
	out	dx,eax
	jmp	short $+2
	mov	dl,0fch
	in	al,dx
	jmp	short $+2
	or	al,00010000b
	out	dx,al

        movzx   ebx,word ptr cs:[usb_segment]
	shl	ebx,4
 	mov	cl,10h			;Enumerate, No Beep
 	extrn	UsbBiosInitialize:near
 	call	UsbBiosInitialize
        jmp     IsrTdsDone		;Exit from SMI
         
Check_root_hub_status:

; Check the interrupt status register for a root hub status change.  If
; this bit is set, then a device has been attached or removed from one of
; the ports on the root hub.

	mov	dx, OHCI_INTERRUPT_STATUS
	call	ReadUsbOperRegDword	;EAX = value from status register
	test	al, RH_STATUS_CHANGE
	jz	IsrRhscDone		;Br if no root hub status change

; Clear the RH_STATUS_CHANGE bit of the interrupt status register
; in the host controller

	mov	eax, RH_STATUS_CHANGE
 	call	WriteUsbOperRegDword	;Write 1 to bit to clear it

; Now check if we are already processing a root hub status change.  If
; we are not, then set the StatusChangeInProgress flag and then call
; RootHubCallback which will check for a new device attached or an existing
; device detached.

	mov	al, TRUE
	xchg	StatusChangeInProgress, al
	cmp	al, TRUE
	je	IsrRhscDone		;Br if already processing root hub change

	mov	dx, OHCI_CONTROL_REG
	call	ReadUsbOperRegDword
	and	eax, not PERIODIC_LIST_ENABLE
	call	WriteUsbOperRegDword

	call	RootHubCallback		;Handle root hub change

	mov	dx, OHCI_CONTROL_REG
	call	ReadUsbOperRegDword
	or	eax, PERIODIC_LIST_ENABLE
	call	WriteUsbOperRegDword

	mov	StatusChangeInProgress, FALSE

IsrRhscDone:

; Check the interrupt status register for a one or more TDs completing.

	mov	dx, OHCI_INTERRUPT_STATUS
	call	ReadUsbOperRegDword	;EAX = value from status register
	test	al, WRITEBACK_DONEHEAD
	jz	IsrTdsDone		;Br if no TDs have completed

; The memory dword at HCCADONEHEAD has been updated to contain the head
; pointer of the linked list of TDs that have completed.  Walk through
; this list processing TDs as we go.

IsrCheckForMoreTds:
	xor	edi, edi
	xchg	edi, HCCADONEHEAD	;EDI = abs addr of 1st completed TD
	or	edi, edi
	jz	IsrTdsDone		;Br if no TDs in list

; Clear the WRITEBACK_DONEHEAD bit of the interrupt status register
; in the host controller

	push	cx
	mov	cx,01000h

	mov	eax, WRITEBACK_DONEHEAD
 	call	WriteUsbOperRegDword	;Write 1 to bit to clear it

IsrProcessNextTd:
	sub	edi, HcdDataArea	;DI = offset of 1st completed TD
	and	di, 0FFF0h		;Ignore any lower bits that may be set
	call	ProcessTdIfNeeded	;Check if complete and do callback
	mov	edi, (General_Transfer_Descriptor ptr [di]).GTD_Next_TD
	or	edi, edi
;;	jnz	IsrProcessNextTd	;Br if more TDs in list
	loopnz	IsrProcessNextTd
	pop	cx
	jmp	IsrCheckForMoreTds	;Check if any TDs completed while processing

IsrTdsDone:

; Issue EOI to the 8259

ifdef DOS_DEBUG
	mov 	al, 20h			;AL = EOI command
	cmp 	HC_Interrupt_Level, 8
	jb  	IsrEoiPri		;Br if using IRQ 0..7 (2nd 8259 needs no EOI)
	out 	0A0h, al
	jcxz	$+2
	jcxz	$+2
IsrEoiPri:
	out 	20h, al
	jcxz	$+2
	jcxz	$+2
endif

ifdef DOS_DEBUG
	pop	es
	pop	ds
endif
	popad

ifdef DOS_DEBUG
	iret
else
	ret
endif

UsbHcIsr	endp


;---------------------------------------;
; ProcessTdIfNeeded                     ;
;---------------------------------------;--------------------------------------;
; This function examines a TD and determines if it has completed.  If the TD   ;
; has completed, the TD's callback routine is given control.                   ;
;                                                                              ;
; Input:  DS:DI = Pointer to TD that completed                                 ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ProcessTdIfNeeded	proc near

	cmp 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE
	jne 	@f			;Br if TD is not active
	cmp 	(General_Transfer_Descriptor ptr [di]).pCallback, 0
	jz  	@f			;Br if TD's callback ptr is NULL
	call	(General_Transfer_Descriptor ptr [di]).pCallback
@@:
	ret
ProcessTdIfNeeded	endp


;---------------------------------------;
; PollingTdCallback                     ;
;---------------------------------------;--------------------------------------;
; This function is called when a polling TD from the TD pool completes an      ;
; interrupt transaction to its assigned device.  This routine should process   ;
; any data in the TD's data buffer, handle any errors, and then copy the       ;
; TD's CSReloadValue field into its TD_Control field to put the TD back        ;
; into service.                                                                ;
;                                                                              ;
; Input:  DS:DI = Pointer to TD that completed                                 ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
PollingTdCallback	proc near
	push	eax
	push	si

	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

; If any error bit is set in the TD's status field, ignore the TD's data.

	test	(General_Transfer_Descriptor ptr [di]).GTD_Control, STATUS_FIELD
	jnz	PollingTdError

; Search through the device table and find the entry associated with this
; polling TD by looking at each DeviceTableEntry's TdPoolPtr.

	mov	bx, offset DeviceTable	;BX = ptr to DeviceTable[0]
FindEntryNextEntry:
	cmp	(DeviceTableEntry ptr [bx]).Present, TRUE
	jne	FindEntrySkipEntry	;Br if this DeviceTableEntry is not in use
	cmp	(DeviceTableEntry ptr [bx]).TdPoolPtr, di
	je	FindEntryFound		;Br if matching entry found

FindEntrySkipEntry:
	add	bx, size DeviceTableEntry
	cmp	bx, offset DeviceTableEnd
	jb	FindEntryNextEntry	;Br if more entries to check
	jmp	short PollingTdError	;Could not find accociated DeviceTableEntry
FindEntryFound:

; BX now points to the DeviceTableEntry that goes with this TD.
; Set DS:SI = ptr to data (GTD_Setup[0]),  AH = USB device address
; CX = 11 bit time stamp value (0 - 7FF), and call device's callback function.

	mov	dx, OHCI_CONTROL_REG
	call	ReadUsbOperRegDword
	and	eax, not PERIODIC_LIST_ENABLE
	call	WriteUsbOperRegDword

 	mov	dx, OHCI_FRAME_NUMBER
	call	ReadUsbOperRegDword	;EAX = Frame number (0 - FFFF)
	and	ax, 07FFh		;Limit to 11 bits
	mov	cx, ax			;BX[10:0] = Frame number

	mov	ah, (DeviceTableEntry ptr [bx]).DeviceAddress
	lea	si, (General_Transfer_Descriptor ptr [di]).GTD_Setup

	call	(DeviceTableEntry ptr [bx]).pDeviceCallback

	mov	dx, OHCI_CONTROL_REG
	call	ReadUsbOperRegDword
	or	eax, PERIODIC_LIST_ENABLE
	call	WriteUsbOperRegDword

PollingTdError:

; Reset the TD's control and buffer pointer fields to their original values.

	mov 	eax, (General_Transfer_Descriptor ptr [di]).CSReloadValue
	mov 	(General_Transfer_Descriptor ptr [di]).GTD_Control, eax

	lea	ax, (General_transfer_Descriptor ptr [di]).GTD_Setup ;AX = ptr to TD's data buffer
	movzx	eax, ax			;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
        mov     (General_transfer_Descriptor ptr [di]).GTD_Current_Buffer_Pointer, eax

; Rebind the TD to its parent ED.

	mov	si, (DeviceTableEntry ptr [bx]).EdPoolPtr
	movzx	eax, di			;EAX = offset of this TD
	add	eax, HcdDataArea	;EAX = addr of this TD
	and	(Endpoint_Descriptor ptr [si]).TDQ_Head_Pointer, TOGGLE_CARRY
	or	(Endpoint_Descriptor ptr [si]).TDQ_Head_Pointer, eax

	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

	pop     si
	pop 	eax
	ret
PollingTdCallback	endp


;---------------------------------------;
; ControlTdCallback                     ;
;---------------------------------------;--------------------------------------;
; This function is called when the ControlSetup and ControlData TDs complete a ;
; control transaction to the assigned device.                                  ;
;                                                                              ;
; Input:  DS:DI = Pointer to TD that completed                                 ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ControlTdCallback	proc near
	push	eax

; Check to see if the TD that just completed has any error bits set.  If
; any of the ControlTds (Setup, Data, or Status) complete with an error, set
; ActiveFlag of the TdControlStatus and copy the error information from the
; TD that just completed into the TdControlStatus.

	mov 	eax, (General_Transfer_Descriptor ptr [di]).GTD_Control
	shr	eax, 28			;AL[3:0] = Completion status
	or	al, al
	jz  	ControlDone		;Br if the TD completed with no error

	;----------------------------------------------------------------------
	; Patch for Compaq OHCI HC which reports DataUnderrun error on any
	; short packet (even if buffer rounding is enabled).
	ifdef HC_PATCH_COMPAQ_OHCI
	cmp	al, DATA_UNDERRUN
	je	ControlDone		;Br if DataUnderrun error
	endif
	;----------------------------------------------------------------------

	shl	eax, 28			;EAX[31:28] = Completion status
	or 	TdControlStatus.GTD_Control, eax
	mov 	TdControlStatus.ActiveFlag, FALSE

; Make the TD that just completed inactive.  It may be the TdControlSetup,
; one of the TdControlDatas, or the TdControlStatus.

ControlDone:
	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	pop 	eax
	ret
ControlTdCallback	endp


;---------------------------------------;
; RootHubCallback                       ;
;---------------------------------------;--------------------------------------;
; This function is called when a device is attached or removed from a port on  ;
; the root hub.  OHCI controllers can generate a root hub status change for    ;
; the purpose of calling this routine.                                         ;
;                                                                              ;
; Input: DS = ES = HCD Data Area                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
RootHubCallback	proc near
	push	eax
	push	dx
	push	si

; Mask the Host Controller interrupt so the ISR does not get re-entered due
; to any interrupt from any TDs that complete in frames while we are
; configuring a new device that has just been plugged in.

	mov     eax, 80000000h
	mov 	dx,  OHCI_INTERRUPT_DISABLE
	call	WriteUsbOperRegDword	;Disable all HC interrupts

ifdef HC_PATCH_ALI_OHCI
	xor 	eax, eax
	mov 	dx, OHCI_INTERRUPT_ENABLE
	call	WriteUsbOperRegDword	;Disable all HC interrupts
endif

; Check all ports on the root hub for any change in connect status.  If the
; connect status has been changed on any of these ports, then call the
; routine UsbHubPortChange for each changed port.

	mov	cl, 1			;CL will count through port numbers
	mov 	dx, OHCI_RH_PORT1_STATUS;DX will count through port regs

RootHubNextPort:
	call	ReadUsbOperRegDword	;EAX = value from port status reg
	test	eax, CONNECT_STATUS_CHANGE
	jz  	@f			;Br if no change for port

	mov 	al, 0FFh		;AL = device addr (FF=root hub)
	mov 	ah, cl			;AH = port number
	call	UsbHubPortChange	;Process the connection/disconnection
@@:
	call	ReadUsbOperRegDword	;EAX = value from port status reg
	jcxz	$+2			;Delay
	jcxz	$+2
	and	eax, 0FFFF0000h		;Keep only the change indicator bits
	call	WriteUsbOperRegDword	;Write back to clear the change bits

	add	dx, 4			;DX = next root hub status port
	inc	cl			;CL = next port number
	cmp	cl, RootHubPortCount
	jbe	RootHubNextPort		;Br if still more ports to check

; Renable interrupts from the host controller

ifdef HC_PATCH_ALI_OHCI
	mov	eax, MASTER_INTERRUPT_ENABLE or WRITEBACK_DONEHEAD_ENABLE or RH_STATUS_CHANGE_ENABLE or OWNERSHIP_CHANGE_ENABLE
else
	mov 	eax, MASTER_INTERRUPT_ENABLE
endif
	mov 	dx, OHCI_INTERRUPT_ENABLE
	call	WriteUsbOperRegDword	;Enable HC interrupts

	pop	si
	pop 	dx
	pop 	eax
	ret
RootHubCallback	endp


;---------------------------------------;
; RepeatTdCallback                      ;
;---------------------------------------;--------------------------------------;
; This function is called when the PeriodicTD completes a transaction.  This   ;
; TD runs a dummy interrupt transaction to a non-existant device address for   ;
; the purpose of generating a periodic timeout interrupt.  This periodic       ;
; interrupt may be used to check for new devices on the root hub etc.          ;
;                                                                              ;
; Input:  DS:DI = Pointer to TD that completed                                 ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
RepeatTdCallback	proc near
	push	eax
	push	dx
	push	si

; Call the keyboard repeat function to generate key repeats.

	call	PeriodicInterruptHandler 

; Reset the TD's control field to its original value.

	mov 	eax, (General_Transfer_Descriptor ptr [di]).CSReloadValue
	mov 	(General_Transfer_Descriptor ptr [di]).GTD_Control, eax

; Rebind the PeriodicTd to its parent ED.

	mov	si, offset EdRepeat	;SI = ptr of EdRepeat
	mov	eax, HcdDataArea
	add	eax, offset TdRepeat
	mov	(Endpoint_Descriptor ptr [si]).TDQ_Head_Pointer, eax

; Reactivate the PeriodicTd.

	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

	pop	si
	pop 	dx
	pop 	eax
	ret
RepeatTdCallback	endp


;---------------------------------------;
; EnablePeriodicInterrupt		;
;---------------------------------------;--------------------------------------;
; This function enables the periodic interrupt.                                ;
;                                                                              ;
; Input: DS = ES = HCD Data Area                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
EnablePeriodicInterrupt	proc	near	
	push	eax
	push	si
	push	di

; Reset the TD's control field to its original value.

	mov	di, offset TdRepeat	;DI = ptr to TdRepeat
	mov 	eax, (General_Transfer_Descriptor ptr [di]).CSReloadValue
	mov 	(General_Transfer_Descriptor ptr [di]).GTD_Control, eax

; Rebind the PeriodicTd to its parent ED.

	mov	si, offset EdRepeat	;SI = ptr of EdRepeat
	mov	eax, HcdDataArea
	add	eax, offset TdRepeat
	mov	(Endpoint_Descriptor ptr [si]).TDQ_Head_Pointer, eax

; Reactivate the PeriodicTd.

	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Clear EdRepeat's Skip bit.

	and	(Endpoint_Descriptor ptr [si]).ED_Control, not SKIP_TDQ

	pop 	di
	pop	si
	pop 	eax
	ret
EnablePeriodicInterrupt	endp


;---------------------------------------;
; DisablePeriodicInterrupt              ;
;---------------------------------------;--------------------------------------;
; This function enables the periodic interrupt.                                ;
;                                                                              ;
; Input:  DS = ES = HCD Data Area                                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisablePeriodicInterrupt	proc	near
	push	di

	mov	di, offset TdRepeat	;DI = ptr to TdRepeat
	mov 	(General_Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	mov	di, offset EdRepeat	;DI = ptr of EdRepeat
	or	(Endpoint_Descriptor ptr [di]).ED_Control, SKIP_TDQ

	pop	di
	ret
DisablePeriodicInterrupt	endp


;---------------------------------------;
; ReadUsbOperRegDword                   ;
;---------------------------------------;--------------------------------------;
; This function reads a dword from the given register in the USB host          ;
; controller.                                                                  ;
;                                                                              ;
; Input:  DX = Register offset to read                                         ;
;         DS = Segment containing Oper_Reg_Base_Address variable               ;
;                                                                              ;
; Output: EAX = Value read from register                                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ReadUsbOperRegDword	proc	near
ifdef DOS_DEBUG
	push	esi
	push	ds
	mov 	esi, Oper_Reg_Base_Address
	shr	esi, 4
	mov	ds, si
	mov	si, dx
	mov 	eax, [si]
	pop	ds
	pop	esi
else
	push	dx
	push    esi
	push	ds
	movzx   esi, dx
	add 	esi, Oper_Reg_Base_Address
	push	0000h
	pop	ds
	mov  	eax, [esi]
	pop	ds
	pop     esi
	pop 	dx
endif
	ret
ReadUsbOperRegDword	endp


;---------------------------------------;
; WriteUsbOperRegDword                  ;
;---------------------------------------;--------------------------------------;
; This function writes a dword to the given register in the USB host           ;
; controller.                                                                  ;
;                                                                              ;
; Input:  DX = Register offset to write                                        ;
;         EAX = Value to write to register                                     ;
;         DS = Segment containing Oper_Reg_Base_Address variable               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
WriteUsbOperRegDword	proc	near
ifdef DOS_DEBUG
	push	esi
	push	ds
	mov 	esi, Oper_Reg_Base_Address
	shr	esi, 4
	mov	ds, si
	mov	si, dx
	mov 	[si], eax
	pop	ds
	pop	esi
else
	push	dx
	push    esi
	push	ds
	movzx   esi, dx
	add 	esi, Oper_Reg_Base_Address
	push	0000h
	pop	ds
	mov 	[esi], eax
	pop	ds
	pop     esi
	pop 	dx
endif
	ret
WriteUsbOperRegDword	endp

_text	ends
	end
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
