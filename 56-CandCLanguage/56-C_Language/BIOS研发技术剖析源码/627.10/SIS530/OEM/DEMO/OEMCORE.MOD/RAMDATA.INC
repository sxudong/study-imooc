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
