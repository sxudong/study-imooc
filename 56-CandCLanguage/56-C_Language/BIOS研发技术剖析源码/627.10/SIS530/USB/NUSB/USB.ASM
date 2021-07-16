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
	include usb.equ

	if MKF_USB_UHCI
	include uhci.equ
	endif

	if MKF_USB_OHCI
	include ohci.equ
	endif

	include usbdata.dat

;---------------------------------------;

	public	UsbApiHandler

	public	_UsbSetAddress
	public	_UsbGetDescriptor
	public	_UsbSetConfiguration

	public	UsbDataInit
	public	UsbHubPortChange

;---------------------------------------;

	extrn	_UsbHcInit		:near
	extrn	_UsbHcClose		:near
	extrn	UsbDeviceRequest	:near
	extrn	UsbEnableRootHubPort	:near
	extrn	UsbDisableRootHubPort	:near
	extrn	UsbGetRootHubPortStatus	:near
	extrn	_UsbActivatePolling	:near
	extrn	_UsbDeactivatePolling	:near
	extrn	UsbHcCheckActive	:near
  
	extrn 	ConnectDevice		:near
	extrn 	DisconnectDevice	:near
	extrn	ProcessKeyboardData	:near
	extrn	ProcessMouseData	:near
	extrn	InitUSBKbDataArea	:near

	extrn	pm_fixed_delay		:near

;---------------------------------------;


cgroup	group	_text
_text 	segment word public 'CODE'

	assume	cs:cgroup
	assume	ds:usbdgroup
	assume	es:usbdgroup
.386


;---------------------------------------;
; USB BIOS Version Number               ;
;---------------------------------------;
	public	usb_version
usb_version	label	byte
	db	'USB-'
;;;;	db	(USB_BIOS_MAJOR_VERSION SHR 04h) + 30h
	db	(USB_BIOS_MAJOR_VERSION AND 0Fh) + 30h
	db	'.'
	db	(USB_BIOS_MINOR_VERSION SHR 04h) + 30h
	db	(USB_BIOS_MINOR_VERSION AND 0Fh) + 30h
	db	' '
	db	00h

;---------------------------------------;
; USB BIOS API Function Table           ;
;---------------------------------------;
UsbApiTableStart:
	dw	UsbBiosCheckPresent	        ;USB BIOS API function 00h
	dw	UsbBiosInitialize		;USB BIOS API function 01h
	dw	_UsbHcClose			;USB BIOS API function 02h
	dw	UsbDeviceRequest		;USB BIOS API function 03h
	dw	UsbGetHubPortStatus		;USB BIOS API function 04h
	dw	UsbEnableHubPort		;USB BIOS API function 05h
	dw	UsbDisableHubPort		;USB BIOS API function 06h
	dw	UsbBiosReadApiDataBuffer	;USB BIOS API function 07h
	dw	UsbBiosWriteApiDataBuffer	;USB BIOS API function 08h
	dw	UsbBiosGetDeviceTableEntry	;USB BIOS API function 09h
	dw	UsbBiosSetDeviceTableEntry	;USB BIOS API function 0Ah
	dw	UsbBiosCheckDeviceTypePresent	;USB BIOS API function 0Bh
UsbApiTableEnd:


;---------------------------------------;
; UsbApiHandler                         ;
;---------------------------------------;--------------------------------------;
; This function handles calls to the USB BIOS API.  Each call is routed to the ;
; appropriate function based on the function number that was in the upper word ;
; of ESI when software SMI was generated.                                      ;
;                                                                              ;
; Input: cs:[cpu_gen_purpose_reg_entry + reg_esi]                              ;
;           Bit[31:16] = USB BIOS API function number                          ;
;           Bit[15:00] = 'SB' or 5342h                                         ;
;        cs:[cpu_gen_purpose_reg_entry + reg_ebx] = Function specific data     ;
;        cs:[cpu_gen_purpose_reg_entry + reg_ecx] = Function specific data     ;
;        cs:[cpu_gen_purpose_reg_entry + reg_edi] = Function specific data     ;
;        DS = ES = usbdseg (For functions 01h - 0Bh only, DS and ES are        ;
;                  undefined for function 00h)                                 ;
;                                                                              ;
; Output: cs:[cpu_gen_purpose_reg_entry + reg_ebx] = Function specific data    ;
;         cs:[cpu_gen_purpose_reg_entry + reg_ecx] = Function specific data    ;
;         cs:[cpu_gen_purpose_reg_entry + reg_edi] = Function specific data    ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbApiHandler	proc near
	pushad

; Make sure function number is valid and then set BP to the offset
; of the function that is being called.

	mov	ebx, dword ptr cs:[cpu_gen_purpose_reg_entry + reg_esi]
	shr	ebx, 16			;BX = function number

	cmp	bx, (UsbApiTableEnd - UsbApiTableStart) / 2
	jb	UsbApiValidFunc		;Br if valid function number
UsbApiZero:
	stc				;Set carry to indicate error
	jmp	UsbApiCallAbort		;Return to caller

; If calling functions 02h - 0Ah, the USB BIOS must be running the USB HC.
; Generate an error if this condition is not met.

UsbApiValidFunc:
	cmp	bl, 2
	jb	UspApiOkToCall		;Br if calling function 00h or 01h

	call	UsbHcCheckActive	;Returns CL=00/01 for inactive/active
	or	cl, cl
	jz	UsbApiZero		;Br if BIOS not running USB HC

UspApiOkToCall:
	shl	bx, 1			;BX = function number * 2
	add	bx, orgbase
	mov	bp, word ptr cs:[bx + UsbApiTableStart]
	or	bp, bp
	jz	UsbApiZero		;Br if table entry is zero

; Setup input registers from caller's inputs:
;    AX = upper word of EBX
;    BX = BX
;    CX = CX
;    DX = upper word of ECX
;    SI = DI
;    DI = offset ApiDataBuffer

	mov	ebx, dword ptr cs:[cpu_gen_purpose_reg_entry + reg_ebx]
	mov	ecx, dword ptr cs:[cpu_gen_purpose_reg_entry + reg_ecx]
	mov	esi, dword ptr cs:[cpu_gen_purpose_reg_entry + reg_edi]
	mov	eax, ebx		;Get AX from upper half of EBX
	shr	eax, 16
	mov	edx, ecx		;Get DX from upper half of ECX
	shr	edx, 16
	mov	di, offset ApiDataBuffer

	and	byte ptr cs:[cpu_gen_purpose_reg_entry + reg_eflags], 0FEh ;CLC
	add	bp, orgbase
	call	bp			;Call the requested function
UsbApiCallAbort:
	jnc	@f			;Br if CF is clear
	or	byte ptr cs:[cpu_gen_purpose_reg_entry + reg_eflags], 01h ;STC
@@:

; Save any outputs back into registers for return to caller (reverse of
; translation done above).

	mov	dword ptr cs:[cpu_gen_purpose_reg_entry + reg_ebx], ebx
	mov	dword ptr cs:[cpu_gen_purpose_reg_entry + reg_ecx], ecx
	mov	dword ptr cs:[cpu_gen_purpose_reg_entry + reg_edi], esi

	popad
	ret
UsbApiHandler	endp


;---------------------------------------;
; UsbBiosCheckPresent                   ;
;---------------------------------------;--------------------------------------;
; This function is part of the USB BIOS API.  It reports that the USB BIOS     ;
; is present as well as version and status information.                        ;
;                                                                              ;
; Input: Nothing (even DS and ES are undefined)                                ;
;                                                                              ;
; Output: BX = Revision level of USB BIOS (0210h means v2.10)                  ;
;         CH = Number of entries in the DeviceTable array                      ;
;         CL = Flags                                                           ;
;                Bit[7:4] = Reserved                                           ;
;                Bit[3:1] = Number of ports on root hub of host controller     ;
;                Bit[0]   = 1 if USB BIOS is running host controller           ;
;                           0 if USB BIOS is not running host controller       ;
;         ESI = Current USB data area                                          ;
;         CF = Clear (USB BIOS is present)                                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosCheckPresent	proc near
	call	UsbHcCheckActive	;Returns CL = flags
	mov	bx, (USB_BIOS_MAJOR_VERSION * 100h) + USB_BIOS_MINOR_VERSION
	mov	ch, MAX_DEVICES + 1

	xor	esi, esi		;Clear upper half of ESI
	test	cl, 1
	jz	@f			;Br if USB BIOS is not active
	mov	si, ds			;DS valid if HC has been inited
	shl	esi, 4			;Convert seg to abs addr
@@:
	clc
	ret
UsbBiosCheckPresent	endp


