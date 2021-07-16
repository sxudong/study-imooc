;*****************************************************************;
; $Header: /BIOS/CORE/627/ASM2/ramdata.inc 6     12/31/96 11:00a Debkumar $
;
; $Revision: 6 $
;
; $Date: 12/31/96 11:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/CORE/627/ASM2/ramdata.inc $
; 
; 6     12/31/96 11:00a Debkumar
; 
; 3     9/03/96 5:21p Mandal
; 6.26 for USA
; 
; 1     6/17/96 1:07p Mandal
; 
; 2     1/12/96 4:06p Dickh
; Added SourceSafe keywords to track revision history.
;  
;*****************************************************************;
fgroup	group	fseg
fseg	segment	para	public	'fardata'

	extrn	_cmos			:byte
	extrn	_common_cmos_buffer	:byte
	extrn	_old_cmos_buffer	:byte
	extrn	_temp_buffer		:byte
	extrn	ds_setup_data		:byte
	extrn	language_no		:word
	extrn	_ui_string_group_ptr	:dword

fseg	ends
