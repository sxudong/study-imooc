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

	include usb.equ
	include pci.equ
	include makeflag.equ
	include sis530.equ
;---------------------------------------;

	public	UsbGetHostControllerId
	public	UsbHcChipsetInit
	public	UsbHcChipsetShutdown
	public	UsbHcChipsetGetStatus
	public	UsbHcChipsetHandler

;---------------------------------------;

	extrn Handle60Read		:near
	extrn Handle60Write		:near
	extrn Handle64Read		:near
	extrn Handle64Write		:near
	extrn UsbHcIsr			:near

;---------------------------------------;

cgroup	group	_text
_text 	segment word public 'CODE'

	assume	cs:cgroup
.386


;---------------------------------------;
; UsbGetHostControllerId                ;
;---------------------------------------;--------------------------------------;
; This function returns the PCI device ID and vendor ID of the USB host        ;
; controller.  If the device/vendor ID of the USB host controller is not       ;
; known or undefined, this code has the option of returning the PCI            ;
; bus/device/function number of the USB host controller instead.               ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: EDX = Vendor/Device ID, if known                                     ;
;               Bit[31:16] = Device ID                                         ;
;               Bit[15:00] = Vendor ID                                         ;
;	      = 0000, if not known or undefined                                ;
;         BH = PCI Bus number (valid only if EDX = 0)                          ;
;         BL = Device / Function number (valid only if EDX = 0)                ;
;              Bits 7-3: PCI device number                                     ;
;              Bits 2-0: Function number within the device                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbGetHostControllerId	proc near

;	mov	edx, 70011039h		;SiS 7001 USB Host Controller
	xor	edx,edx
	mov	bx,(S5595_BUS_NUM shl 8)+S5595_USB_DEV_FUNC_NUM

	ret
UsbGetHostControllerId	endp


;---------------------------------------;
; UsbHcChipsetInit                      ;
;---------------------------------------;--------------------------------------;
; This function should enable the generation of SMI by the USB host controller ;
; due to port 60/64 reads and writes and due to USB interrupt.                 ;
;                                                                              ;
; Input: BH = PCI Bus number of USB host controller                            ;
;        BL = Device / Function number of USB host controller                  ;
;             Bits 7-3: PCI device number                                      ;
;             Bits 2-0: Function number within the device                      ;
;        CL = USB interrupt and port 60/64 read/write SMI flags                ;
;             Bit 0: If set, generate SMI on reads to port 60                  ;
;             Bit 1: If set, generate SMI on writes to port 60                 ;
;             Bit 2: If set, generate SMI on reads to port 64                  ;
;             Bit 3: If set, generate SMI on writes to port 64                 ;
;             Bit 4: If set, generate SMI on USB interrupt                     ;
;             Bit 7-5: Reserved                                                ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbHcChipsetInit	proc near
	push	dx
	push	ax
	mov     dx,MKF_PM_BASE_ADDRESS+031h   ; enable USB SMI
        in      al,dx			    
        jmp     short $+2
        or      al,40h                      
        jmp     short $+2
        out     dx,al			    
	pop	ax
	pop	dx
	ret
UsbHcChipsetInit	endp


;---------------------------------------;
; UsbHcChipsetShutdown                  ;
;---------------------------------------;--------------------------------------;
; This function should disable the generation of SMI by the USB host controller;
; due to port 60/64 reads and writes and due to USB interrupt.                 ;
;                                                                              ;
; Input: BH = PCI Bus number of USB host controller                            ;
;        BL = Device / Function number of USB host controller                  ;
;             Bits 7-3: PCI device number                                      ;
;             Bits 2-0: Function number within the device                      ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
UsbHcChipsetShutdown	proc near
	
	push	ax
	push	dx
	mov     dx,MKF_PM_BASE_ADDRESS+030h   ; clear SMI status
        in      al,dx			    
        jmp     short $+2
        and     al,40h                      
        jmp     short $+2
        out     dx,al			    

	mov     dx,MKF_PM_BASE_ADDRESS+031h   ; disable usb SMI
        in      al,dx			    
        jmp     short $+2
        and     al,not 40h                      
        jmp     short $+2
        out     dx,al			    
	pop	dx
	pop	ax

	ret
UsbHcChipsetShutdown	endp


;---------------------------------------;
; UsbHcChipsetGetStatus                 ;
;---------------------------------------;--------------------------------------;
; This function returns the current status of USB and port 60/64 read/write    ;
; SMI logic.                                                                   ;
;                                                                              ;
; Input: BH = PCI Bus number of USB host controller                            ;
;        BL = Device / Function number of USB host controller                  ;
;             Bits 7-3: PCI device number                                      ;
;             Bits 2-0: Function number within the device                      ;
;                                                                              ;
; Output: CL = USB interrupt and port 60/64 read/write SMI flags               ;
;              Bit 0: If set, SMI generated on reads to port 60                ;
;              Bit 1: If set, SMI generated on writes to port 60               ;
;              Bit 2: If set, SMI generated on reads to port 64                ;
;              Bit 3: If set, SMI generated on writes to port 64               ;
;              Bit 4: If set, SMI generated on USB interrupt                   ;
;              Bit 7-5: Reserved                                               ;
;                                                                              ;
; Destroys: SI, DI                                                             ;
;------------------------------------------------------------------------------;
UsbHcChipsetGetStatus	proc near
	push	dx
	push    ax
	mov     dx,MKF_PM_BASE_ADDRESS+030h   ; Get USB SMI
        in      al,dx			    
        jmp     short $+2
	and     al,01000000b
        jmp     short $+2
	mov     cl,al
	shr     cl,2
	pop     ax
	pop	dx
	ret
UsbHcChipsetGetStatus	endp


;---------------------------------------;
; UsbHcChipsetHandler                   ;
;---------------------------------------;--------------------------------------;
; This function is called when the USB controller or the port 60/64 read/write ;
; trapping logic generates an SMI.  This code should perform the following     ;
; steps:                                                                       ;
;                                                                              ;
;   1. Disble port 60/64 read/write trapping temporily                         ;
;   2. Check why this SMI was genearated and call one of the following         ;
;      routines if neccessary:                                                 ;
;        a. Handle60Read                                                       ;
;        b. Handle60Write                                                      ;
;        c. Handle64Read                                                       ;
;        d. Handle64Write                                                      ;
;   3. Check if the USB host controller interrupt is active and call           ;
;      UsbHcIsr if it is.                                                      ;
;   4. Clear all interrupts (port 60/64 read/write and USB interrupt)          ;
;   5. Reenable the port 60/64 trapping logic to the state that it was in      ;
;      when this function got control.                                         ;
;                                                                              ;
; Input: DS = ES = Usb Data Area                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Any general purpose register                                       ;
;------------------------------------------------------------------------------;
UsbHcChipsetHandler	proc near

	call	UsbHcIsr

	mov     dx,MKF_PM_BASE_ADDRESS+030h   ; Clear USB SMI Status
	mov     al,60h
        out     dx,al			    ;
        jmp     short $+2
	ret
UsbHcChipsetHandler	endp


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
