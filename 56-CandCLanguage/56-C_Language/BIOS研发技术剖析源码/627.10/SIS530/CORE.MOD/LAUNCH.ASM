;*****************************************************************;
include	ramdata.inc

cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup,ds:fgroup
.386p
;-----------------------------------------------;
extrn	@fill_cmos_buffers:near
extrn	get_language_no:near

extrn	_misc_info:byte
extrn	setup_ifc_data:byte
extrn	setup_ifc_data_len:abs
extrn	_setup_offset:word
extrn	_remote_offset:word

extrn	_id_byte:byte
extrn	_info_misc:byte
extrn	_hdd_help_start_string:byte
extrn	_hdd_help:abs
;-----------------------------------------------;
;		CMOS_SETUP			;
;  input :					;
;	ds = es = setup scratch data segment	;
;	al	bit-0 = 0 supervisor password	;
;			1 user password		;
;-----------------------------------------------;
	public	cmos_setup
cmos_setup:
;  init data area
	push	ax
	xor	di,di
	inc	di
	mov	cx,0ffffh
	xor	al,al
	rep	stosb
	pop	ax
;  init _remote_handler, _id_byte, _info_misc, start hdd help string#..
	mov	fgroup:_id_byte,al	; bit-0 = 0 supervisor password
					;	  1 user password
	mov	al,cgroup:_misc_info
	mov	fgroup:_info_misc,al
	mov	al,_hdd_help
	mov	fgroup:_hdd_help_start_string,al
;  init language number..
	call	get_language_no		; AX = current language number
	mov	language_no,ax
;  init cmos buffers..
	call	@fill_cmos_buffers
;  copy setup data to ram buffer..
	mov	si,offset cgroup:setup_ifc_data
	mov	di,offset ds_setup_data
	mov	cx,setup_ifc_data_len
	rep	movs es:byte ptr [di],cs:byte ptr [si]
	mov	al,00h			; setup invoke
	call	cgroup:dword ptr [_setup_offset]
	ret
;-----------------------------------------------------------------------;
;	BIOS Functions Interface					;
;-----------------------------------------------------------------------;
	extrn	@load_adv_cmos_chipset_values:near
	extrn	@get_setup_$_ptr:near
	extrn	write64_read60:near
	extrn	write_8042_command_byte:near
	extrn	ob_full_read:near
	extrn	kbc_lock:near
	extrn	write64D4_write60_read60:near
	extrn	fixed_delay:near
	extrn	single_beep:near
	extrn	end_of_interrupt:near
	extrn	read_time:near
	extrn	read_date:near
	extrn	GetHddType:near
	extrn	SetHddType:near
	extrn	GetHdMetrix:near
	extrn	DetectIDE:near
	extrn	UpdateIDEParams:near
	extrn	SetUserHdd:near
	extrn	set_language_no:near
	extrn	verify_password:near
	extrn	set_password:near
	extrn	EstablishRemoteLink@Setup:near
	extrn	RemoteDisplayOut:near
	extrn	DoRemoteKeyIn:near
	extrn	DoRemoteFunction:near
	extrn	write_key_password_to_cmos:near
	extrn	show_bios_revision:near
;-----------------------------------------------------------------------;
FuncTbl	label	near
	dw	offset cgroup:@load_adv_cmos_chipset_values
		; al => 0=Old, 1=Optimal, 2=Failsafe
	dw	offset cgroup:@get_setup_$_ptr
		; I/P: bh=String#, bl=Group# O/P: dx:ax = ptr ti string
	dw	offset cgroup:write64_read60
		; I/P: al=Command, ah=Data expected O/P: al = Data, ZR/NZ
	dw	offset cgroup:write_8042_command_byte
		; I/P: al=Data
	dw	offset cgroup:ob_full_read
		; O/P al=Data
	dw	offset cgroup:kbc_lock
		; nothing
	dw	offset cgroup:write64D4_write60_read60
		; I/P:al=command O/P:al=data
	dw	offset cgroup:fixed_delay
		; cx=count
	dw	offset cgroup:single_beep
		; nothing
	dw	offset cgroup:end_of_interrupt
		; nothing
	dw	offset cgroup:read_time
		;
	dw	offset cgroup:read_date
		;
	dw	offset cgroup:GetHddType
		;
	dw	offset cgroup:SetHddType
		;
	dw	offset cgroup:GetHdMetrix
		;
	dw	offset cgroup:SetUserHdd
		;
	dw	offset cgroup:DetectIDE
		;
	dw	offset cgroup:UpdateIDEParams
		;
	dw	offset cgroup:set_language_no
		; al = language#
	dw	offset cgroup:verify_password
		; al = supervisor/user, bx = buffer
	dw	offset cgroup:set_password
		; al = supervisor/user, bx = buffer
	dw	offset write_key_password_to_cmos
		;
	dw	offset show_bios_revision
;-----------------------------------------------------------------------;
	public	dispatch_func
dispatch_func	proc	far
	add	di,di
	lea	di,[di+offset FuncTbl]
	call	cs:word ptr [di]
	retf
dispatch_func	endp
;-----------------------------------------------------------------------;
_text	ends
END
