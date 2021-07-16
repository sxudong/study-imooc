;*****************************************************************;
fgroup	group	fseg
fseg	segment	para	public	'FARDATA'

	public		_cmos
	public		_common_cmos_buffer
	public		_oldcmos
	public		_old_cmos_buffer
	public		_temp_buffer
	public		_id_byte
	public		_info_misc
	public		_hdd_help_start_string
	public		_ui_string_group_ptr
	public		language_no
	public		ds_setup_data

;------------------------------------------------------------------------------
_cmos			label	byte
_common_cmos_buffer	db	128 dup (?)
_oldcmos		label	byte
_old_cmos_buffer	db	128 dup (?)
_temp_buffer		db	64 dup (?)
_id_byte		db	?
_info_misc		db	?
_hdd_help_start_string	db	?	; start string# of hard disk help
			db	?	; not used
_ui_string_group_ptr	dd	?
			dd	?
			dd	?
			dd	?
			dd	?
			dd	?
			dd	?
			dd	?
language_no		dw	?

ds_setup_data		db	128 dup (?)

;------------------------------------------------------------------------------
fseg	ends
END