;---------------------------------------;
; UsbBiosInitialize                     ;
;---------------------------------------;--------------------------------------;
; This function initializes the USB host controller and optionally causes      ;
; the USB to be enumerated.                                                    ;
;                                                                              ;
; Input: DS  = ES = usbdseg                                                    ;
;        EBX = 32-bit absolute address of USB BIOS data area (usbdseg)         ;
;        CL  = USB BIOS initialization flags                                   ;
;              Bit 2-0: 000 = Auto enum                                        ;
;                       001 = KB on port 1                                     ;
;                       ...   ...                                              ;
;                       111 = KB on port 7                                     ;
;              Bit 3: If set, do not enum the USB                              ;
;              Bit 4: If set, do not beep on new devices                       ;
;              Bit 7-5: Reserved                                               ;
;                                                                              ;
; Output: CF = Clear if initialization was successful, set otherwise           ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosInitialize	proc near
; Clear the 8k data area to be used by USB.

	pusha
	xor	di, di			;Start at offset 0
	mov	cx, 1000h		;Clear 4k words
	xor	ax, ax
	rep	stosw			;Clear 8k data area
	popa

	mov	InitializationFlags, cl	;Save initialization flags

	call	_UsbHcInit		;Init the host controller

	ret
UsbBiosInitialize	endp


;---------------------------------------;
; UsbBiosReadApiDataBuffer              ;
;---------------------------------------;--------------------------------------;
; This function allows USB BIOS API callers to read 8 bytes of data from the   ;
; ApiDataBuffer starting at a given offset.                                    ;
;                                                                              ;
; Input: SI = Offset within buffer to read                                     ;
;        DS:DI = Segment:Offset ApiDataBuffer                                  ;
;                                                                              ;
; Output: EBX = Data bytes 0 - 3 read from ApiDataBuffer                       ;
;         ECX = Data bytes 4 - 7 read from ApiDataBuffer                       ;
;         CF = Clear (USB BIOS is present)                                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosReadApiDataBuffer	proc near
	push	si

	xor	ebx, ebx		;Setup default return values
	xor	ecx, ecx

	cmp	si, MAX_CONTROL_DATA_SIZE
	jae	ReadBufferDone		;Br if caller's offset is too big

	add	si, di			;SI = ptr into ApiDataBuffer
	mov	ebx, dword ptr [si]
	mov	ecx, dword ptr [si+4]

ReadBufferDone:
	clc
	pop	si
	ret
UsbBiosReadApiDataBuffer	endp


;---------------------------------------;
; UsbBiosWriteApiDataBuffer             ;
;---------------------------------------;--------------------------------------;
; This function allows USB BIOS API callers to write 8 bytes of data to the    ;
; ApiDataBuffer starting at a given offset.                                    ;
;                                                                              ;
; Input: SI = Offset within buffer to write                                    ;
;        DS:DI = Segment:Offset ApiDataBuffer                                  ;
;        EBX = Data bytes 0 - 3 to write to ApiDataBuffer                      ;
;        ECX = Data bytes 4 - 7 to write to ApiDataBuffer                      ;
;                                                                              ;
; Output: CF = Clear (USB BIOS is present)                                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosWriteApiDataBuffer	proc near
	push	si

	cmp	si, MAX_CONTROL_DATA_SIZE
	jae	WriteBufferDone		;Br if caller's offset is too big

	add	si, di			;SI = ptr into ApiDataBuffer
	mov	dword ptr [si], ebx
	mov	dword ptr [si+4], ecx

WriteBufferDone:
	clc
	pop	si
	ret
UsbBiosWriteApiDataBuffer	endp


;---------------------------------------;
; UsbBiosGetDeviceTableEntry            ;
;---------------------------------------;--------------------------------------;
; This function is used by USB BIOS API callers to transfer one DeviceTable    ;
; entry into the ApiDataBuffer so that it can be read using the function       ;
; UsbBiosReadApiDataBuffer.                                                    ;
;                                                                              ;
; Input: BL = Index into array of DeviceTable entries                          ;
;        DS:DI = Segment:Offset ApiDataBuffer                                  ;
;                                                                              ;
; Output: CF = Clear if DeviceTable entry successfully copied, set otherwise   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosGetDeviceTableEntry	proc near
	pusha

	cmp	bl, MAX_DEVICES		;There are MAX_DEVICES+1 entries
	cmc
	jb	GetEntryDone		;Br if index is too big

	mov	al, size DeviceTableEntry
	mul	bl			;AX = Offset into DeviceTable
	mov	si, ax			;SI = Offset into DeviceTable
	add	si, offset DeviceTable	;SI = Offset of DeviceTable entry
	mov	cx, size DeviceTableEntry
	rep	movsb			;Copy the DeviceTable entry

	clc				;Indicate success

GetEntryDone:
	popa
	ret
UsbBiosGetDeviceTableEntry	endp


;---------------------------------------;
; UsbBiosSetDeviceTableEntry            ;
;---------------------------------------;--------------------------------------;
; This function is used by USB BIOS API callers to set the contents of one     ;
; DeviceTable entry from the ApiDataBuffer.                                    ;
;                                                                              ;
; Input: BL = Index into array of DeviceTable entries                          ;
;        DS:DI = Segment:Offset ApiDataBuffer                                  ;
;                                                                              ;
; Output: CF = Clear if DeviceTable entry successfully copied, set otherwise   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosSetDeviceTableEntry	proc near
	pusha

	cmp	bl, MAX_DEVICES		;There are MAX_DEVICES+1 entries
	cmc
	jb	SetEntryDone		;Br if index is too big

	mov	al, size DeviceTableEntry
	mul	bl			;AX = Offset into DeviceTable
	mov	si, ax			;SI = Offset into DeviceTable
	add	si, offset DeviceTable	;SI = Offset of DeviceTable entry
	mov	cx, size DeviceTableEntry
	xchg	si, di
	rep	movsb			;Copy the DeviceTable entry

	clc				;Indicate success

SetEntryDone:
	popa
	ret
UsbBiosSetDeviceTableEntry	endp


;---------------------------------------;
; UsbBiosCheckDeviceTypePresent         ;
;---------------------------------------;--------------------------------------;
; This function is used by USB BIOS API callers to check for the presence of   ;
; a given type of USB device.                                                  ;
;                                                                              ;
; Input: BL = Type of device to check for:                                     ;
;               00h = Reserved                                                 ;
;               01h = Keyboard                                                 ;
;               02h = Mouse                                                    ;
;               03h = Hub                                                      ;
;               04h = Floppy                                                   ;
;               05h-FFh = Reserved                                             ;
;        DS = ES = usbdseg                                                     ;
;                                                                              ;
; Output: CF = Clear if a USB device of the given type is present, set         ;
;              otherwise                                                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbBiosCheckDeviceTypePresent	proc near
	pusha

	mov	cx, MAX_DEVICES		;There are MAX_DEVICES+1 entries
	mov	si, offset DeviceTable	;SI = Offset of DeviceTable entry

CheckPresentNextDevice:
	add	si, size DeviceTableEntry ;Skip entry 0 / point to next entry
	cmp	(DeviceTableEntry ptr [si]).Present, TRUE
	jne	CheckPresentSkipDevice
	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, bl
	clc				;Indicate device present
	je	CheckPresentDone	;Br if given device type found

CheckPresentSkipDevice:
	loop	CheckPresentNextDevice
	stc				;Indicate device present

CheckPresentDone:
	popa
	ret
UsbBiosCheckDeviceTypePresent	endp


;---------------------------------------;
; UsbDataInit                           ;
;---------------------------------------;--------------------------------------;
; This function initializes the data structures in the usbdseg.                ;
;                                                                              ;
; Input: DS = ES = usbdseg                                                     ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbDataInit	proc near
	pushad

	xor	eax,eax
	push	ds
	pop	ax
	shl	eax,4
	mov	HcdDataArea, eax

; Setup entry 0 in the DeviceTable as used.

	mov	si, offset DeviceTable	;SI = ptr to entry for device address 0
	mov	(DeviceTableEntry ptr [si]).Present, TRUE

; Initialize remaining entries in device table to unused.

	add	si, size DeviceTableEntry ;SI = ptr to entry for device address 1
@@:
	mov	(DeviceTableEntry ptr [si]).Present, FALSE
	add	si, size DeviceTableEntry ;SI = ptr to next entry
	cmp	si, offset DeviceTableEnd
	jb	@b
	
; Initialize the USB keyboard scanner buffer

ifndef DOS_DEBUG
	call	InitUSBKbDataArea
endif

	popad
	ret
UsbDataInit	endp


;---------------------------------------;
; _UsbSetAddress                        ;
;---------------------------------------;--------------------------------------;
; This function sets the USB device address of device 0 to the given value.    ;
; After this call the USB device will respond at its new address.              ;
;                                                                              ;
; Input: AL = New USB device address to be assigned to device 0                ;
;                                                                              ;
; Output: CF = Clear if the set address command completed successfully         ;
;              Set if the set address command failed                           ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbSetAddress	proc near
	pusha
	push	es

	movzx	cx, al			;CX = wValue parameter = New device addr
	xor	ax, ax			;Dest is  device 0, endpoint 0
	mov	bx, USB_RQ_SET_ADDRESS	;Request type is "Set Address"
	xor	dx, dx			;DX = wIndex parameter = 0
	xor	si, si			;DX = wLength parameter = 0
	xor	di, di			;ES:DI = data buf ptr = NULL
	mov	es, di

	call	UsbDeviceRequest	;Execute the device request, returns CF

	pop	es
	popa
	ret
