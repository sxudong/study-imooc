 	page	,132
	title .	Run Time USB Routines
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
	include	rt.equ
	include	usb.equ
        include setupequ.ext
	include sis5595.equ
	include makeflag.equ
;---------------------------------------;
	extrn	read_pci_byte:near
	extrn	read_sio_byte:near
	extrn	write_pci_byte:near
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text segment word public 'CODE'
	assume	cs:CGROUP
.386


;---------------------------------------;
; RtUsbApi                              ;
;---------------------------------------;--------------------------------------;
;                                                                              ;
; Input: AH = Function number (RT_USB_API)                                     ;
;        AL = Subfunction number                                               ;
;        EBX, ECX, EDI = May contain function specific data                    ;
;                                                                              ;
; Output: EAX, EBX, ECX, EDI = May contain function specific data              ;
;                                                                              ;
; Usage: Do not destroy any register except EAX, EDX, ESI                      ;
;------------------------------------------------------------------------------;
	public	RtUsbApi
RtUsbApi	proc near
	movzx	si, al			;SI = subfunction number
	shl	esi, 16			;ESI[31:16] = subfunction number
	mov	si, 5342h		;Software SMI function "SB"
	stc				;CF defaults to set
;  Write the code here to generate software SMI
;  The code to generate software SMI should use only the register EDX, EAX.
;  All other registers may have function specific inputs.
;  In Intel PIIX* chipset, code is	OUT	0B2H,AL
;					The data in AL is DON'T CARE

;	mov     dx,MKF_PM_BASE_ADDRESS+031h 
;        in      al,dx			    ; enable SMI COMMAND ENABLE
;        jmp     short $+2		    ; enable SMI COMMAND DISABLE
;        or      al,18h                      ;
;        jmp     short $+2		    ;
;        out     dx,al			    ;
;        jmp     short $+2		    ;

;        mov     dx,MKF_PM_BASE_ADDRESS+034h   ; set SMI COMMAND ENABLE value
;        mov     al,SMI_COMMAND_EN           ;
;        out     dx,al			    ;
;        jmp     short $+2		    ;

        mov     dx,MKF_PM_BASE_ADDRESS+035h   ; set SMI COMMAND value
	call	check_sb_revision
	jnz	short @f
   	mov	dl,32h
@@:
        mov     al,SMI_COMMAND_DI           ;
	out     dx,al
        jmp     short $+2		    ;

	ret
RtUsbApi	endp

check_sb_revision:
;; Output : NZ = 5595B1 or Later
;; 	    ZR = 5595A2	   
	push	ax
	mov	ah,08h
	call	read_sio_byte
	cmp	al,01h 		; Rev A2?
	pop	ax
	ret


;---------------------------------------;
; StopUsbHostController                 ;
;---------------------------------------;--------------------------------------;
; Check point : 05                                                             ;
; This function is called from DISABLE_ALL_CACHE routine in RUNTIME.ASM file.  ;
; This function should disable USB host controller.                            ;
; Input :								       ;
;	stack	available						       ;
; Register usage : can destroy any register except  DS, ES, EBP		       ;
; Note:                                                                        ;
; 1. This function should implement the following:                             ;
;	* Disable all SMI generation                                           ;
;	* Disable USB Bus Mastering                                            ;
;	* Disable USB Host controller                                          ;
;	* Disable SMI generation from USB                                      ;
;	* Disable Legacy Logic (i.e. Disable Port 60/46 trapping)              ;
;------------------------------------------------------------------------------;
	public	StopUsbHostController
StopUsbHostController	proc near
        mov   ax,2f02h          ; Stop USB Host controller
	CALL_RT_FUNCTION
	ret
StopUsbHostController	endp

;---------------------------------------;
; EnableUsbFunctionInChipset     	;
;---------------------------------------;--------------------------------------;
; Check point : 13                                                             ;
; This function is called from CP_INIT in POST.ASM file. This function should  ;
; do the following:                                                            ;
;  * Enable USB function in chipset.                                           ;
;  * Set USB clock (if needed) according to hardware.                          ;
;  * NOTE THAT USB HOST CONTROLLER IS ALREADY STOPPED WHEN THIS FUNCTION IS    ;
;    INVOKED.                                                                  ;
; Input :								       ;
;	stack	available						       ;
; Output:                                                                      ;
;	none                                                                   ;
; Register usage : can destroy any register except DS, ES, EBP		       ;
; Note :                                                                       ;
; 1. If USB Function is NOT configurable in chipset, just return.              ;
; 2. If USB clock is NOT programmable, nothing needs to be done for USB clock. ;
; 3. Deafult implementation is	RET.                                           ;
; 4. If USB Fucntion is configurable but motherboard does NOT have any USB     ;
;    support/connector, USB function should be DISABLED here otherwise Core    ;
;    BIOS will allocate necessary resources to USB function which is a WASTAGE.;
;------------------------------------------------------------------------------;
	public	EnableUsbFunctionInChipset
EnableUsbFunctionInChipset	proc	near
%Out	Did you port Enable/Disable USB Function in Chipset properly ?
	ret
EnableUsbFunctionInChipset	endp

;---------------------------------------;
; DisableUsbFunctionInChipset     	;
;---------------------------------------;--------------------------------------;
; Check point : AA                                                             ;
; This function is called from SPECIAL_CONFIG_DISPLAY routines in POST.ASM.    ;
; This function should do the following:                                       ;
;  * Disable USB function in chipset so that USB function is NOT visible in    ;
;    PCI configuration space.                                                  ;
;  * NOTE THAT USB HOST CONTROLLER IS ALREADY STOPPED WHEN THIS FUNCTION IS    ;
;    INVOKED.                                                                  ;
; Input :								       ;
;	stack	available						       ;
; Output:                                                                      ;
;	none                                                                   ;
; Register usage : can destroy any register except DS, ES, EBP		       ;
; Note :                                                                       ;
; 1. If USB Function is NOT configurable in chipset, just return.              ;
; 2. Deafult implementation is	RET                                            ;
;------------------------------------------------------------------------------;
	extrn	get_cmos_item:near
	public	DisableUsbFunctionInChipset
DisableUsbFunctionInChipset	proc	near
	ret
DisableUsbFunctionInChipset	endp

comment ~
;-----------------------------------------------------------------------;
;			USB_BUS_MASTERING				;
;-----------------------------------------------------------------------;
; Input:								;
;	None								;
; Output:								;
;	EBX = Bus Mastering asddress					;
; Register destroyed:							;
; Can destroy any registers except for ES, DS, EBP, FS, GS		;
;-----------------------------------------------------------------------;
	public	usb_bus_mastering
usb_bus_mastering	proc	near
	push	es
	mov	dx,0dc00h
	mov	ax,0ffffh
next_segment:
	push	dx
	pop	es
	xor	di,di
	mov	cx,2000h
	repz	scasw
	jcxz	find_usb_segment
	sub	dh,04h
	cmp	dh,0c4h
	jz	usb_01
	jmp	short next_segment

find_usb_segment:
	xchg	dh,dl
	shr	dx,2
	sub	dl,030h
;; Make shadow segment readable 
	shr	dl,1
	mov	dh,0ah
	jc	short usb_00
   	mov	dh,0a0h
usb_00:
	mov	ah,70h
	add	ah,dl
	call	read_pci_byte
	or	al,dh
	call	write_pci_byte

	xor	ebx,ebx
	mov	bx,es
	shl	ebx,4
usb_01:
	pop	es
	ret
usb_bus_mastering	endp
end-comment ~
;------------------------------------------------------------------------------;
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
