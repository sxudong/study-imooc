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

include makeflag.equ
include uhci.equ
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
	mov	dx,USB_COMMAND_REG
	call	ReadUsbIoRegWord		;AX = contents of USB command reg
	test	ax,CONFIGURE_FLAG
	jnz	@f				;Br if USB HC is already configured
	call	_UsbHcInit			;Re-Init the USB HC after O/S shutdown
	ret
@@:
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
; Input:  AL = USB device address to start polling                             ;
;         AH = Endpoint within device to poll                                  ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbActivatePolling	proc near

	pushad
	mov	bx, ax			;BX = Device addr / Endpoint
	dec	al
	cmp	al, MAX_DEVICES
	jae	ActivateDone		;Br if device number is too high

; Get a pointer to the device's TD in the TdPool.

	mov	ah, size Transfer_Descriptor
	mul	ah			;AX = offset of TD within TD pool
	mov	di, ax
	add	di, offset TdPool	;DI = offset of TD

; Get a pointer to the device's entry in the DeviceTable.

	mov	al, size DeviceTableEntry
	mul	bl			;AX = offset of entry within DeviceTable
	mov	si, ax
	add	si, offset DeviceTable	;SI = ptr to entry for device

; Set the endpoint field in the TD's Token.

	and	(Transfer_Descriptor ptr [di]).TD_Token, not ENDPOINT
	movzx	eax, bh			;EAX = Endpoint
	shl	eax, 15			;Put endpoint in bit 18:15
	or	(Transfer_Descriptor ptr [di]).TD_Token, eax

; Make the TD active and set the high/low speed flag in the TD's
; TD_Control_Status and CSReloadValue.

	movzx	eax, (DeviceTableEntry ptr [si]).LowSpeedFlag ;AL = 0/1 for hi/lo
	shl	eax, 26
        or	eax, ACTIVE OR INTERRUPT_ON_COMPLETE OR THREE_ERRORS
	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, eax
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

ActivateDone:
	popad
	ret
_UsbActivatePolling	endp


;---------------------------------------;
; UsbDeactivatePolling                  ;
;---------------------------------------;--------------------------------------;
; This function deactivates the polling TD for the given device.               ;
;                                                                              ;
; Input:  AL = USB device address to stop polling                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbDeactivatePolling	proc near
	pusha
	dec	al
	cmp	al, MAX_DEVICES
	jae	ActivateDone		;Br if device number is too high

	mov	ah, size Transfer_Descriptor
	mul	ah			;AX = offset of TD within pool
	mov	di, ax
	add	di, offset TdPool 	;DI = offset of TD

	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, THREE_ERRORS 
	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, THREE_ERRORS 
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

ActivateDone:
	popa
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
	xor	ebp, ebp		;Build abs addr of data area in EBP
	mov	bp, es
	shl	ebp, 4
	movzx	edi, di
	add	ebp, edi		;EBP = abs addr of data area

; Build the device request in the data area of the TdControlSetup

	mov	di, offset TdControlSetup.DataArea
	mov	(DeviceRequest ptr [di]).RequestType, bl
	mov	(DeviceRequest ptr [di]).RequestCode, bh
	mov	(DeviceRequest ptr [di]).Value, cx
	mov	(DeviceRequest ptr [di]).Index, dx
	mov	(DeviceRequest ptr [di]).DataLength, si

; Init Active flag in all data TDs to FALSE.

	mov	di, offset TdControlData ;DI = ptr of TdControlData
	mov	cx, CONTROL_DATA_TD_COUNT

DevReqInitNextTd:
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE
	add	di, size Transfer_Descriptor ;Point to next data TD
	loop	DevReqInitNextTd

; Prepare some registers that will be used in building the TDs below.
; SI  contains the data length.
; EBP contains the absolute address of the data buffer.
; DL  will contain the request type (bit 7 = 0/1 for Out/In).
; ECX will contain the device address and endpoint shifted and ready to go
;     into the TDs' token field.
; BX  will contain a pointer to the DeviceTableEntry for the given device.
; DI  will be left free to use as a pointer to the TD being built.
; EAX will be left free to use as a scratch register.

	movzx	dx, ah			;DX[3:0] = Endpoint (0-F)
	shl	dx, 7			;DX[10:7] = Endpoint (0-F)
	movzx	ecx, al			;ECX[6:0] = Device address (00-7F)
	or	cx, dx			;ECX[10:0] = Device address / endpoint
	shl	ecx, 8			;ECX[18:8] = Device address / endpoint

	mov	dl, bl			;DL = Request type

	mov	ah, size DeviceTableEntry
	mul	ah			;AX = USB device address * table entry size
	mov	bx, ax			;BX = USB device address * table entry size
	add	bx, offset DeviceTable	;BX = ptr to DeviceTableEntry

; Fill in various fields in the TdControlSetup.
; The TD_Link_Pointer field will point to the TdControlData if data will
;   be sent/received or to the TdControlStatus if no data is expected.
; The TD_Control_Status field will be set to active and interrupt on complete.
; The TD_Token field will contain the packet size (size of DeviceRequest
;   struc), the device address, endpoint, and a setup PID.
; The TD_Buffer_Pointer field will point to the TD's DataArea buffer which
;   was just initialized to contain a DeviceRequest struc.
; The CSReloadValue field will contain 0 because this is a "one shot" packet.
; The pCallback will be set to point to the ControlTdCallback routine.
; The ActiveFlag field will be set to TRUE.

	mov	di, offset TdControlSetup ;DI = ptr to TdControlSetup

	mov	eax, offset TdControlData ;EAX = abs addr of TdControlData
	or	si, si
	jnz	@f			;Br if data length is non-zero
	mov	eax, offset TdControlStatus ;EAX = abs addr of TdControlStatus
