 	page	,132
	title	OEM POST HOOKS FOR DIM
;-----------------------------------------------------------------------;
; This file is derived from POSTDIM.ASM and NPOSTDIM.ASM files.		;
; ======================== NOTE === NOTE === NOTE =====================	;
; If the routine name in this file starts with "OEM_", then this routine;
; is called from the corresponding generic chipset hook (in POSTDIM.ASM	;
; or NPOSTDIM.ASM file).						;
; ======================== NOTE === NOTE === NOTE =====================	;
; If the routine name in this file does not start with "OEM_", then this;
; routine is called directly from Core file.				;
;-----------------------------------------------------------------------;
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
;****************************************************************************;
;---------------------------------------;
	include	dim.equ
	include devnode.equ
	include rt.equ
	include escd.equ
	include pci.equ
	include pnp.equ
	include	setupequ.ext
	include sis530.equ
	include	makeflag.equ
        include P6access.mac
        include P6.equ
;---------------------------------------;
	extrn dih_scratch_data: byte
	extrn dih_manual_ide_id: byte

	extrn SysStatus: dword
	extrn IsaStatus: dword
	extrn EisaStatus: dword
	extrn PnPStatus: dword
	extrn PciStatus: dword

	extrn OwnerWork: byte

	extrn FindDevID: dword
	extrn FindDevSerial: dword
	extrn FindDevLogID: dword
	extrn FindDevType: dword
	extrn FindDevTypeMask: dword
	extrn FindDevInitAll: byte
	extrn FindDevInitAllBoot: byte

	extrn PnPFoundDevCSN: byte
	extrn PnPFoundDevID: dword
	extrn PnPFoundDevSer: dword
	extrn PnPFoundDevLID: dword

	extrn FindDevIncDev: byte
	extrn FindDevIncBus: byte
	extrn PCICommandValue: word
	extrn PCIFoundDevID: dword
	extrn PCIFoundDevFunc: dword
	extrn PCIFoundDevBus: dword

	extrn EscdFuncNum: byte
	extrn EscdSlotNum: byte

	extrn PCIROMMinBase: dword
	extrn PCIROMMaxBase: dword
	extrn MaxPCIBusNumber:byte

	extrn ResMapStart: word
	extrn ResMapEnd:   word

;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.386
;---------------------------------------;

;==============================================================================;
;                                                                              ;
;                Plug and Play ISA Device Initializer Hooks                    ;
;                                                                              ;
;==============================================================================;

ifdef PNP
;---------------------------------------;
; dih_pnp_func_5 (General Device Init)  ;
;---------------------------------------;--------------------------------------;
; This function is called by the Plug & Play Device Initializer (DI-PNP.ASM)   ;
; during function 5 (General Device Init).                                     ;
;                                                                              ;
; This function should be used to implement the following setup question:      ;
;     Boot to PnP operating system: Yes/No                                     ;
;                                                                              ;
; This question is needed because PnP operating systems (Windows 95) prefer    ;
; that the BIOS initialize only the PnP cards that are needed for booting the  ;
; machine (VGA, SCSI, etc).  The OS will configure all other PnP cards.  If    ;
; the user is booting to a non-PnP OS (NetWare / Unix), then all PnP cards     ;
; must be enabled.  The variable FindDevInitAllBoot controls this feature,     ;
; when set to 00h all PnP cards will be configured.  When FindDevInitAllBoot   ;
; is set to non-zero, then only PnP cards needed for boot will be configured.  ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
	extrn	check_cmos_data_far:near
	public	dih_pnp_func_5
dih_pnp_func_5	proc near

;---------------------------------------;
IF	MKF_BAD_PNP_CARD

; Don't init these two cards if found	;
; For ECP PnP & Other PnP card Bug.	;
;---------------------------------------;
	pushad
	mov	si, offset cgroup:dih_check_pnp_device_func_5_table
	mov	cx, (offset cgroup:dih_check_pnp_device_func_5_table_end - offset cgroup:dih_check_pnp_device_func_5_table)/4
dpf5_0:
	lods	cs: dword ptr [si]	;Get PnP card ID from table
	cmp	eax, PnPFoundDevID	;Match with PnP card ID as found by BIOS ?
	loopnz	dpf5_0
	popad
        jz      dpf5_1			;Incompatible PnP card found, force PnP OS to yes
;<<<------------------------------------;

ENDIF
;---------------------------------------;

	mov	FindDevInitAllBoot, 000h;Init all PnP ISA device by default

	cmp	PnPFoundDevID, 10019305h
	jz	dihirim_01

	mov	al, Q_PNP_AWARE_OS	;"Plug and Play Aware O/S" question
	call	check_cmos_data_far
	jz	dihirim_01		;Br if no PnP aware O/S

dpf5_1:
	mov	FindDevInitAllBoot, 0FFh;Init only boot PnP ISA devices

dihirim_01:
	clc
	ret
dih_pnp_func_5	endp

;---------------------------------------;
; dih_check_pnp_device_func_5_table	;
;---------------------------------------;--------------------------------------;
; This table is used by the Plug & Play Device Initializer (DI-PNP.ASM)        ;
; during function 5 (General Device Init) from DIH_PNP_FUNC_5 hook.            ;
;                                                                              ;
; There are some PnP cards which can NOT be initialized. If these cards        ;
; are found, set PnP aware OS to yes so that BIOS does not initialize these    ;
; cards, OS will initialize these cards.                                       ;
;                                                                              ;
;------------------------------------------------------------------------------;
IF	MKF_BAD_PNP_CARD
	public	dih_check_pnp_device_func_5_table
	public	dih_check_pnp_device_func_5_table_end