_UsbSetAddress	endp


;---------------------------------------;
; _UsbGetDescriptor                     ;
;---------------------------------------;--------------------------------------;
; This function executes a Get Descriptor command to the given USB device and  ;
; endpoint.                                                                    ;
;                                                                              ;
; Input: AL = USB device address of device to receive the command              ;
;        AH = Endpoint number within the USB device                            ;
;        CH = USB Descriptor type                                              ;
;        CL = Descriptor index                                                 ;
;        SI = Size of descriptor in bytes                                      ;
;                                                                              ;
; Output: ES:DI = Pointer to memory buffer containing the descriptor           ;
;         CF = Clear if the command completed successfully                     ;
;              Set if the command failed                                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbGetDescriptor proc near
	push	bx
	push	dx

	mov	bx, USB_RQ_GET_DESCRIPTOR ;Request type is "Get Descriptor"
	xor	dx, dx			;DX = wIndex parameter = 0
	mov	di, offset DeviceRequestDataBuf ;ES:DI = ptr DeviceRequestDataBuff
	call	UsbDeviceRequest	;Execute the device request, returns CF

	pop	dx
	pop	bx
	ret
_UsbGetDescriptor endp


;---------------------------------------;
; _UsbSetConfiguration                  ;
;---------------------------------------;--------------------------------------;
; This function executes a Set Configuration command to the given USB device   ;
; and endpoint.                                                                ;
;                                                                              ;
; Input: AL = USB device address of device to receive the command              ;
;        AH = Endpoint number within the USB device                            ;
;        CX = Configuration number to send to the USB device                   ;
;                                                                              ;
; Output: CF = Clear if the command completed successfully                     ;
;              Set if the command failed                                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
_UsbSetConfiguration proc near
	pusha
	push	es

	mov	bx, USB_RQ_SET_CONFIGURATION ;Request type is "Set Address"
	xor	dx, dx			;DX = wIndex parameter = 0
	xor	si, si			;SI = wLength parameter = 0
	xor	di, di			;ES:DI = data buf ptr = NULL
	mov	es, di

	call	UsbDeviceRequest	;Execute the device request, returns CF

	pop	es
	popa
	ret
_UsbSetConfiguration endp


;---------------------------------------;
; _UsbHidSetProtocol                    ;
;---------------------------------------;--------------------------------------;
; This function executes a Set Protocol command to the given USB HID device    ;
; and endpoint.                                                                ;
;                                                                              ;
; Input: AL = USB device address of device to receive the command              ;
;        AH = Endpoint number within the USB device                            ;
;        CL = New protocol for device                                          ;
;               00h = HID boot protocol                                        ;
;               01h = HID entity protocol                                      ;
;               02h-FFh = Reserved                                             ;
;        CH = Endpoint number (from EndpointDescriptor.EndpointAddr)           ;
;                                                                              ;
; Output: CF = Clear if the command completed successfully                     ;
;              Set if the command failed                                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
;;;;_UsbHidSetProtocol  proc near
;;;;    pusha
;;;;    push    es
;;;;
;;;;    mov     bx, HID_RQ_SET_PROTOCOL ;Request type is "Set Protocol"
;;;;    movzx   dx, ch                  ;DX = wIndex = Interface number
;;;;    xor     ch, ch                  ;CX = wValue = Protocol code
;;;;    xor     si, si                  ;SI = wLength parameter = 0
;;;;    xor     di, di                  ;ES:DI = data buf ptr = NULL
;;;;    mov     es, di
;;;;
;;;;    call    UsbDeviceRequest        ;Execute the device request, returns CF
;;;;
;;;;    pop     es
;;;;    popa
;;;;    ret
;;;;_UsbHidSetProtocol  endp


;---------------------------------------;
; UsbHubPortChange                      ;
;---------------------------------------;--------------------------------------;
; This function is called when a change in connect status is detected on any   ;
; port of any hub (including the root hub).  Connect status changes are caused ;
; by devices being plugged in or removed from the USB.  This routine calls     ;
; ProcessSingleHubPortChange to handle the change and then checks for new hubs ;
; on the bus that need to be enumerated.                                       ;
;                                                                              ;
; Input: AL = USB Device address of hub whose status has changed               ;
;             00 - 7F = Device address of hub on the USB                       ;
;             80 - FE = Reserved                                               ;
;             FF      = Root hub                                               ;
;        AH = Port number within hub whose status has changed                  ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbHubPortChange	proc near
	pusha

	mov	bh, 01h			;Do not ignore connect status change
	call	ProcessSingleHubPortChange

; Now check iteratively to see if any external hubs have been found.  For any
; new external hub that has been found, check each of its ports for a new device
; attached.  Since any hub port may have another external hub attached, we
; must iteratively check for new hubs until no new hub is found.  An external
; hub that has been found, but has not had its ports scanned is indicated by
; its HubEnumFlag field in its DeviceTableEntry containing a value of FALSE.

HubChangeEnumNextHub:
	mov	si, offset DeviceTable	;SI = ptr to DeviceTable[0]
	add	si, size DeviceTableEntry ;SI = ptr to DeviceTable[1]
	xor	bl, bl			;BL = Flag: 0 if all hubs have enumerated

HubChangeNextDTE:
	cmp	(DeviceTableEntry ptr [si]).Present, TRUE
	jne	HubChangeSkipDTE	;Br if this DeviceTableEntry is not in use
	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_HUB
	jne	HubChangeSkipDTE	;Br if this DeviceTableEntry is not a hub
	cmp	(DeviceTableEntry ptr [si]).HubEnumFlag, TRUE
	je	HubChangeSkipDTE	;Br if this hub has already been enumerated

	mov	bl, 1			;Indicate that not all hubs have been enumerated
	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = Device address of hub
	mov	ah, 1			;AH will count ports on hub (1..n)
HubChangeNextPort:
	mov	bh, 00h			;Ignore connect status change bit
	call	ProcessSingleHubPortChange ;Handle change on hub/port AL/AH
	inc	ah
	cmp	ah, (DeviceTableEntry ptr [si]).HubNumPorts
	jbe	HubChangeNextPort	;Br if more ports on hub to check

	mov	(DeviceTableEntry ptr [si]).HubEnumFlag, TRUE ;Flag hub's ports as enumerated

HubChangeSkipDTE:
	add	si, size DeviceTableEntry
	cmp	si, offset DeviceTableEnd
	jb	HubChangeNextDTE	;Br if more entries to check

	or	bl, bl
	jnz	HubChangeEnumNextHub	;Br if all hubs are not yet enumerated

	popa
	ret
UsbHubPortChange	endp


;---------------------------------------;
; ProcessSingleHubPortChange            ;
;---------------------------------------;--------------------------------------;
; This function is called when a change in connect status is detected on any   ;
; port of any hub (including the root hub).  Connect status changes are caused ;
; by devices being plugged in or removed from the USB.  This routine handles   ;
; the addtion or subtraction of new devices.                                   ;
;                                                                              ;
; Input: AL = USB Device address of hub whose status has changed               ;
;             00 - 7F = Device address of hub on the USB                       ;
;             80 - FE = Reserved                                               ;
;             FF      = Root hub                                               ;
;        AH = Port number within hub whose status has changed                  ;
;        BH = 00: This hub port is being checked for the first time so ignore  ;
;                 the hub's connect status change bit (enumerate the port even ;
;                 if the hub says that the connect status has not changed)     ;
;             01: This hub port has been checked before, do not ignore the     ;
;                 connect status change bit                                    ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ProcessSingleHubPortChange	proc near
	pusha
	push	ds
	push	es

	test	InitializationFlags, INIT_FLAG_ENUM_DISABLE
	jnz	PortChangeDone		;Br if USB enum is disabled

	call	UsbGetHubPortStatus	;Returns BL=Flags, CF
	jc	PortChangeDone		;Br if error or no change in connect status

	or	bh, bh
	jz	@f			;Br if connect change bit should be ignored
	test	bl, 00000100b		;Test connect status change bit
	jz	PortChangeDone		;Br if connect status has not changed
@@:

	test	bl, 00000001b		;Test device connected bit
	jz	PortChangeDisconnect	;Br if device has been disconnected

	call	UsbDetectNewDevice	;Handle attachment of a new device
	jmp	short PortChangeDone

; A device has been disconnected from the USB.  First disable the hub port
; that the device was plugged into.  Then free up the device's entry in the
; DeviceTable.  If there an error occurs while disabling the port, assume
; that the device is still present an leave its DeviceTable entry in place.