@@:	add	eax, HcdDataArea	;EAX = seg containing TDs
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax

	movzx	eax, (DeviceTableEntry ptr [bx]).LowSpeedFlag ;AL = 0/1 for hi/lo
	shl	eax, 26
	or	eax, INTERRUPT_ON_COMPLETE or THREE_ERRORS or ACTIVE
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax

	mov	eax, ecx		;EAX[18:8] = Device address / endpoint
	or	eax, SETUP_PACKET or ((size DeviceRequest - 1) shl 21) ;Set PID=Setup, and MaxLen
	mov	(Transfer_Descriptor ptr [di]).TD_Token, eax

	lea	ax, (Transfer_Descriptor ptr [di]).DataArea ;AX = ptr to TD's data buffer
	movzx	eax, ax			;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(Transfer_Descriptor ptr [di]).TD_Buffer_Pointer, eax

	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, 0
	mov	(Transfer_Descriptor ptr [di]).pCallback, offset cgroup:ControlTdCallback
	add	(Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Fill in various fields in the TdControlData array.  Enough TdControlData TDs
; must be initialized to handle the amount of data expected.  The length of the
; data transfer is currently in SI.
; The TD_Link_Pointer field will be set to the next data TD or the status TD.
; The TD_Control_Status field will be se to active and interrupt on complete.
; The TD_Token field will contain the data transfer size (still in SI),
;   the device address (in ECX), endpoint (in ECX), and an in or out PID.
; The TD_Buffer_Pointer field will point to the data buffer passed in by the
;   caller (currently in EBP).
; The CSReloadValue field will contain 0 because this is a "one shot" packet.
; The pCallback will be set to point to the ControlTdCallback routine.
; The ActiveFlag field will be set to TRUE.

	or	si, si
	jz	DevReqSkipDataTds	;Br if no data transfer (data length=0)

	cmp	si, MAX_CONTROL_DATA_SIZE
	jb	@f			;Br if not more data than we can handle
	mov	si, MAX_CONTROL_DATA_SIZE ;Limit to amount of data that we can handle
@@:
	mov	di, offset TdControlData ;DI = ptr of TdControlData
	mov	dh, 1			;Start with a data 1 token

DevReqNextDataTd:
	movzx	eax, di
	add	eax, size Transfer_Descriptor
	add	eax, HcdDataArea
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax

	movzx	eax, (DeviceTableEntry ptr [bx]).LowSpeedFlag ;AL = 0/1 for hi/lo
	shl	eax, 26
	or	eax, INTERRUPT_ON_COMPLETE or THREE_ERRORS or ACTIVE
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax

	mov	(Transfer_Descriptor ptr [di]).TD_Buffer_Pointer, ebp

	movzx	eax, si			;ESI = data length
	cmp	ax, (DeviceTableEntry ptr [bx]).Endp0MaxPacket
	jbe	@f			;Br if remaining data <= max packet size
	mov	ax, (DeviceTableEntry ptr [bx]).Endp0MaxPacket
@@:	sub	si, ax			;Subtract packet size from overall data length
	add	ebp, eax		;Update the buffer pointer
	dec	ax			;AX = packet data size - 1
	shl	eax, 21

	or	eax, ecx		;EAX[18:8] = Device address / endpoint
	mov	al, OUT_PACKET		;EAX[7:0] = OUT PID
	test	dl, 80h
	jz	@f			;Br if host sending data to device (OUT)
	mov	al, IN_PACKET		;EAX[7:0] = IN PID
@@:
	test	dh, 1
	jz	@f			;Br if this packet is a data 0 token
	or	eax, DATA_TOGGLE	;Make packet into a data 1
@@:
	mov	(Transfer_Descriptor ptr [di]).TD_Token, eax

	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, 0
	mov	(Transfer_Descriptor ptr [di]).pCallback, offset cgroup:ControlTdCallback
	add	(Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

	add	di, size Transfer_Descriptor ;Point to next data TD
	xor	dh, 1			;Toggle between data 1 / data 0
	or	si, si
	jnz	DevReqNextDataTd	;Br if more data TDs must be built

	sub	di, size Transfer_Descriptor ;Point to last data TD
	mov	eax, HcdDataArea	;EAX = seg containing TDs
	add	eax, offset TdControlStatus ;EAX = abs addr of TdControlStatus
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax

DevReqSkipDataTds:

; Fill in various fields in the TdControlStatus.
; The TD_Link_Pointer field will point to TERMINATE.
; The TD_Control_Status field will be set to active and interrupt on complete.
; The TD_Token field will contain the packet size (0), the device address,
;   endpoint, and a setup PID with opposite data direction as that defined
;   in the request type (DL).
; The TD_Buffer_Pointer field will point to the TD's DataArea buffer even
;   though we are not expecting any data transfer.
; The CSReloadValue field will contain 0 because this is a "one shot" packet.
; The pCallback will be set to point to the ControlTdCallback routine.
; The ActiveFlag field will be set to TRUE.

	mov	di, offset TdControlStatus ;DI = ptr to TdControlStatus

	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, TERMINATE

	movzx	eax, (DeviceTableEntry ptr [bx]).LowSpeedFlag ;AL = 0/1 for hi/lo
	shl	eax, 26
	or	eax, INTERRUPT_ON_COMPLETE or THREE_ERRORS or ACTIVE
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax

	mov	eax, ecx		;EAX[18:8] = Device address / endpoint
	mov	al, OUT_PACKET		;EAX[7:0] = OUT PID
	test	dl, 80h
	jnz	@f			;Br if device sending data to host (IN)
	mov	al, IN_PACKET		;EAX[7:0] = IN PID
@@:	or	eax, DATA_TOGGLE or (7FFh shl 21) ;Make packet into a data 1 and length 0
	mov	(Transfer_Descriptor ptr [di]).TD_Token, eax

	lea	ax, (Transfer_Descriptor ptr [di]).DataArea ;AX = ptr to TD's data buffer
	movzx	eax, ax			;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(Transfer_Descriptor ptr [di]).TD_Buffer_Pointer, eax

	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, 0
	mov	(Transfer_Descriptor ptr [di]).pCallback, offset cgroup:ControlTdCallback
	add	(Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Now put the TdControlSetup, TdControlData TDs, and TdControlStatus into the
; HC's schedule by pointing QhControl's link pointer to TdControlSetup.
; This will cause the HC to execute the transaction in the next active frame.

	mov	di, offset QhControl
	mov	eax, HcdDataArea	   ;EAX = seg containing TDs
	add	eax, offset TdControlSetup ;EAX = abs addr of TdControlSetup
	mov	(Q_Head ptr [di]).Q_Element_Link_Pointer, eax

; Now wait for the TdControlStatus to complete.  When it has completed,
; the ControlTdCallback will its active flag to FALSE.

	mov	di, offset TdControlStatus ;DI = ptr of TdControlStatus
	mov	bx, 20000d		;Repeat this loop this number of times
					; before giving up (~50us per iteration)
WaitForComplete:
	mov	dx, USB_STATUS_REG
	call	ReadUsbIoRegWord	;AX = value from status register
	test	al, USB_INTERRUPT
	jz	@f			;Br if HC is not asserting IRQ

ifdef DOS_DEBUG
	pushf				;Simulate IRQ from the HC
	push	cs
	cli
endif
	call	UsbHcIsr
@@:
	cmp	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE
	je	DevReqComplete		;Br if TdControlStatus completed

	mov	cx, 3
	call	pm_fixed_delay		;Delay 45us

	dec	bx			;Dec timeout counter
	jnz	WaitForComplete		;Br if not time to give up yet

	or	(Transfer_Descriptor ptr [di]).TD_Control_Status, CRC_TIMEOUT_ERROR

DevReqComplete:

; Remove the TdControlSetup, TdControlData TDs, and TdControlStatus from the
; HC's schedule by pointing QhControl's link pointer to TERMINATE.

	mov	di, offset QhControl
	mov	(Q_Head ptr [di]).Q_Element_Link_Pointer, TERMINATE

; Finally check for any error bits set in both the TdControlStatus.
; If the TD did not complete successfully, return STC.

	test	TdControlStatus.TD_Control_Status, BITSTUFF_ERROR or CRC_TIMEOUT_ERROR or NAK_RECEIVED or BABBLE_DETECTED or DATA_BUFFER_ERROR or STALLED
	stc				;Indicate error
	jnz	DeviceRequestDone	;Br if any error bits set in status
	clc				;Indicate success

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
	push	ax
	push	dx

	shl	ah, 1			;AH = 2/4 for port 1/2
	mov	dx, USB_PORT1_CONTROL - 2
	add	dl, ah			;DX = Port 1/2 control reg
	call	ReadUsbIoRegWord	;AX = value from port control reg

	xor	bl, bl			;Init the output values

	test	al, CONNECT_STATUS
	jz	@f			;Br if no device present
	or	bl, 00000001b		;Set connect status bit
@@:
	test	ax, LOW_SPEED_ATTACHED
	jz	@f			;Br if high speed device
	or	bl, 00000010b		;Set low speed bit
@@:
	test	ax, CONNECT_STATUS_CHANGE
	jz	@f			;Br if connect status not changed
	or	bl, 00000100b		;Set connect status change bit
@@:
	pop	dx
	pop	ax
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
	pusha

	shl	ah, 1			;AH = 2/4 for port 1/2
	mov	dx, USB_PORT1_CONTROL - 2
	add	dl, ah			;DX = Port 1/2 control reg
	call	ReadUsbIoRegWord	;AX = value from port control reg
	or	ax, PORT_ENABLE or PORT_RESET ;Set enable and reset bits
	call	WriteUsbIoRegWord

	mov	cx, 029Ah		;10ms / 15us
	call	pm_fixed_delay		;Delay 10ms

	call	ReadUsbIoRegWord	;AX = value from port control reg
	and	ax, not PORT_RESET	;Clear reset bit
	or	ax, PORT_ENABLE		;Set enable bit
	call	WriteUsbIoRegWord

	mov	cx, (1 * 1000) / 15	;1ms / 15us
	call	pm_fixed_delay		;Delay 10ms

	call	ReadUsbIoRegWord	;AX = value from port control reg
	or	ax, PORT_ENABLE		;Set enable bit
	call	WriteUsbIoRegWord

	mov	cx, (100 * 1000) / 15	;100ms / 15us
	call	pm_fixed_delay		;Delay 100ms

	popa
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

	shl	ah, 1			;AH = 2/4 for port 1/2
	mov	dx, USB_PORT1_CONTROL - 2
	add	dl, ah			;DX = Port 1/2 control reg
	call	ReadUsbIoRegWord	;AX = value from port control reg
	and	ax, not PORT_ENABLE	;Clear enable bit
	call	WriteUsbIoRegWord

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

	call	GetUsbHcBusDevFunc	;Returns BX = b/d/f, destroys AX,ECX,EDX

	call	UsbHcChipsetGetStatus	;Returns CL[4:0] = USB & 60/64 r/w trap flags
	test	cl, 00010000b		;Bit 4 enables SMI on HC IRQ if set
	jz	CheckActiveNo		;Br if HC int not routed to SMI

	mov	di, USB_BASE_ADDRESS
	mov	si, PCI_REG_ADDRESS_WORD
	call	smi_pci_read_cfg	;Returns CX = I/O base of HC
	and	cl, 0FCh		;Mask out 2 reserved bits

	mov	dx, USB_COMMAND_REG	;DX = command reg
	add	dx, cx			;DX = command reg + USB HC base addr
	in	ax, dx
	test	ax, HOST_CONTROLLER_RUN
	jz	CheckActiveNo		;Br if HC is not running

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

	pusha
	xor	di, di			;Start at offset 0
	mov	cx, 1000h		;Clear 4k words
	xor	ax, ax
	rep	stosw			;Clear 8k data area
	popa
endif

; Find the PCI bus/device/function number of the USB host controller and
; store it for later use.

	call	GetUsbHcBusDevFunc	;Returns BX = b/d/f, destroys AX,ECX,EDX
	jc	UsbInitDone		;Br if USB HC not found
	mov	UsbHcBusDevFuncNum, bx	;Save bus/dev/func for later

; Get I/O base address of the HC and store it in the variable
; IO_Space_Base_Address in the USB data segment.

	;mov	bx, UsbHcBusDevFuncNum	;BX = bus/dev/func # of USB HC
	mov	di, USB_BASE_ADDRESS
	mov	si, PCI_REG_ADDRESS_WORD
	call	smi_pci_read_cfg	;Returns CX = I/O base of HC
	and	cl, 0FCh		;Mask out 2 reserved bits
	mov	IO_Space_Base_Address, cx


; First stop the host controller if it is at all active

	mov	dx, USB_COMMAND_REG
	call	ReadUsbIoRegByte
	and	al, NOT HOST_CONTROLLER_RUN
	call	WriteUsbIoRegByte

;
; Disable both ports for warm boot purposes
;
	mov	dx,USB_PORT1_CONTROL
	call	ReadUsbIoRegByte
	and	al,NOT PORT_ENABLE
	call	WriteUsbIoRegByte

	mov	dx,USB_PORT2_CONTROL
	call	ReadUsbIoRegByte
	and	al,NOT PORT_ENABLE
	call	WriteUsbIoRegByte

; Reset the host controller
	mov	dx, USB_COMMAND_REG
	mov	ax, GLOBAL_RESET
	call	WriteUsbIoRegByte

	mov	cx, 6660		; 100 ms
	call	pm_fixed_delay
	
	xor	ax, ax		   	;Reset the usb command register
	call	WriteUsbIoRegByte

	call	UsbDataInit		;Initialize any data structures

; Program the frame list base address register

	mov	eax, HcdDataArea	;EAX = absolute addr of FrameList
	add	ax, offset FrameList
	mov	dx, USB_FRAME_LIST_BASE
	call	WriteUsbIoRegDword	;Write addr of frame list into HC

; Initialize the host controller's 1024 entry frame list to point to the
; first column of HID TDs.

	mov	di, offset FrameList

InitFrameListNextRepeat:
	mov	cx, ACTIVE_FRAMES	;CX = number of active frames
	mov	eax, HcdDataArea	;EAX = seg containing TD pool
	add	eax, offset TdHid	;EAX = addr of first HID TD

InitFrameListNextFrame:
	stosd				;Set frame list entry = TD[cx]
	add	eax, size Transfer_Descriptor	;EAX = addr of next TD

	mov	bx, IDLE_FRAMES		;BX = # of idle frames between actives
InitFrameListNextIdle:
	mov	dword ptr [di], TERMINATE ;Set frame list entry to be idle
	add	di, 4			;DI = ptr to next frame list entry
	dec	bx			;Dec idle frame counter
	jnz	InitFrameListNextIdle	;Br if more idle frames to insert

	loop	InitFrameListNextFrame	;Loop for all active frames

	cmp	di, offset FrameList + (FRAME_LIST_SIZE * 4)
	jb	InitFrameListNextRepeat	;Br if entire frame list is not done

; Now "hook" the first frame list entry and point it to the array of Hub
; TDs.  Then link the root hub TD and the TDs in the TdHub array together
; in a linear linked list.

	mov	di, offset FrameList	;DI = ptr to first frame list entry
	mov	ebx, dword ptr [di]	;Save contents of first frame list entry
	mov	eax, HcdDataArea	;EAX = seg containing TD pool
	add	eax, offset TdRootHub	;EAX = addr of root hub TD
	stosd				;Set frame list entry to point to root hub TD

	mov	di, offset TdRootHub	;DI = ptr to root hub TD
	mov	eax, HcdDataArea	;EAX = seg containing TDs
	add	eax, offset TdHub	;EAX = addr of first hub TD
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax

	mov	di, offset TdHub	;DI = ptr to first TD in TdHub array
	movzx	eax, di
	add	eax, HcdDataArea
	add	eax, size Transfer_Descriptor ;EAX = ptr to next TD
	mov	cx, HUB_DEVICE_LIMIT - 1

InitHubListNext:
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax
	add	eax, size Transfer_Descriptor
	add	di, size Transfer_Descriptor
	loop	InitHubListNext		;Fill all TdHub TDs except last

	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, ebx
					;Link last hub TD to the saved contents
					; of the first frame list entry

; Initialize the HID TDs into a two dimensional array.  The
; array has ACTIVE_FRAMES number of rows (each row is headed by one frame list
; entry).  The array has TDS_PER_FRAME number of columns.  The last TD in each
; row has its link pointer set to point to QhControl (except for the first row
; which has its link pointer set to TdRepeat).

	mov	edx, HcdDataArea
	add	edx, offset QhControl
	or 	edx, QUEUE_HEAD 	;EDX = Link ptr to QhControl
	mov	cl, 0			;CL will be row counter (0..ACTIVE_FRAMES-1)

InitTdArrayNextRow:
	mov	ch, 0			;CH will be column counter (0..TDS_PER_FRAME-1)

InitTdArrayNextCol:
	mov	al, ACTIVE_FRAMES	;AL = number of rows
	mul	ch			;AL = index of TD in row 0 of cur column
	add	al, cl			;AL = index of TD in cur row of cur column
	mov	bl, size Transfer_Descriptor
	mul	bl			;AX = offset within TD pool of current TD
	add	ax, offset TdHid	;AX = offset within usbdseg of current TD
	mov	di, ax			;DI = offset within usbdseg of current TD

	mov	eax, HcdDataArea ;EDX = seg containing TDs
	add	eax, offset TdRepeat	;EAX = abs addr of TdRepeat
	or	cl, cl
	jz	@f			;Br if on row 0
	mov	eax, edx		;EAX = ptr to QhControl
@@:
	cmp	ch, TDS_PER_FRAME - 1
	jae	InitTdLastCol		;Br if cur TD is last col in its row

	movzx	eax, di			;EAX = offset within usbdseg of current TD
	add	eax, HcdDataArea
	add	eax, (size Transfer_Descriptor * ACTIVE_FRAMES)
					;EAX = abs addr of next TD in row
InitTdLastCol:
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax

	inc	ch
	cmp	ch, TDS_PER_FRAME
	jb	InitTdArrayNextCol	;Br if more cols to do

	inc	cl
	cmp	cl, ACTIVE_FRAMES
	jb	InitTdArrayNextRow	;Br if more rows to do

; Initialize the body of each HID TD and Hub TD to perform an
; interrupt transaction to an individual device address.  All TDs
; in the both arrays will initially be disabled.  As devices are found that
; need to be polled, the TD corresponding to the device's address will be
; made active.

	mov	cl, 0			;CL will count TDs (0..MAX_DEVICES-1)
	mov	di, offset TdPool	;DI = offset of first TD in array

InitPoolNextTd:
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, THREE_ERRORS

	movzx	eax, cl			;EAX = TD number
	inc	al			;EAX = TD's device address
	shl	ax, 8			;Put device address in bits 14:8
	or	eax, IN_PACKET or ((DEFAULT_PACKET_LENGTH - 1) shl 21) ;Set PID=In, and MaxLen
	mov	(Transfer_Descriptor ptr [di]).TD_Token, eax

	lea	ax, (Transfer_Descriptor ptr [di]).DataArea ;AX = ptr to TD's data buffer
	movzx	eax, ax			;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(Transfer_Descriptor ptr [di]).TD_Buffer_Pointer, eax

	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, THREE_ERRORS
	mov	(Transfer_Descriptor ptr [di]).pCallback, offset cgroup:PollingTdCallback
	add	(Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	add	di, size Transfer_Descriptor
	inc	cl			;Inc TD counter
	cmp	cl, MAX_DEVICES
	jb	InitPoolNextTd		;Br if more TDs to init

; Initialize the body TdRootHub.  It will run a interrupt transaction to a
; nonexistant dummy device.  This will have the effect of generating a periodic
; interrupt for the purpose of checking for attach/detach on the root
; hub's ports.

	mov	di, offset TdRootHub	;DI = ptr of TdRootHub

	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, INTERRUPT_ON_COMPLETE or ONE_ERROR or ACTIVE
	mov	(Transfer_Descriptor ptr [di]).TD_Token, IN_PACKET or (DUMMY_DEVICE_ADDR shl 8) or ((DEFAULT_PACKET_LENGTH - 1) shl 21) ;Set PID=In, Dev=Dummy, and MaxLen

	lea	ax, (Transfer_Descriptor ptr [di]).DataArea ;AX = ptr to TD's data buffer
	movzx	eax, ax			;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(Transfer_Descriptor ptr [di]).TD_Buffer_Pointer, eax
	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, INTERRUPT_ON_COMPLETE or ONE_ERROR or ACTIVE
	mov	(Transfer_Descriptor ptr [di]).pCallback, offset cgroup:RootHubTdCallback
	add	(Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

; Initialize the body of TdRepeat  It will run a interrupt transaction to a
; nonexistant dummy device.  This will have the effect of generating a periodic
; interrupt used to generate keyboard repeat.  This TD is normally inactive, and
; is only activated when a key is pressed.  TdRepeat will be set to timeout after
; two attempts.  Since the TD is in the schedule at 16ms intervals, this will
; generate an interrupt at intervals of 32ms (when the TD is active).  This 32ms
; periodic interrupt may then approximate the fastest keyboard repeat rate of
; 30 characters per second.

	mov	di, offset TdRepeat	;DI = ptr of TdRepeat

	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, TWO_ERRORS
	mov	(Transfer_Descriptor ptr [di]).TD_Token, IN_PACKET or (DUMMY_DEVICE_ADDR shl 8) or ((DEFAULT_PACKET_LENGTH - 1) shl 21) ;Set PID=In, Dev=Dummy, and MaxLen

	lea	ax, (Transfer_Descriptor ptr [di]).DataArea ;AX = ptr to TD's data buffer
	movzx	eax, ax			;Clear upper half of EAX
	add	eax, HcdDataArea	;EAX = abs addr of TD's data buffer
	mov	(Transfer_Descriptor ptr [di]).TD_Buffer_Pointer, eax
	mov	(Transfer_Descriptor ptr [di]).CSReloadValue, TWO_ERRORS
	mov	(Transfer_Descriptor ptr [di]).pCallback, offset cgroup:RepeatTdCallback
	add	(Transfer_Descriptor ptr [di]).pCallback, orgbase
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

; Set TdRepeat's Link Pointer to Control Queue Head

	mov	eax, HcdDataArea
	add	eax, offset QhControl
	or 	eax, QUEUE_HEAD 	;EDX = seg containing TDs
	mov	(Transfer_Descriptor ptr [di]).TD_Link_Pointer, eax

; Initialize QhControl.  The queue normally has no TDs in it.  TDs are placed
; into the queue only when initializing a device (see UsbDeviceRequest
; function above).

	mov	di, offset QhControl
	mov	(Q_Head ptr [di]).Q_Head_Link_Pointer, TERMINATE
	mov	(Q_Head ptr [di]).Q_Element_Link_Pointer, TERMINATE

; Hook the interrupt that has been assigned to the host controller.

ifdef DOS_DEBUG
	mov	bx, UsbHcBusDevFuncNum
	mov	di, USB_IRQ_LEVEL
	mov	si, PCI_REG_ADDRESS_BYTE
	call	smi_pci_read_cfg	;Returns CL = IRQ level assigned to HC
	mov	HC_Interrupt_Level, cl

	add	cl, 8			;IRQ 0/1/../7 -> INT 8/9/../F
	cmp	cl, 10h
	jb	InitVector		;Br if IRQ 0..7
	add	cl, 70h - 10h 		;Add offset of second 8259's vectors
InitVector:
	movzx	bx, cl			;BX = HC's interrupt vector
	shl	bx, 2			;BX = addr of interrupt vector to hook

	mov	ax, cs			;AX = CS
	shl	eax, 16			;Put CS in upper half of EAX
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

	in	al, 21h			;AL = First 8259's mask reg
	and	al, bl			;Adjust mask
	out	21h, al			;Write mask back

	in	al, 0A1h		;AL = Second 8259's mask reg
	and	al, bh			;Adjust mask
	out	0A1h, al		;Write mask back
endif

; Enable interrupts from the host controller

	mov	ax, IOC_ENABLE OR TIMEOUT_CRC_ENABLE
	mov	dx, USB_INTERRUPT_ENABLE
	call	WriteUsbIoRegWord	;Enable IOC, timeout, CRC interrupts

; Start the host controller and set the configured flag in the host controller
; to signal that it is up and running under BIOS control.

	mov	ax, HOST_CONTROLLER_RUN or CONFIGURE_FLAG
	mov	dx, USB_COMMAND_REG
	call	WriteUsbIoRegWord	;Start the host controller running

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

; Stop the host controller
	mov	dx, USB_COMMAND_REG
	call	ReadUsbIoRegWord	;AX = HC command reg
	and	al, NOT HOST_CONTROLLER_RUN
	call	WriteUsbIoRegWord	;Write back to HC command reg

; Disable interrupts from the host controller
	xor	ax, ax
	mov	dx, USB_INTERRUPT_ENABLE
	call	WriteUsbIoRegWord	;Disable all HC interrupts

; Disable the HC's SMI generation on port 60/64 read/write and USB interrupt.
;;	mov	bx, UsbHcBusDevFuncNum
	call	GetUsbHcBusDevFunc	;Returns BX = b/d/f, destroys AX,ECX,EDX
	jc	@f			;Br if USB HC not found
	call	UsbHcChipsetShutdown
@@:
; Turn off ports
	mov	ax,01ffh
	call	UsbDisableRootHubPort
	mov	ax,02ffh
	call	UsbDisableRootHubPort

; Unconfigure everything
	mov	dx, USB_COMMAND_REG
	mov	ax,0
	call	WriteUsbIoRegWord	;Write to HC command reg

; Mask the host controller's IRQ level in the 8259

ifdef DOS_DEBUG
	mov	cl, HC_Interrupt_Level	;CL = IRQ used by the HC (0..15)
	mov	bx, 1
	shl	bx, cl			;BX = bit map with one bit set

	in	al, 21h			;AL = First 8259's mask reg
	or	al, bl			;Adjust mask
	out	21h, al			;Write mask back

	in	al, 0A1h		;AL = Second 8259's mask reg
	or	al, bh			;Adjust mask
	out	0A1h, al		;Write mask back
endif

; Unhook the interrupt that has been assigned to the host controller.

ifdef DOS_DEBUG
	;..........................
endif

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
; Input:  DS = ES 	Usb Data Area                                          ;
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

; Clear interrupt status in the host controller

 	mov	dx, USB_STATUS_REG
	call	ReadUsbIoRegWord	;AX = HC status reg
 	call	WriteUsbIoRegWord	;Write back to HC status reg to clear

; Loop through all of the TDs.  For any TD whose ActiveFlag is TRUE and
; is completed (TD_Control_Status bit 23 clear), process the TD by calling
; its callback routine.

	mov	di, offset TdPool	;DI = offset of first TD in array

ServiceTdNextTd:
	call	ProcessTdIfNeeded	;Check if complete and do callback
	add	di, size Transfer_Descriptor
	cmp	di, offset TdPoolEnd
	jb	ServiceTdNextTd		;Br if more TDs to service

; Clear interrupt status in the host controller again..................

 	mov	dx, USB_STATUS_REG
	call	ReadUsbIoRegWord	;AX = HC status reg
 	call	WriteUsbIoRegWord	;Write back to HC status reg to clear

; Issue EOI to the 8259

ifdef DOS_DEBUG

	mov	al, 20h			;AL = EOI command
	cmp	HC_Interrupt_Level, 8
	jb	IsrEoiPri		;Br if using IRQ 0..7 (2nd 8259 needs no EOI)
	out	0A0h, al
	jcxz	$+2
	jcxz	$+2
IsrEoiPri:
	out	20h, al
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

	cmp	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE
	jne	@f			;Br if TD is not active
	test	(Transfer_Descriptor ptr [di]).TD_Control_Status, ACTIVE
	jnz	@f			;Br if TD is not completed
	cmp	(Transfer_Descriptor ptr [di]).pCallback, 0
	jz	@f			;Br if TD's callback ptr is NULL
	call	(Transfer_Descriptor ptr [di]).pCallback
@@:
	ret
ProcessTdIfNeeded	endp


;---------------------------------------;
; PollingTdCallback                     ;
;---------------------------------------;--------------------------------------;
; This function is called when a polling TD from the TD pool completes an      ;
; interrupt transaction to its assigned device.  This routine should process   ;
; any data in the TD's data buffer, handle any errors, and then copy the       ;
; TD's CSReloadValue field into its TD_Control_Status field to put the TD back ;
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
	push	bx
	push	si

	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	test	(Transfer_Descriptor ptr [di]).TD_Control_Status, STATUS_FIELD
	jnz	PollingTdError		;Br if any error bit is set in status

 	mov	dx, USB_FRAME_NUM
	call	ReadUsbIoRegWord	;AX[10:0] = Frame number
	mov	cx, ax			;BX[10:0] = Frame number
	mov	ax, word ptr ((Transfer_Descriptor ptr [di]).TD_Token)
	and	ah, (DEVICE_ADDRESS shr 8) ;AH = Device address (1..7F)
	lea	si, (Transfer_Descriptor ptr [di]).DataArea

	push	ax
	mov	al, size DeviceTableEntry
	mul	ah			;AX = offset of DeviceTableEntry in DeviceTable
	mov	bx, ax
	add	bx, offset DeviceTable	;BX = ptr to DeviceTableEntry
	pop	ax

	call	(DeviceTableEntry ptr [bx]).pDeviceCallback

PollingTdError:
	mov	eax, (Transfer_Descriptor ptr [di]).CSReloadValue
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax

	xor	(Transfer_Descriptor ptr [di]).TD_Token, DATA_TOGGLE

	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

	pop	si
	pop	bx
	pop	eax
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
	push	ebx

; Check to see if the TD that just completed has any error bits set.  If
; any of the ControlTds (Setup, Data, or Status) complete with an error, set
; ActiveFlag of the TdControlStatus and copy the error information from the
; TD that just completed into the TdControlStatus.

	mov	eax, (Transfer_Descriptor ptr [di]).TD_Control_Status
	test	eax, STATUS_FIELD
	jz	ControlNoError		;Br if the TD completed with no error

	mov	TdControlStatus.TD_Control_Status, eax
	mov	TdControlStatus.ActiveFlag, FALSE
	jmp	short ControlDone

; Check the amount of data tranferred by the TD that just completed.  If
; less than a full packet was transferred, then the device has no more
; data to send.  In this case we should point the QhControl's
; Q_Element_Link_Pointer field to the TdControlStatus because that the
; remaining TdControlData TDs are not needed.

ControlNoError:
	mov	eax, (Transfer_Descriptor ptr [di]).TD_Control_Status
	and	ax, ACTUAL_LENGTH	;AX = actual byte count - 1
	mov	ebx, (Transfer_Descriptor ptr [di]).TD_Token
	shr	ebx, 21			;BX = expected byte count - 1
	cmp	ax, bx
	je	ControlDone		;Br if actual = expected count

	mov	bx, offset QhControl
	mov	eax, HcdDataArea	;EAX = seg containing TDs
	add	eax, offset TdControlStatus ;EAX = abs addr of TdControlStatus
	mov	(Q_Head ptr [bx]).Q_Element_Link_Pointer, eax

; Make the TD that just completed inactive.  It may be the TdControlSetup,
; one of the TdControlData TDs, or the TdControlStatus.

ControlDone:
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	pop	ebx
	pop	eax
	ret
ControlTdCallback	endp


;---------------------------------------;
; RootHubTdCallback                     ;
;---------------------------------------;--------------------------------------;
; This function is called when the TdRootHub completes a transaction.  This    ;
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
RootHubTdCallback	proc near
	push	eax
	push	dx

; First deactivate the TdRootHub so this callback function will not get
; reentered.

	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

; Mask the Host Controller interrupt so the ISR does not get re-entered due
; to an IOC interrupt from any TDs that complete in frames while we are
; configuring a new device that has just been plugged in.

	xor	ax, ax
	mov	dx, USB_INTERRUPT_ENABLE
	call	WriteUsbIoRegWord	;Disable IOC, timeout, CRC interrupts

; Check ports 1 and 2 on the root hub for any change in connect status.  If the
; connect status has been changed on either or both of these ports, then call the
; routine UsbHubPortChange for each changed port.

	mov	dx, USB_PORT1_CONTROL
	call	ReadUsbIoRegWord	;AX = value from port 1 control reg
	test	al, CONNECT_STATUS_CHANGE
	jz	@f			;Br if no change for port 1
	mov	ax, 01FFh		;AH = port number, AL = device addr (FF=root hub)
	call	UsbHubPortChange	;Process the connection/disconnection
	mov	dx, USB_PORT1_CONTROL
	call	ReadUsbIoRegWord	;AX = value from port 1 control reg
	call	WriteUsbIoRegWord	;Write back to clear the change bit
@@:
	mov	dx, USB_PORT2_CONTROL
	call	ReadUsbIoRegWord	;AX = value from port 2 control reg
	test	al, CONNECT_STATUS_CHANGE
	jz	@f			;Br if no change for port 2
	mov	ax, 02FFh		;AH = port number, AL = device addr (FF=root hub)
	call	UsbHubPortChange	;Process the connection/disconnection
	mov	dx, USB_PORT2_CONTROL
	call	ReadUsbIoRegWord	;AX = value from port 2 control reg
	call	WriteUsbIoRegWord	;Write back to clear the change bit
@@:

; Call the USB keyboard code's periodic entry point.  The keyboard code uses
; this periodic call to check the state of the keyboard LED status byte
; (at 40:17) and resync the USB keyboard's LEDs to match that byte if needed.

	call	OneSecondPeriodicHandler

; Renable interrupts from the host controller

	mov	ax, IOC_ENABLE OR TIMEOUT_CRC_ENABLE
	mov	dx, USB_INTERRUPT_ENABLE
	call	WriteUsbIoRegWord	;Enable IOC, timeout, CRC interrupts

; Reactivate the TdRootHub

	mov	eax, (Transfer_Descriptor ptr [di]).CSReloadValue
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax
	xor	(Transfer_Descriptor ptr [di]).TD_Token, DATA_TOGGLE
	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

	pop	dx
	pop	eax
	ret
RootHubTdCallback	endp


;---------------------------------------;
; RepeatTdCallback                      ;
;---------------------------------------;--------------------------------------;
; This function is called when TdRepeat completes a transaction.  This         ;
; TD runs a dummy interrupt transaction to a non-existant device address for   ;
; the purpose of generating a periodic timeout interrupt which in turn is used ;
; to generate keyboard repeat.                                                 ;
;                                                                              ;
; Input:  DS:DI = Pointer to TD that completed                                 ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
RepeatTdCallback	proc near
	push	eax

; First deactivate the TdRepeat so this callback function will not get
; reentered.

	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, FALSE

	call	PeriodicInterruptHandler 
; Reactivate the TdRepeat

	mov	eax, (Transfer_Descriptor ptr [di]).CSReloadValue
	mov	(Transfer_Descriptor ptr [di]).TD_Control_Status, eax
	xor	(Transfer_Descriptor ptr [di]).TD_Token, DATA_TOGGLE
;;;	mov	(Transfer_Descriptor ptr [di]).ActiveFlag, TRUE

	pop	eax
	ret
RepeatTdCallback	endp


;---------------------------------------;
; EnablePeriodicInterrupt		;
;---------------------------------------;--------------------------------------;
; This function enables the periodic interrupt.                                ;
;                                                                     
       ;
;         AL = Value to write to register                                      ;
;         DS = Segment containing IO_Space_Base_Address variable               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
WriteUsbIoRegByte	proc	near
	push	dx
	add	dx, IO_Space_Base_Address
	out	dx, al
	pop	dx
	ret
WriteUsbIoRegByte	endp


;---------------------------------------;
; ReadUsbIoRegWord                      ;
;---------------------------------------;--------------------------------------;
; This function reads a word from the given register in the USB host           ;
; controller.                                                                  ;
;                                                                              ;
; Input:  DX = Register offset to read                                         ;
;         DS = Segment containing IO_Space_Base_Address variable               ;
;                                                                              ;
; Output: AX = Value read from register                                        ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ReadUsbIoRegWord	proc	near
	push	dx
	add	dx, IO_Space_Base_Address
	in	ax, dx
	pop	dx
	ret
ReadUsbIoRegWord	endp


;---------------------------------------;
; WriteUsbIoRegWord                     ;
;---------------------------------------;--------------------------------------;
; This function writes a word to the given register in the USB host            ;
; controller.                                                                  ;
;                                                                              ;
; Input:  DX = Register offset to write                                        ;
;         AX = Value to write to register                                      ;
;         DS = Segment containing IO_Space_Base_Address variable               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
WriteUsbIoRegWord	proc	near
	push	dx
	add	dx, IO_Space_Base_Address
	out	dx, ax
	pop	dx
	ret
WriteUsbIoRegWord	endp


;---------------------------------------;
; ReadUsbIoRegDword                     ;
;---------------------------------------;--------------------------------------;
; This function reads a dword from the given register in the USB host          ;
; controller.                                                                  ;
;                                                                              ;
; Input:  DX = Register offset to read                                         ;
;         DS = Segment containing IO_Space_Base_Address variable               ;
;                                                                              ;
; Output: EAX = Value read from register                                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ReadUsbIoRegDword	proc	near
	push	dx
	add	dx, IO_Space_Base_Address
	in	eax, dx
	pop	dx
	ret
ReadUsbIoRegDword	endp


;---------------------------------------;
; WriteUsbIoRegDword                    ;
;---------------------------------------;--------------------------------------;
; This function writes a dword to the given register in the USB host           ;
; controller.                                                                  ;
;                                                                              ;
; Input:  DX = Register offset to write                                        ;
;         EAX = Value to write to register                                     ;
;         DS = Segment containing IO_Space_Base_Address variable               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
WriteUsbIoRegDword	proc	near
	push	dx
	add	dx, IO_Space_Base_Address
	out	dx, eax
	pop	dx
	ret
WriteUsbIoRegDword	endp

	assume	ds:nothing
	assume	es:nothing
	assume	cs:nothing

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
