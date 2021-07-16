	page	,132
	title	Dummy PnP NVRam support
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
	extrn	flash_support_table:byte
	public	rthnvr_read_nvr_byte
	public	rthnvr_read_nvr_word
	public	rthnvr_write_nvr_byte
	public	rthnvr_write_nvr_word
	public	rthnvr_write
	public	rth_nvram_size
	public	rth_nvram_base

;;	extrn	rt_pnp_entry:byte
;;	extrn	rt_pnp_entry_prot:byte

	public	read_word
	public	flash_erase
	public	flash_program

;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment para public 'CODE'
	assume	cs:CGROUP
.386p
;---------------------------------------;
; Plug and Play Installation Check      ;
;---------------------------------------;--------------------------------------;
; This structure signals runtime software that this BIOS supports the Plug and ;
; Play BIOS interface.  Runtime software will search F0000 to FFFF0 for this   ;
; structure on each paragraph boundary.  After validating this structure,      ;
; runtime software will either the real mode or 16 bit protected mode entry    ;
; points given below to make calls to Plug and Play runtime functions.         ;
;------------------------------------------------------------------------------;
	public	rt_pnp_inst_check_start
rt_pnp_inst_check_start:

PnPIC_Signature		db '$PnP'	; '$PnP'
PnPIC_Revision		db 10h
PnPIC_Length		db offset CGROUP:rt_pnp_inst_check_end - CGROUP:rt_pnp_inst_check_start
PnPIC_ControlFlags	dw 00h
PnPIC_CheckSum		db 00h
PnPIC_EventFlagAddr	dd 00000000h
PnPIC_RMEntryOffset	dw 0000h	; offset CGROUP:rt_pnp_entry
PnPIC_RMEntrySegment	dw 0000h	; 0F000h
PnPIC_PMEntryOffset	dw 0000h	; offset CGROUP:rt_pnp_entry_prot
PnPIC_PMEntryBase	dd 00000000h	; 000F0000h
PnPIC_OEMDevID		dd 00000000h
PnPIC_RMDataSegment	dw 00000h	; These should match rth_nvram_base in
PnPIC_PMDataBase	dd 00000000h	; corresponding .ASM file of Flash part

rt_pnp_inst_check_end:

;---------------------------------------;
rth_nvram_size	dw	0000h		;NVRam size is 4k bytes
					;Make this 0 if this system has no NVRam

rth_nvram_base	dd	00000000h	;The 32 bit physical address of the
					;memory (Flash) that is used for NVRam.
					;This is needed so that protected mode
					;callers can build a proper descriptor
					;that the BIOS can use to access that
					;memory.  Make this 0 if this system
					;has no NVRam or NVRam is accessed via
					;I/O ports.  This value should match
					;PnPIC_RMDataSegment in RTH.ASM.
;---------------------------------------;
rthnvr_read_nvr_byte:
rthnvr_read_nvr_word:
rthnvr_write_nvr_byte:
rthnvr_write_nvr_word:
rthnvr_write:
	stc
	ret
;---------------------------------------;
read_word:
	retf
;---------------------------------------;
; flash_erase                           ;
;---------------------------------------;--------------------------------------;
; This function erases the NVRam area in Flash.                                ;
;                                                                              ;
; Input: ES:DI = Seg/Offset of NVRam area of Flash                             ;
;           CX = Size of Flash block to erase                                  ;
;                                                                              ;
; Output: CF  = Set if error, cleared otherwise                                ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
flash_erase:
	stc				; error				
	ret
;---------------------------------------;
; flash_program                         ;
;---------------------------------------;--------------------------------------;
; This function writes the NVRam contents in Flash from a buffer supplied by   ;
; the caller.                                                                  ;
;                                                                              ;
; Input: ES:SI = Buffer of data to write to NVRam                              ;
;        DS:DI = Seg/Offset of NVRam area of Flash                             ;
;           CX = Size of Flash block to write                                  ;
;                                                                              ;
; Output: CF  = Set if error, cleared otherwise                                ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
flash_program:
	stc				; error
	ret
;---------------------------------------;
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