PortChangeDisconnect:
	call	UsbDisableHubPort
	jc	PortChangeDone

	call	ShutdownDevice		;Shutdown device and any children

	mov	ah, 8			;Issue disconnect beep (low & short)
	mov	cx, 1000h
	call	SpeakerBeep

PortChangeDone:
	pop	es
	pop	ds
	popa
	ret
ProcessSingleHubPortChange	endp


;---------------------------------------;
; ShutdownDevice                        ;
;---------------------------------------;--------------------------------------;
; This function is called when a device disconnect is detected.  This routine  ;
; stops polling on the device, frees its DeviceTable entry, and notifies the   ;
; keyboard/mouse code that the device is gone.  This routine also recursively  ;
; processes any childs devices if a hub is disconnected.                       ;
;                                                                              ;
; Input: AL = USB Device address of hub that detected the diconnect            ;
;             00 - 7F = Device address of hub on the USB                       ;
;             80 - FE = Reserved                                               ;
;             FF      = Root hub                                               ;
;        AH = Port number within hub that detected the diconnect               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ShutdownDevice proc near
	push	si

	mov	si, offset DeviceTable	;SI = ptr to DeviceTableEntry[0]
	add	si, size DeviceTableEntry ;Point to DeviceTableEntry[1]

DisCheckNextEntry:
	cmp	(DeviceTableEntry ptr [si]).Present, TRUE
	jne	SkipEntry		;Br if unused entry
	cmp	word ptr ((DeviceTableEntry ptr [si]).HubDeviceNumber), ax
	jne	SkipEntry		;Br if this entry not for this hub/port

	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_HUB
	jne	DisconnectChildrenDone	;Br if device is not a hub

; A hub device is being disconnected.  For each of the hub's ports disconnect
; any child device connected.

	push	ax
	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
	mov	ah, 1			;AH will count through hub ports

DisconnectNextPort:
	call	ShutdownDevice		;Disconnect device and any children
	inc	ah
	cmp	ah, (DeviceTableEntry ptr [si]).HubNumPorts
	jbe	DisconnectNextPort	;Br if still more ports to disconnect
	pop	ax

; Now free the device table entry for this device, stop polling for this device,
; and notify the keyboard/mouse code that the device is gone (if the device is
; a keyboard or mouse).

DisconnectChildrenDone:	
	mov	(DeviceTableEntry ptr [si]).Present, FALSE ;Mark entry as unused
	call	_UsbDeactivatePolling	;Stop polling for DeviceTableEntry[SI]

	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_KEYBOARD
	je	@F			;Br if disconnected device is keyboard
	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_MOUSE
	jne	SkipEntry		;Br if disconnected device is not mouse
@@:
	push	ax
	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
	mov	ah, (DeviceTableEntry ptr [si]).BiosDeviceType	
	call	DisconnectDevice	;Notify keyboard/mouse code of disconnect
	pop	ax

SkipEntry:
	add	si, size DeviceTableEntry ;Point to next DeviceTableEntry
	cmp	si, offset DeviceTableEnd
	jb	DisCheckNextEntry		;Br if more entries in DeviceTable

	pop	si
	ret
ShutdownDevice	endp


;---------------------------------------;
; UsbDetectNewDevice                    ;
;---------------------------------------;--------------------------------------;
; This function is called when a new device is plugged into a port on a hub.   ;
; The hub may be a normal USB hub or the root hub.  This function does the     ;
; following:                                                                   ;
;                                                                              ;
; 1. Set the DeviceTable entry for device 0 to be the same speed as the        ;
;    new device                                                                ;
; 2. Find a free entry in the DeviceTable (the position in the DeviceTable     ;
;    array is the same as the new device address for the device)               ;
; 3. Enable the port on the hub                                                ;
; 4. Send a GetDescriptor (Device Descriptor) command to the device using an   ;
;    assumed MaxPacket size of 128 bytes, and make note of the actual MaxPacket;
;    size returned in the descriptor data                                      ;
; 5. Reset th hub port to handle any noncompliant devices                      ;
; 6. Send a SetAddress command to the device to set it to its new address      ;
; 7. Send a GetDescriptor command to the device to get its Device descriptor   ;
; 8. Use GetConfiguration commands to search for a configuration that includes ;
;    an interface type that the BIOS can use (keyboard, mouse, or hub).        ;
; 9. Use the data returned in the Device descriptor to fill in the DeviceTable ;
;    entry                                                                     ;
; 10. Configure the device using SetConfiguration, SetInterface, and           ;
;     SetProtocol commands                                                     ;
; 11. Activate polling for the device by calling UsbActivatePolling            ;
; 12. Done                                                                     ;
;                                                                              ;
; Input:  AL = USB Device address of hub where new device has been plugged in  ;
;              00 - 7F = Device address of hub on the USB                      ;
;              80 - FE = Reserved                                              ;
;              FF      = Root hub                                              ;
;         AH = Port number within hub where new device has been plugged in     ;
;         BL = Port status flags                                               ;
;              Bit 0: Connect status                                           ;
;                      0 = No device is connected to port                      ;
;                      1 = A device is connected to port                       ;
;              Bit 1: Device speed                                             ;
;                      0 = Full speed device attached                          ;
;                      1 = Low speed device attached                           ;
;              Bit 2-7: Reserved                                               ;
;         DS = ES = usbdseg                                                    ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbDetectNewDevice	proc near
	pusha
	push	es

; First set the speed of entry 0 in the DeviceTable to run at the same speed
; as the new device.  This is necessary because we will initially communicate
; with the device at address 0 before assigning it a unique device address.

	mov	si, offset DeviceTable	;SI = ptr to DeviceTableEntry[0]
	mov	(DeviceTableEntry ptr [si]).DeviceAddress, 0
	shr	bl, 1			;Full/Low speed bit in bit 0
	and	bl, 1			;BL = 00/01 for Full/Low speed
	mov	(DeviceTableEntry ptr [si]).LowSpeedFlag, bl
	mov	(DeviceTableEntry ptr [si]).Endp0MaxPacket, 40h
	mov	word ptr ((DeviceTableEntry ptr [si]).HubDeviceNumber), ax
	mov	(DeviceTableEntry ptr [si]).BiosDeviceType, 00h

; Next enable the port on the hub where the device is connected.
; HubDeviceNumber is in AL and HubPortNumber is in AH.
; Full speed / low speed flag is in BL.

	call	UsbEnableHubPort	;Enables/resets the port and delays

; Next send a GetDescriptor command to the device to get its Device Descriptor.
; Assume a MaxPacket size of 64 bytes (the device will use 8, 16, 32, or 64).
; Regardless of the packet size used by te device we can always learn the real
; MaxPacket size that the device is using, because this piece of information
; is at offset 7 in the device descriptor.

	push	si
	mov	al, 0			;AL = default device address
	mov	ah, 0			;Send command to endpoint 0 on device
	mov	ch, DESC_TYPE_DEVICE	;CH = Descriptor type
	mov	cl, 0			;CL = Descriptor index
	mov	si, 8d			;SI = Size of descriptor
	call	_UsbGetDescriptor	;Returns ES:DI = descriptor data
	pop	si
	jc	NewDeviceAbort		;Br if error during command

	movzx	ax, es:(DeviceDescriptor ptr [di]).Endp0MaxPacket
	mov	(DeviceTableEntry ptr [si]).Endp0MaxPacket, ax

; Delay for 5 milliseconds after premature termination of the GetDescriptor
; command above.  This was added to accomodate the Philips Infra-Red keyboard
; (Vid=0471, Pid=0601, Ver=1.00) which stops responding during the status
; phase of the SetAddress command below if SetAddress follows the
; GetDescriptor command by only 2ms.

	mov	cx, (5 * 1000) / 15	;5ms
	call	pm_fixed_delay		;Delay


; Now find a free device address.  This is done by searching through the array
; of DeviceTable entries, trying addresses until an unused one is found.

	mov	dl, 1			;First device address to try

FindAddrNextAddr:
	mov	si, offset DeviceTable	;SI = ptr to DeviceTable[0]

FindAddrNextEntry:
	cmp	(DeviceTableEntry ptr [si]).Present, TRUE
	jne	FindAddrSkipEntry	;Br if found unused entry
	cmp	(DeviceTableEntry ptr [si]).DeviceAddress, dl
	je	FindAddrSkipAddr	;Br if addr DL is already used
	
FindAddrSkipEntry:
	add	si, size DeviceTableEntry
	cmp	si, offset DeviceTableEnd
	jb	FindAddrNextEntry	;Br if not to end of DeviceTable
	jmp	NewDeviceFoundAddr	;Made it all the way through the DeviceTable
					; array wthout finding addr DL
FindAddrSkipAddr:
	inc	dl			;Inc address to try
	cmp	dl, MAX_DEVICE_ADDR
	jbe	FindAddrNextAddr	;Br if still more addresses to try
	jmp	NewDeviceDone		;No free address was found so abort