dih_check_pnp_device_func_5_table	label	byte
	dd	2409143Eh		; OPTI924 PnP Sound card
        dd      2509143Eh               ; OPTI925 PnP Sound card
	dd	1013B04Eh		; SuperExpress PnP Modem card
        dd      68187316h               ; ESS 1868 Sound card
dih_check_pnp_device_func_5_table_end	label	byte
ENDIF
;------------------------------------------------------------------------------;

endif ;PNP


;==============================================================================;
;                                                                              ;
;                      PCI Device Initializer Hooks                            ;
;                                                                              ;
;==============================================================================;

ifdef PCI
;---------------------------------------;
; dih_pci_prog_frame_buf                ;
;---------------------------------------;--------------------------------------;
; This function should program any chipset register needed for the PCI VGA     ;
; frame buffer.  This function will only be called if a PCI VGA card that      ;
; uses a frame buffer is detected.                                             ;
;                                                                              ;
; For example: In the Mercury PCMC (82434LX), register 7C must be programmed   ;
;              with the base address and size of the frame buffer.             ;
;                                                                              ;
; Input: ESI = Absolute base address of PCI VGA frame buffer                   ;
;        ECX = Size of PCI VGA frame buffer (in bytes)                         ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	public	dih_pci_prog_frame_buf
dih_pci_prog_frame_buf	proc near
COMMENT ~
        pushad

        mov     al,PCI_FRAME_BUFFER_USWC
        call    check_cmos_data_far
        jz      dppfb_exit

	push	esi
	push	ecx
; ESI contains the base address of the PCI frame buffer.
; ECX contains the size in bytes of the memory region.
;
        and     si,0f000h               ; mask off lower 12 bits
        push    ecx
        mov     eax,esi
        mov     al,1                    ; Set USWC
        xor     edx,edx
        mov     ecx, MTRRphysBase5
.586p
        wrmsr
.486p
        pop     eax
;        shr     eax,1                   ; divide size by 2
        dec     eax
        not     eax
        and     ax,0f000h
        or      ah,08h
        mov     cx, MTRRphysMask5
.586p
        wrmsr
.486p
	pop	ecx
	pop	esi
	push	ecx

	shr	esi,10h
	mov	cx,si
	mov	di,088h
        mov     bx, (S530_BUS_NUM shl 8) + S530_DEV_FUNC_NUM
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION

	pop	ecx
	shr	ecx,10h
	dec	cx
	not	cx
	mov	di,08ah
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION

dppfb_exit:
        popad
~
	ret
dih_pci_prog_frame_buf	endp

;---------------------------------------;
; dih_pci_check_disabled                ;
;---------------------------------------;--------------------------------------;
; This function may be used to disable any PCI device in the system.  This is  ;
; useful if setup has a question which enables or disables an on-board PCI     ;
; device (for example an on-board SCSI controller).                            ;
;                                                                              ;
; Input: BL = Device/Function number of device                                 ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device                                             ;
;                                                                              ;
; Output: CF = Set if device should be disabled                                ;
;              Clear if device is ok to enable/configure/etc.                  ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	public	dih_pci_check_disabled
dih_pci_check_disabled	proc near
	cmp	bx,(S5595_BUS_NUM shl 8)+S5595_USB_DEV_FUNC_NUM
					; USB Device Number
        clc                             ; enable pci device
	jnz	not_usb
	push	ax
	mov   	al,Q_USB_FUNCTION_ENABLE
        call    check_cmos_data_far
	pop	ax
        clc                             ; enable pci device
	jnz	not_usb

	pushad
	mov	di,10h
	mov	ecx,0f8000000h		; Assign any memories for USB.
        mov     ah, RT_PCI_WRITE_CFG_DWORD
        CALL_RT_FUNCTION

;	mov	di,3ch
;	mov	cl,0fh			; Assign IRQ 15 for USB.
;        mov     ah, RT_PCI_WRITE_CFG_BYTE
;        CALL_RT_FUNCTION

	mov	di,PCI_REG_COMMAND
	mov	cx,0007h			; Enabled USB
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION

;	mov	bx,(S5595_BUS_NUM shl 8)+S5595_PCI2ISA_DEV_FUNC_NUM
;	mov	di,62h
;	mov	cl,4fh				; IRQ 15
;        mov     ah, RT_PCI_WRITE_CFG_BYTE
;        CALL_RT_FUNCTION
	popad
	stc
	ret
not_usb:
;; Get A.G.P Bridge Secondary Bus Number
	pusha
	mov	ch,bh
	mov	bx, SIS_AGP_P2P_BUS_NUM * 100h + SIS_AGP_P2P_DEV_FUNC_NUM
	mov	di, PPB_REG_SEC_BUS_NUM
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION
	cmp	ch,cl
	popa
	clc
	jnz	short not_onchip_vga
	pusha
	mov	bx, S530_BUS_NUM * 100h + S530_DEV_FUNC_NUM
        mov     di, 0afh
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION
	cmp	cl, 01h
	popa
	cmc
not_onchip_vga:
	ret				; exit
dih_pci_check_disabled	endp
;---------------------------------------;
; dih_pci_check_keep_enabled            ;
;---------------------------------------;--------------------------------------;
; This function is called just after each PCI device is configured and         ;
; enabled.  This function may inspect the device and decide to keep the device ;
; enabled or to disable the device.  One possible use of this function is to   ;
; make sure an IDE drive is connected to an IDE controller, and disable the    ;
; controller if no drive is present.                                           ;
;                                                                              ;
; Input: BL = Device/Function number of device                                 ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device                                             ;
;                                                                              ;
; Output: CF = Set if device should be disabled                                ;
;              Clear if device is ok to keep enabled                           ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	public	dih_pci_check_keep_enabled
dih_pci_check_keep_enabled	proc near
	clc
	ret
dih_pci_check_keep_enabled	endp
endif ;PCI

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
_text	ends
	end
