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
cgroup  group   _text
_text   segment para    public  USE16   'CODE'
        assume  cs:cgroup

;---------------------------------------------------------------;
; 	MP FLOATING POINTER STRUCTURE				;
;---------------------------------------------------------------;
; As defined in PC+MP Spec 1.1 dated April 1994			;
;---------------------------------------------------------------;
align	16				; must be on a 16-byte boundary
	public	mp_floating_pointer_structure
mp_floating_pointer_structure	label	byte
	db	"????"			; _MP_ search key
	dd	0000h			; Address of MP table in flat mode
					; to be initialized by POST code
	db	01h			; Length of this table in 16-byte blocks
	db	01h			; MP Spec Version #
	db	00h			; Checksum of this structure
					; to be initialized by POST
	db	00h			; MP Feature Info Byte 1
					; May hold default table if necessary
	db	00h			; MP Feature Info Byte 2	
	db	00h			; MP Feature Info Byte 3	
	db	00h			; MP Feature Info Byte 4	
	db	00h			; MP Feature Info Byte 5

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
_text   ends
        end