; A free device address is now in DL.  Now send a SetAddress command to the
; device to set it to its new USB device address (in DL).

NewDeviceFoundAddr:
	mov	al, dl			;AL = new device address
	call	_UsbSetAddress
	mov	si, offset DeviceTable	;SI = ptr to DeviceTable[0]
	jc	NewDeviceAbort		;Br if error setting address

	mov	(DeviceTableEntry ptr [si]).DeviceAddress, dl

; Now send a GetDescriptor command to the device to get its device descriptor.

	push	si
	mov	al, dl			;AL = new device address
	mov	ah, 0			;Send command to endpoint 0 on device
	mov	ch, DESC_TYPE_DEVICE	;CH = Descriptor type
	mov	cl, 0			;CL = Descriptor index
	mov	si, 18d			;SI = Size of descriptor
	call	_UsbGetDescriptor	;Returns ES:DI = descriptor data
	pop	si
	jc	NewDeviceAbort		;Br if error during command

	mov	cx, es:(DeviceDescriptor ptr [di]).VendorId
	mov	(DeviceTableEntry ptr [si]).VendorId, cx
	mov	cx, es:(DeviceDescriptor ptr [di]).DeviceId
	mov	(DeviceTableEntry ptr [si]).DeviceId, cx

; Look at each of the device's ConfigDescriptors and InterfaceDescriptors
; until an InterfaceDescriptor is found with BaseClass, SubClass, and
; Protocol fields indicating boot keyboard, mouse, or hub support.

	mov	cl, es:(DeviceDescriptor ptr [di]).NumConfigs
	mov	(DeviceTableEntry ptr [si]).NumConfigs, cl
	mov	(DeviceTableEntry ptr [si]).ConfigNum, 0

NewDeviceNextConfig:
	push	si
	mov	al, dl			;AL = new device address
	mov	ah, 0			;Send command to endpoint 0 on device
	mov	ch, DESC_TYPE_CONFIG	;CH = Descriptor type
	mov	cl, (DeviceTableEntry ptr [si]).ConfigNum ;CL = Desc index
	mov	si, MAX_CONTROL_DATA_SIZE - 1 ;SI = Max size of descriptor
	call	_UsbGetDescriptor	;Returns ES:DI = descriptor data
	pop	si
	jc	NewDeviceAbort		;Br if error during command

	;ES:DI should now point to a ConfigDescriptor.  Verify this and
	;then get some fields out of it.  Then point to the next descriptor.

	cmp	es:(ConfigDescriptor ptr [di]).DescType, DESC_TYPE_CONFIG
	jne	NewDeviceSkipConfig	;Br if device did not return config desc

	mov	al, es:(ConfigDescriptor ptr [di]).ConfigValue ;AL = Config value
	mov	(DeviceTableEntry ptr [si]).ConfigNum, al
	mov	bp, es:(ConfigDescriptor ptr [di]).TotalLength
	cmp	bp, MAX_CONTROL_DATA_SIZE - 1 ;BP = size of all data returned
	jb	@f			  ;Br if data did not overflow
	mov	bp, MAX_CONTROL_DATA_SIZE - 1 ;Limit size of data to what we can handle
@@:
	movzx	bx, es:(ConfigDescriptor ptr [di]).DescLength

	;ES:DI+BX should now point to an InterfaceDescriptor.  Verify this
	;and then check its BaseClass, SubClass, and Protocol fields for
	;usable devices.

NewDeviceNextInterface:
	cmp	es:(InterfaceDescriptor ptr [di+bx]).DescType, DESC_TYPE_INTERFACE
	jne	NewDeviceSkipInterface	;Br if not on an interface desc

	mov	al, es:(InterfaceDescriptor ptr [di+bx]).InterfaceNum
	mov	(DeviceTableEntry ptr [si]).InterfaceNum, al
	mov	al, es:(InterfaceDescriptor ptr [di+bx]).AltSettingNum
	mov	(DeviceTableEntry ptr [si]).AltSettingNum, al

	call	CheckForAndConfigureKeyboard
	jnc	NewDeviceSkipInterface	;Br if successful
	call	CheckForAndConfigureMouse
	jnc	NewDeviceSkipInterface	;Br if successful
	call	CheckForAndConfigureHub

NewDeviceSkipInterface:
	movzx	ax, es:(ConfigDescriptor ptr [di+bx]).DescLength ;BX = next desc
	or	ax, ax
	jz	NewDeviceSkipConfig	;Br if 0 length desc (should never happen, but...)
	add	bx, ax			;BX = ptr to next desc
	cmp	bx, bp
	jb	NewDeviceNextInterface	;Br if not past end of data

NewDeviceSkipConfig:
	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, 00h
	jne	NewDeviceSuccess	;Br if at least on usable interface was found already
	inc	(DeviceTableEntry ptr [si]).ConfigNum
	mov	al, (DeviceTableEntry ptr [si]).ConfigNum
	cmp	al, (DeviceTableEntry ptr [si]).NumConfigs
	jb	NewDeviceNextConfig	;Br if more configs to look at

; No configuration could be found which supports a device which can be used
; by the BIOS.  Beep politely and disable the hub port.

	mov	ah, 4			;Issue connect beep (high & short)
	mov	cx, 1000h
	call	SpeakerBeep
	jmp	short NewDeviceDisablePort

NewDeviceAbort:
	mov	ah, 64			;Issue error beep (low & long)
	mov	cx, 4000h
	call	SpeakerBeep

NewDeviceDisablePort:
	mov	ax, word ptr ((DeviceTableEntry ptr [si]).HubDeviceNumber)
	call	UsbDisableHubPort	;Disables the hub/port at AL/AH

NewDeviceDone:
	mov	si, offset DeviceTable	;SI = ptr to DeviceTableEntry[0]
	mov	(DeviceTableEntry ptr [si]).DeviceAddress, 0
	pop	es
	popa
	ret

NewDeviceSuccess:
	mov	ah, 4			;Issue connect beep (high & short)
	mov	cx, 1000h
	mov	cx, 400h
	call	SpeakerBeep
	jmp	short NewDeviceDone

UsbDetectNewDevice	endp


;---------------------------------------;
; CheckForAndConfigureKeyboard          ;
;---------------------------------------;--------------------------------------;
; This function checks an interface descriptor of a device to see if it        ;
; describes a HID/Boot/Keyboard device.  If the device is a keyboard, then     ;
; it is configured and initialized.                                            ;
;                                                                              ;
; Input: ES:DI+BX = Pointer to an interface descriptor supported by device     ;
;        ES:DI+BP = Limit of the data returned by device during the last       ;
;                   Get Configuration Descriptor command                       ;
;        DS:SI = Pointer to DeviceTableEntry[0] which contains some info       ;
;                from the device, config, and interface descriptors            ;
;                                                                              ;
; Output: CF = Set if keyboard was not found                                   ;
;              Clear if keyboard was found and initialized                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
CheckForAndConfigureKeyboard	proc near
	pusha

; ES:DI+BX points to an InterfaceDescriptor.  Check its BaseClass, SubClass,
; and Protocol fields for a HID/Boot/Keyboard device.

	cmp	es:(InterfaceDescriptor ptr [di+bx]).BaseClass, BASS_CLASS_HID
	stc
	jne	CheckKbdDone		;Br if this interface is not a HID device
	cmp	es:(InterfaceDescriptor ptr [di+bx]).SubClass, SUB_CLASS_BOOT_DEVICE
	stc
	jne	CheckKbdDone		;Br if this interface is not a boot device
	cmp	es:(InterfaceDescriptor ptr [di+bx]).Protocol, PROTOCOL_KEYBOARD
	stc
	jne	CheckKbdDone		;Br if this interface is not a keyboard

