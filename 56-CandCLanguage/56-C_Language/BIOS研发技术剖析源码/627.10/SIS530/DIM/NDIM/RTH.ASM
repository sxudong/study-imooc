	page	,132
	title .		Hooks into Run Time Functions
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
	include dim.equ
	include rt.equ
	include devnode.equ
	include	mac32.mac
;---------------------------------------;
	extrn rt_entry:          near
;---------------------------------------;

	public rth_pnp_set_isa_res
	public rth_pnp_get_isa_res
	public rth_isa_resmap_read_byte

;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment byte public 'CODE'
	assume	cs:CGROUP
.386

;------------------------------------------------------------------------------;

;--------------------------------------;
; rth_pnp_set_isa_res                  ;
;--------------------------------------;---------------------------------------;
; This function accepts a list of resource descriptors that describe resources ;
; that are in use by legacy ISA devices.  This call is used for systems that   ;
; do not have NVRam.  If this system has NVRam, then the ESCD structure should ;
; be used to store this information and this function should return with       ;
; error code RT_PNP_USE_ESCD (8Dh).                                            ;
;                                                                              ;
; Input:  [EBP+00] = Function number (09h)                                     ;
;         [EBP+02] = BYTE FAR *ResourceBlock                                   ;
;         [EBP+06] = WORD BiosSelector                                         ;
;                                                                              ;
; Output: AX = Zero if success, non-zero return code if non successful         ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rth_pnp_set_isa_res	proc near
	mov	ax, RT_PNP_USE_ESCD
	ret
rth_pnp_set_isa_res	endp


;--------------------------------------;
; rth_pnp_get_isa_res                  ;
;--------------------------------------;---------------------------------------;
; This function returns a list of resource descriptors that describe resources ;
; that are in use by legacy ISA devices.  This call is used for systems that   ;
; do not have NVRam.  If this system has NVRam, then the ESCD structure should ;
; be used to store this information and this function should return with       ;
; error code RT_PNP_USE_ESCD (8Dh).                                            ;
;                                                                              ;
; Input:  [EBP+00] = Function number (0Ah)                                     ;
;         [EBP+02] = BYTE FAR *ResourceBlock                                   ;
;         [EBP+06] = WORD BiosSelector                                         ;
;                                                                              ;
; Output: AX = Zero if success, non-zero return code if non successful         ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rth_pnp_get_isa_res	proc near
	mov	ax, RT_PNP_USE_ESCD
	ret
rth_pnp_get_isa_res	endp


;--------------------------------------;
; rth_isa_resmap_read_byte              ;
;---------------------------------------;--------------------------------------;
; This function reads one byte from the ISA Used Resource Map structure and    ;
; returns it in AL.                                                            ;
;                                                                              ;
; NOTE: This function should only be called from RT.ASM.  All other            ;
; callers must call the rt_entry (in RT.ASM) with AH containing the proper     ;
; function number (see RT.EQU).                                                ;
;                                                                              ;
; Input:  BX = Offset of byte to read from the ISA Used Resource Map structure ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         AL = Byte that was read from NVRam                                   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rth_isa_resmap_read_byte proc near
	xor	al, al			;Simulate blank ISA res map for testing
isa_respmap_exit:
	clc
	ret
rth_isa_resmap_read_byte endp



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