; Set the BiosDeviceType field in DeviceTableEntry[0].  This serves as a flag
; that indicates a usable interface has been found in the current configuration.
; This is needed so we can check for other usable interfaces in the current
; configuration (i.e. composite device), but not try to search in other
; configurations.

	mov     (DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_KEYBOARD
	mov     (DeviceTableEntry ptr [si]).pDeviceCallback, offset cgroup:ProcessKeyboardData
	add     (DeviceTableEntry ptr [si]).pDeviceCallback, orgbase

; Call a common routine to handle the remaining initialization that is done
; for all devices.

	call	ConfigureNewDevice	;Finish init for new device
					; Returns CF set/clear appropriately
CheckKbdDone:
	popa
	ret
CheckForAndConfigureKeyboard	endp


;---------------------------------------;
; CheckForAndConfigureMouse             ;
;---------------------------------------;--------------------------------------;
; This function checks an interface descriptor of a device to see if it        ;
; describes a HID/Boot/Mouse device.  If the device is a mouse, then           ;
; it is configured and initialized.                                            ;
;                                                                              ;
; Input: DL = USB Device address of new device                                 ;
;        ES:DI+BX = Pointer to an interface descriptor supported by device     ;
;        ES:DI+BP = Limit of the data returned by device during the last       ;
;                   Get Configuration Descriptor command                       ;
;        DS:SI = Pointer to DeviceTableEntry for the device                    ;
;                                                                              ;
; Output: CF = Set if mouse was not found                                      ;
;              Clear if mouse was found and initialized                        ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
CheckForAndConfigureMouse	proc near
	pusha

; ES:DI+BX points to an InterfaceDescriptor.  Check its BaseClass, SubClass,
; and Protocol fields for a HID/Boot/Mouse device.

	cmp	es:(InterfaceDescriptor ptr [di+bx]).BaseClass, BASS_CLASS_HID
	stc
	jne	CheckMouseDone		;Br if this interface is not a HID device
	cmp	es:(InterfaceDescriptor ptr [di+bx]).SubClass, SUB_CLASS_BOOT_DEVICE
	stc
	jne	CheckMouseDone		;Br if this interface is not a boot device
	cmp	es:(InterfaceDescriptor ptr [di+bx]).Protocol, PROTOCOL_MOUSE
	stc
	jne	CheckMouseDone		;Br if this interface is not a mouse

; Set the BiosDeviceType field in DeviceTableEntry[0].  This serves as a flag
; that indicates a usable interface has been found in the current configuration.
; This is needed so we can check for other usable interfaces in the current
; configuration (i.e. composite device), but not try to search in other
; configurations.

	mov     (DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_MOUSE
	mov     (DeviceTableEntry ptr [si]).pDeviceCallback, offset cgroup:ProcessMouseData
	add     (DeviceTableEntry ptr [si]).pDeviceCallback, orgbase

; Call a common routine to handle the remaining initialization that is done
; for all devices.

	call	ConfigureNewDevice	;Finish init for new device
					; Returns CF set/clear appropriately
CheckMouseDone:
	popa
	ret
CheckForAndConfigureMouse	endp


;---------------------------------------;
; CheckForAndConfigureHub               ;
;---------------------------------------;--------------------------------------;
; This function checks an interface descriptor of a device to see if it        ;
; describes a USB hub.  If the device is a hub, then it is configured and      ;
; initialized.                                                                 ;
;                                                                              ;
; Input: ES:DI+BX = Pointer to an interface descriptor supported by device     ;
;        ES:DI+BP = Limit of the data returned by device during the last       ;
;                   Get Configuration Descriptor command                       ;
;        DS:SI = Pointer to DeviceTableEntry[0] which contains some info       ;
;                from the device, config, and interface descriptors            ;
;                                                                              ;
; Output: CF = Set if hub was not found                                        ;
;              Clear if hub was found and initialized                          ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
CheckForAndConfigureHub	proc near
	pusha

; ES:DI+BX points to an InterfaceDescriptor.  Check its BaseClass, SubClass,
; and Protocol fields for a hub device.

; Samsung & Acer hub have class info in device desc (and 00s here)..........................
	cmp	es:(InterfaceDescriptor ptr [di+bx]).BaseClass, BASE_CLASS_HUB
	stc
	jne	CheckHubDone		;Br if this interface is not a hub device

; Many hubs don't have subclass
;	cmp	es:(InterfaceDescriptor ptr [di+bx]).SubClass, SUB_CLASS_HUB
;	stc
;	jne	CheckHubDone		;Br if this interface is not a hub device

; Set the BiosDeviceType field in DeviceTableEntry[0].  This serves as a flag
; that indicates a usable interface has been found in the current configuration.
; This is needed so we can check for other usable interfaces in the current
; configuration (i.e. composite device), but not try to search in other
; configurations.

	mov     (DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_HUB
	mov     (DeviceTableEntry ptr [si]).pDeviceCallback, offset cgroup:ProcessHubData
	add     (DeviceTableEntry ptr [si]).pDeviceCallback, orgbase

; Call a common routine to handle the remaining initialization that is done
; for all devices.

	call	ConfigureNewDevice	;Finish init for new device
					; Returns CF set/clear appropriately
CheckHubDone:
	popa
	ret
CheckForAndConfigureHub	endp


;---------------------------------------;
; ConfigureNewDevice                    ;
;---------------------------------------;--------------------------------------;
; This device completes the initialization of USB devices once they have been  ;
; identified.                                                                  ;
;                                                                              ;
; Input: ES:DI+BX = Pointer to an interface descriptor supported by device     ;
;        ES:DI+BP = Limit of the data returned by device during the last       ;
;                   Get Configuration Descriptor command                       ;
;        DS:SI = Pointer to DeviceTableEntry[0] which contains some info       ;
;                from the device, config, and interface descriptors            ;
;                                                                              ;
; Output: CF = Set if device was not initialized successfully                  ;
;              Clear if device was initialized successfully                    ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ConfigureNewDevice	proc near
	pusha
	push	es

; First find a free entry in the DeviceTable.  Select a entry number in the range
; MIN_xxx_DEVICE_INDEX - MAX_xxx_DEVICE_INDEX.  The index into the DeviceTableEntry
; array no longer corresponds to the address assigned to the new device.

	mov	dx, di			;Save DI+BX = ptr to Interface desc

	mov	di, offset DeviceTable	;DI = ptr to DeviceTable[0]
	add	di, MIN_HID_DEVICE_INDEX * size DeviceTableEntry
	mov	cl, MIN_HID_DEVICE_INDEX ;CL will count device addresses
	mov	ch, MAX_HID_DEVICE_INDEX ;CH is is max device address

	cmp	(DeviceTableEntry ptr [si]).BiosDeviceType, BIOS_DEV_TYPE_HUB
	jne	ConfigNewNextEntry	;Br if new device is not a hub

	mov	di, offset DeviceTable	;DI = ptr to DeviceTable[0]
	add	di, MIN_HUB_DEVICE_INDEX * size DeviceTableEntry
	mov	cl, MIN_HUB_DEVICE_INDEX ;CL will count device addresses
	mov	ch, MAX_HUB_DEVICE_INDEX ;CH is is max device address

ConfigNewNextEntry:
	cmp	(DeviceTableEntry ptr [di]).Present, TRUE
	jne	ConfigNewFoundEntry	;Br if found unused entry
	inc	cl			;Inc device address
	add	di, size DeviceTableEntry
	cmp	cl, ch
	jbe	ConfigNewNextEntry	;Br if not to end of DeviceTable
	jmp	ConfigNewSkipInterface	;No free entry was found so abort

; DI now points to a free DeviceTable entry.  Since DeviceTableEntry[0] (at SI)
; already has many fields filled in, the new entry should be initialized with a
; copy of DeviceTableEntry[0].  But, the new DeviceTableEntry should not be
; marked as "present" until the device is successfully initialized.

ConfigNewFoundEntry:
	mov	ax, (DeviceTableEntry ptr [di]).TdPoolPtr ;Save TdPoolPtr
	shl	eax,16
	mov	ax, (DeviceTableEntry ptr [di]).EdPoolPtr ;Save EdPoolPtr
	push	es			;Save ES
	push	ds			;Set ES = DS
	pop	es
	push	di			;Save ptr to new DeviceTableEntry
	mov	cx, size DeviceTableEntry
	rep	movsb
	pop	si			;SI = ptr to new DeviceTableEntry
	pop	es			;Restore ES

	mov	di, dx			;Restore DI+BX = ptr to Interface desc
	mov	(DeviceTableEntry ptr [si]).Present, FALSE
	mov	(DeviceTableEntry ptr [si]).EdPoolPtr, ax ;Restore EdPoolPtr
	shr	eax,16
	mov	(DeviceTableEntry ptr [si]).TdPoolPtr, ax ;Restore TdPoolPtr

; Adjust BX so that ES:DI+BX points to the next descriptor, abort if we're past
; the end of the data.

	movzx	ax, es:(InterfaceDescriptor ptr [di+bx]).DescLength
	add	bx, ax			;BX = ptr to next desc
	cmp	bx, bp
	jae	ConfigNewSkipInterface	;Br if past end of data

; ES:DI+BX should now point to an EndpointDescriptor.  If it does not, search
; down until we either find an EndpointDescriptor or go past the limit in BP.

ConfigNewNextDesc :
	cmp	es:(EndpointDescriptor ptr [di+bx]).DescType, DESC_TYPE_ENDPOINT
	je	ConfigNewFoundEndpoint	;Br if on an endpoint desc
	movzx	ax, es:(EndpointDescriptor ptr [di+bx]).DescLength
	or	ax, ax
	jz	ConfigNewSkipInterface	;Br if 0 length desc (should never happen, but...)
	add	bx, ax			;BX = ptr to next desc
	cmp	bx, bp
	jb	ConfigNewNextDesc	;Br if not past end of data
	jmp	ConfigNewSkipInterface	;Br if endpoint desc was not found

; Save some of the fields from the EndpointDescriptor into the DeviceTable
; entry for this device.

ConfigNewFoundEndpoint:
	mov	al, es:(EndpointDescriptor ptr [di+bx]).EndpointAddr
	and	al, EP_DESC_ADDR_EP_NUM
	mov	(DeviceTableEntry ptr [si]).EndpointNum, al

; Do a SetConfiguration command to the device to set it to its
; HID/Boot configuration.

	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
	mov	ah, 0			;Send command to endpoint 0 on device
	movzx	cx, (DeviceTableEntry ptr [si]).ConfigNum
	call	_UsbSetConfiguration	;Set config of device/endp AL/AH to CX
	jc	ConfigNewSkipInterface	;Br if error during command

; If the new device is a hub, then do some hub specific initialization.

	mov	ah, (DeviceTableEntry ptr [si]).BiosDeviceType
	cmp	ah, BIOS_DEV_TYPE_HUB
	jne	ConfigNewNotHub		;Br if new device is not a hub

	; Do a GetDescriptor call to get the hub's HubDescriptor and save some
	; fields from this descriptor in the DeviceTableEntry.

	push	si			;Save ptr to device table entry

	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
	mov	ah, 0			;Send command to endpoint 0 on device
	mov	bx, USB_RQ_GET_CLASS_DESCRIPTOR ;Request type is "Get Class Descriptor"
	mov	ch, DESC_TYPE_CLASS_HUB	;CH = Descriptor type
	mov	cl, 0
	xor	dx, dx			;DX = wIndex parameter = 0
	mov	si, MAX_CONTROL_DATA_SIZE - 1 ;SI = Max size of descriptor
	mov	di, offset DeviceRequestDataBuf ;ES:DI = ptr DeviceRequestDataBuff
	call	UsbDeviceRequest	;Execute the device request, returns CF

	pop	si			;Restore ptr to device table entry
	jc	ConfigNewSkipInterface	;Br if error during command

	mov	al, es:(HubDescriptor ptr [di]).NumPorts ;AL = # of ports on hub
	mov	(DeviceTableEntry ptr [si]).HubNumPorts, al
	mov	al, es:(HubDescriptor ptr [di]).PowerOnDelay ;AL = Port power on delay
	mov	(DeviceTableEntry ptr [si]).HubPowerOnDelay, al
	mov	(DeviceTableEntry ptr [si]).HubEnumFlag, FALSE ;Hub's ports have not been enumerated

	; Turn on power to all of the hub's ports by setting its port power features.
	; This is needed because hubs cannot detect a device attach until port power
	; is turned on.

	mov	dx, 1			;DL will count hub ports and
					;  DX will be used as wIndex parameter
InitHubNextPort:
	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
	mov	ah, 0			;Send command to endpoint 0 on device
	mov	bx, HUB_RQ_SET_PORT_FEATURE ;BX = Request type
	mov	cx, HUB_FEATURE_PORT_POWER  ;CX = wValue parameter = Feature selector
	push	si			;Save ptr to device table entry
	xor	si, si			;SI = wLength parameter = 0
	call	UsbDeviceRequest	;Execute the device request, returns CF
	pop	si			;Restore ptr to device table entry
	jc	ConfigNewSkipInterface	;Br if error during command

	inc	dx			;Next port number
	cmp	dl, (DeviceTableEntry ptr [si]).HubNumPorts
	jbe	InitHubNextPort		;Br if still more ports to power on

	;;;;; Delay the amount of time specified in the PowerOnDelay field of
	;;;;; the hub descriptor.
	;;;;
	;;;;	push	ax
	;;;;	mov	al, (DeviceTableEntry ptr [di]).HubPowerOnDelay ;In 2ms units
	;;;;	cmp	al, 5
	;;;;	jae	EnablePortDelayNext	;Br if hub's delay is >= 10ms
	;;;;	mov	al, 5			;Force delay to at least 10ms
	;;;;
	;;;;EnablePortDelayNext:
	;;;;	mov	cx, 134d		;2ms / 15us
	;;;;	call	pm_fixed_delay		;Delay 2ms
	;;;;
	;;;;	dec	al			;Dec 2ms delay counter
	;;;;	jnz	EnablePortDelayNext	;Br if not done with hub's delay
	;;;;	pop	ax

ConfigNewNotHub:

; If new device is a keyboard or mouse, notify keyboard/mouse code of new
; device attach.

	mov	al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
	mov	ah, (DeviceTableEntry ptr [si]).BiosDeviceType
	cmp	ah, BIOS_DEV_TYPE_KEYBOARD
	je	@f			;Br if new device is a keyboard
	cmp	ah, BIOS_DEV_TYPE_MOUSE
	jne	ConfigNewStartPolling	;Br if new device is not a mouse
@@:
	movzx	dx, (DeviceTableEntry ptr [si]).InterfaceNum
	call	ConnectDevice

;;;;; If the new device is a keyboard or mouse, then do a SetProtocol command to
;;;;; the device to make sure it is operating in HID Boot protocol.
;;;;; Winbond mouse NACKs forever if it sees a SetProtocol
;;;;
;;;;    mov     al, (DeviceTableEntry ptr [si]).DeviceAddress ;AL = device address
;;;;    mov     ah, 0                   ;Send command to endpoint 0 on device
;;;;    mov     cl, 0                   ;Boot protocol value is 00h
;;;;    mov     ch, (DeviceTableEntry ptr [si]).EndpointNum
;;;;    call    _UsbHidSetProtocol
;;;;    ;jc     ;Do not abort on error

; Start polling the new device's interrupt endpoint.

ConfigNewStartPolling:
	call	_UsbActivatePolling	;Start polling DeviceTableEntry[SI]

; Finally mark the DeviceTableEntry as used.

	mov	(DeviceTableEntry ptr [si]).Present, TRUE
	clc				;Indicate device init successful

ConfigNewDone:
	pop	es
	popa
	ret

ConfigNewSkipInterface:
	stc				;Indicate device init not succesful
	jmp	short ConfigNewDone

ConfigureNewDevice	endp


;---------------------------------------;
; ProcessHubData                        ;
;---------------------------------------;--------------------------------------;
; This function is called with USB hub status change report data.              ;
;                                                                              ;
; Input:  DS:SI = Offset of status change data packet received from USB hub    ;
;                 This data is an array of bits:                               ;
;                   Bit 0: If set, some port has detected a connect/disconnect ;
;                   Bit 1: If set, port 1 has detected a connect/disconnect    ;
;                   Bit 2: If set, port 2 has detected a connect/disconnect    ;
;                   Bit 3: If set, port 3 has detected a connect/disconnect    ;
;                   ...                                                        ;
;                   Bit n: If set, port n has detected a connect/disconnect    ;
;         AH    = USB device address of the hub that supplied the data         ;
;         BX    = Pointer to DeviceTableEntry for the hub                      ;
;         CX    = 11 bit time stamp value in units of 1ms (count wraps to 0    ;
;                 after reaching 7FFh)                                         ;
;         DS = ES = usbdseg                                                    ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ProcessHubData	proc near
	pusha

	mov	al, ah			;AL = Device address of hub
	mov	ah, 1			;AH will count ports on hub (1..n)

HubDataNextPort:
	movzx	dx, ah			;DX = port number on hub to check
	bt	word ptr [si], dx
	jnc	HubDataSkipPort		;Br if no change on port DX

	call	UsbHubPortChange	;Handle change on hub/port AL/AH

HubDataSkipPort:
	inc	ah
	cmp	ah, (DeviceTableEntry ptr [bx]).HubNumPorts
	jbe	HubDataNextPort		;Br if more ports on hub to check

	mov	(DeviceTableEntry ptr [bx]).HubEnumFlag, TRUE ;Flag hub's ports as enumerated

	popa
	ret
ProcessHubData	endp


;---------------------------------------;
; UsbGetHubPortStatus                   ;
;---------------------------------------;--------------------------------------;
; This function returns the status of one port on a USB hub or the root hub.   ;
;                                                                              ;
; Input: AL = USB Device address of hub                                        ;
;             00 - 7F = Device address of hub on the USB                       ;
;             80 - FE = Reserved                                               ;
;             FF      = Root hub                                               ;
;        AH = Port number within hub                                           ;
;        DS = ES = usbdseg                                                     ;
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
;              Set if the hub port's status cannot be determined or there is   ;
;              no change in the port's conect status                           ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbGetHubPortStatus	proc near
	push	ecx
	push	di

	cmp	al, 0FFh
	jne	GetPortStatusStdHub	;Br if not port on root hub

	call	UsbGetRootHubPortStatus	;Returns BL,CF
	jmp	short GetPortStatusDone

GetPortStatusStdHub:
	mov	di, offset DeviceRequestDataBuf ;ES:DI = ptr DeviceRequestDataBuff
	pusha
	mov	bx, HUB_RQ_GET_PORT_STATUS ;Request type is "Get Port Status"
	xor	cx, cx			;CX = wValue parameter = 0
	movzx	dx, ah			;DX = wIndex parameter = Port number
	mov	si, 4			;SI = wLength parameter = 4 bytes
	mov	ah, 0			;Send command to endpoint 0 on device
	call	UsbDeviceRequest	;Execute the device request, returns CF
	popa
	jc	GetPortStatusDone	;Br if error during command

	mov	cx, word ptr [di]	;CX[0]=Connect status, CX[9]=Speed
					;Isolate connect status and full/low speed bits
	and	cx, HUB_PORT_STATUS_DEVICE_PRESENT or HUB_PORT_STATUS_LOW_SPEED
	mov	bl, cl			;BL[0]=Connect status
	or	bl, ch			;BL[1]=Full/low speed status

	mov	cl, byte ptr [di+2]	;CL[0]=Connect status change
	and	cl, HUB_PORT_STATUS_CHANGE_CONNECT
	shl	cl, 2			;CL[2]=Connect Status change
	or	bl, cl			;BL[2]=Connect Status change

; Clear any status change bits that are set (connect change, enable change, suspend change,
; over-current change, reset change).  AL = Hub address, AH = hub port number.

	pusha

	mov	di, word ptr [di+2]	;DI = Status change bits
	and	di, HUB_PORT_STATUS_CHANGE_CONNECT or HUB_PORT_STATUS_CHANGE_ENABLE or HUB_PORT_STATUS_CHANGE_SUSPEND or HUB_PORT_STATUS_CHANGE_OVERCURRENT or HUB_PORT_STATUS_CHANGE_RESET
	shl	edi, 10h		;EDI[31:16] = Status change bits
	mov	bx, HUB_RQ_CLEAR_PORT_FEATURE ;BX = Request type
	mov	ecx, HUB_FEATURE_PORT_CONNECT_CHANGE  ;ECX = wValue parameter = Feature selector
	movzx	dx, ah			;DX = wIndex parameter = Port number
	xor	si, si			;SI = wLength parameter = 0
	mov	ah, 0			;AH = Endpoint number = 0

GetPortStatusClearNext:
	bt	edi, ecx		;CF = EDI bit ECX
	jnc	@f			;Br if port status bit[DI] is not set
	call	UsbDeviceRequest	;Execute the device request, returns CF
@@:
	inc	cx			;Try next feature
	cmp	cl, HUB_FEATURE_PORT_RESET_CHANGE
	jbe	GetPortStatusClearNext	;Br if not past last feature / status bit

	popa
	clc				;Indicate port status command successful

GetPortStatusDone:
	pop	di
	pop	ecx
	ret
UsbGetHubPortStatus	endp


;---------------------------------------;
; UsbEnableHubPort                      ;
;---------------------------------------;--------------------------------------;
; This function powers, resets, and enables one port on a USB hub or the root  ;
; hub.                                                                         ;
;                                                                              ;
; Input: AL = USB Device address of hub                                        ;
;             00 - 7F = Device address of hub on the USB                       ;
;             80 - FE = Reserved                                               ;
;             FF      = Root hub                                               ;
;        AH = Port number within hub                                           ;
;        DS = ES = usbdseg                                                     ;
;                                                                              ;
; Output: CF = Clear if the hub port was enabled successfully                  ;
;              Set if the hub port was not enabled                             ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbEnableHubPort	proc near
	pusha

	cmp	al, 0FFh
	jne	EnablePortStdHub	;Br if not enabling port on root hub

	call	UsbEnableRootHubPort	;Returns CF
	jmp	EnablePortDone

EnablePortStdHub:

; Delay for 100ms allowing power to settle.

;	mov	cx, (100 * 1000) / 15	;100ms / 15us
;	call	pm_fixed_delay		;Delay

; Reset the device attached to the hub by setting the hub/port's reset feature.
; AX still contains the device address and endpoint.

	movzx	dx, ah			;DX = Port number
	mov	ah, 0			;AL = Endpoint 0
	mov	bx, HUB_RQ_SET_PORT_FEATURE ;BX = Request type
	mov	cx, HUB_FEATURE_PORT_RESET  ;CX = wValue parameter = Feature selector
	xor	si, si			;SI = wLength parameter = 0
	call	UsbDeviceRequest	;Execute the device request, returns CF
	jc	EnablePortDone		;Br if error during command

; Wait for the hub to complete its port reset sequence by sending a GetPortStatus
; command to the hub.
; AX still contains the device address and endpoint.
; DX still contains the port number (wIndex parameter).

	mov	bp, 10			;Time out after 10 iterations

EnablePortWaitReset:
	mov	cx, (10 * 1000) / 15	;10ms / 15us
	call	pm_fixed_delay		;Delay

	dec	bp			;Dec timeout counter
	stc				;Set CF in case this jz jumps
	jz	short EnablePortDone	;Br if timeout waiting for reset complete

	mov	di, offset DeviceRequestDataBuf ;ES:DI = ptr DeviceRequestDataBuff
	mov	bx, HUB_RQ_GET_PORT_STATUS ;Request type is "Get Port Status"
	xor	cx, cx			;CX = wValue parameter = 0
	mov	si, 4			;SI = wLength parameter = 4 bytes
	call	UsbDeviceRequest	;Execute the device request, returns CF
	jc	EnablePortDone		;Br if error during command

	test	byte ptr [di], 00010000b ;Bit 4 = 1 if reset is active
	jnz	EnablePortWaitReset	;Br if hub has not completed reset yet

EnablePortResetDone:

; Acknowledge the reset by clearing the port's reset change feature.
; AX still contains the device address and endpoint.
; DX still contains the port number (wIndex parameter).

	mov	bx, HUB_RQ_CLEAR_PORT_FEATURE ;BX = Request type
	mov	cx, HUB_FEATURE_PORT_RESET_CHANGE  ;CX = wValue parameter = Feature selector
	xor	si, si			;SI = wLength parameter = 0
	call	UsbDeviceRequest	;Execute the device request, returns CF
	jc	EnablePortDone		;Br if error during command

; Delay for the required time after reseting a USB device.

	mov	cx, (100 * 1000) / 15	;100ms / 15us (more time than required)
	call	pm_fixed_delay		;Delay

EnablePortDone:
	popa
	ret
UsbEnableHubPort	endp


;---------------------------------------;
; UsbDisableHubPort                     ;
;---------------------------------------;--------------------------------------;
; This function disables one port on a USB hub or the root hub.                ;
;                                                                              ;
; Input: AL = USB Device address of hub                                        ;
;             00 - 7F = Device address of hub on the USB                       ;
;             80 - FE = Reserved                                               ;
;             FF      = Root hub                                               ;
;        AH = Port number within hub                                           ;
;        DS = ES = usbdseg                                                     ;
;                                                                              ;
; Output: CF = Clear if the hub port was disabled successfully                 ;
;              Set if the hub port was not disabled                            ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbDisableHubPort	proc near
	pusha

	stc
	cmp	al, 0FFh
	jne	DisablePortStdHub	;Br if not disabling port on root hub

	call	UsbDisableRootHubPort	;Returns CF
	jmp	short DisablePortDone

DisablePortStdHub:

; Disable the hub/port by clearing its Enable feature
; AX still contains the device address and endpoint.
; DX still contains the port number (wIndex parameter).

	movzx	dx, ah			;DX = Port number
	mov	ah, 0			;AL = Endpoint 0
	mov	bx, HUB_RQ_CLEAR_PORT_FEATURE ;BX = Request type
	mov	cx, HUB_FEATURE_PORT_ENABLE  ;CX = wValue parameter = Feature selector
	xor	si, si			;SI = wLength parameter = 0
	call	UsbDeviceRequest	;Execute the device request, returns CF
	jc	DisablePortDone		;Br if error during command

DisablePortDone:
	popa
	ret
UsbDisableHubPort	endp


;---------------------------------------;
; SpeakerBeep                           ;
;---------------------------------------;--------------------------------------;
; This function beeps the speaker at the given frequency for the given         ;
; duration.                                                                    ;
;                                                                              ;
; Input: AH = Frequency value                                                  ;
;        CX = Duration in units of 15us                                        ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SpeakerBeep	proc near
	push	ax
	push	cx

	test	InitializationFlags, INIT_FLAG_BEEP_DISABLE
	jnz	SkipBeep		;Br if beeps are disabled

	mov	al,10110110b		; initialize timer #2
	out	43h,al
	mov	al,ah			; frequency low byte
	out	42h,al
	out	42h,al			; frequency high byte
	in	al,61h			; on speaker bit
	push	ax
	or	al,00000011b		; speaker gate, speaker bit
	out	61h,al
	call	pm_fixed_delay		;Delay 10ms
	pop	ax			; reset speaker bit
	out	61h,al

SkipBeep:
	pop	cx
	pop	ax
	ret
SpeakerBeep	endp

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
