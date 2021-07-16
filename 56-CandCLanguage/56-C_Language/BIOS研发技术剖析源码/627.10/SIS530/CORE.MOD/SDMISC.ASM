	page	50,130
	title	SDMISC.ASM
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;
;	MISCELLANEOUS SETUP DATA AND ASSOCIATED ROUTINES		;
;-----------------------------------------------------------------------;
	extrn	str_not_installed:abs
	extrn	str_user:abs
	extrn	str_auto:abs
	extrn	str_cdrom:abs
	extrn	str_floptical:abs
;---------------------------------------;
	extrn	cmos_data_in:near
	extrn	cmos_data_out:near
	extrn	read_cmos_word:near
	extrn	get_setup_$_ptr:near
	extrn	auto_hd_type:near
	extrn	get_pio_mode_value:near
	extrn	check_cmos_8e:near
	extrn	buffer_password_length:near
	extrn	get_bl_al:near

	extrn	ide_prim_base_addr:word
	extrn	ide_sec_base_addr:word
	extrn	setup_data_struc_start:byte
	extrn	hd_tbl_start:byte
	extrn	base_tbl:byte
;---------------------------------------;
_StrSet2	equ	02h		; string set 2
;---------------------------------------;
	include	ramdata.inc
	include	cmos.equ
;---------------------------------------;
setup_data_struc	struc
	cmos_reg	db	(?)	; Cmos register number.
					; if bit-7 = 1 then option is  present
					; else option is absent.
	mask_value	db	(?)	; Mask to be used to acess the value from cmos register.
setup_data_struc	ends
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup, ds:fgroup
.386p
;---------------------------------------;
;	PutCharWord			;
; I/P :	ax	data to store		;
;	es:di	address to store	;
;---------------------------------------;
PutCharWord	proc	near
	mov	cx,10			; divide by 10
	xor	dx,dx
	div	cx
	or	ax,ax			; quotient = 0 ?
	jz	ascii_2			; yes - got a digit
	push	dx			; save remainder
	call	PutCharWord
	pop	dx
ascii_2:
	mov	ax,dx			; get remainder
	or	al,30h			; convert to ascii
	stosb				; and store
	ret
PutCharWord	endp
;---------------------------------------;
;	GET_CMOS_BUFFER_ITEM		;
; puts value in non-consecutive bits in ;
; cmmon cmos buffer byte		;
; input :				;
;	al	structure#		;
; output:				;
;	al	right justified value	;
;	ZR	if value is zero	;
;	NZ	if value is non-zero	;
; Destroys : AX				;
;---------------------------------------;
	public	get_cmos_buffer_item
get_cmos_buffer_item	proc	near
	push	cx
	push	bx
	mov	ch,ah			; save input AH
	movzx	bx,al
	shl	bx,1
	add	bx,offset cgroup:setup_data_struc_start
	mov	ah,cs:(setup_data_struc ptr [bx]).mask_value; AH = mask_value
	mov	bl,cs:(setup_data_struc ptr [bx]).cmos_reg; BL = cmos register
	and	bx,007fh		; BX = cmos reg = offset to cmos buffer
;  AH = mask value..
;  BX = offset to cmos buffer..
	mov	al,_common_cmos_buffer[bx]; AL = value
	mov	bh,ah
;  AL = full register value..BH = mask value for bits..
	mov	cl,08h			; loop count
	mov	ah,0
gcbi_9:
	rol	bh,1			; Check MSB
	jnc	gcbi_10			; No carry = MSB was 0.
	rol	ax,1			; Mov MSB of AL to LSB of Ah.
	jmp	short gcbi_11
gcbi_10:
	rol	al,1			; Ignore MSB.
gcbi_11:
	dec	cl
	jnz	gcbi_9
	mov	al,ah			; Final value.
	mov	ah,ch			; restore original AH
	or	al,al			; Set/Reset Zero flag.
	pop	bx
	pop	cx
	ret				; Go back.
get_cmos_buffer_item	endp
;---------------------------------------;
;	SET_CMOS_BUFFER_ITEM		;
; puts value in non-consecutive bits in ;
; cmmon cmos buffer byte		;
; input :				;
;	al	structure#		;
;	ah	new value of mask	;
; output:				;
;	none				;
; Destroys : none			;
;---------------------------------------;
	public	set_cmos_buffer_item
set_cmos_buffer_item	proc	near
	pusha
	movzx	bx,al
	shl	bx,1
	add	bx,offset cgroup:setup_data_struc_start
	mov	dl,cs:(setup_data_struc ptr [bx]).mask_value; DL = mask_value
	mov	bl,cs:(setup_data_struc ptr [bx]).cmos_reg
	and	bl,7fh
	mov	bh,00h			; BX = cmos register
	mov	al,ah			; AL = new value to put
	call	PutSparseVal
	popa
	ret
set_cmos_buffer_item	endp
;---------------------------------------;
;	PutSparseVal			;
; puts value in non-consecutive bits in ;
; a byte				;
; I/P :	bx	target address		;
;	al	new value to put	;
;	dl	mask value		;
; Returns				;
;	al	new byte value		;
; Destroys	ax,cx,dl		;
;---------------------------------------;
PutSparseVal	proc	near
	mov	ah,al
	mov	al,[bx]
	mov	cx,8
pv1:
	shr	dl,1
	jc	pv0
	ror	al,1
	jmp	short	pv2
pv0:
	shr	ax,1
pv2:
	loop	pv1
	mov	[bx],al
	ret
PutSparseVal	endp
;---------------------------------------;
; 	GetHddType			;
; returns hard disk type		;
; Input :				;
; 	al = 0  harddisk C		;
;	   = 1  harddisk D		;
;	   = 2  harddisk E		;
;	   = 3  harddisk F		;
; Output :				;
;	al = type			;
; Destroys AX,BX			;
;---------------------------------------;
_hddC	equ	0
_hddD	equ	1
_hddE	equ	2
_hddF	equ	3

GetHddType	proc	near
	mov	ah,_cmos[harddisk_cd]	; C/D type
	cmp	al,_hddD
	ja	ght1			; > D, jump
	je	ght2			; = D
	shr	ah,4			; C - get type from upper nibble
ght2:
	and	ah,0fh			; ah = C/D type
	cmp	ah,15			; type 15 ?
	jne	ght3			; no - ok
	mov	bx,extd_hdisk_c		; extd type base = 19h for C/D
	jmp	short	ght4
ght1:					; al = 2/3 -> E/F
	mov	bx,harddisk_e-2		; type base = 29h for E/F
ght4:
	add	bl,al			; C=19/D=1a/E=2b/F=2c
	mov	ah,_cmos[bx]		; get extd type
ght3:
	mov	al,ah
	and	al,3fh			; mask off unwanted bits
	ret
GetHddType	endp
;---------------------------------------;
; 	SetHddType			;
; sets hard disk type in cmos buffer	;
; Input :				;
;	al = type			;
; 	dl = 0  harddisk C		;
;	   = 1  harddisk D		;
;	   = 2  harddisk E		;
;	   = 3  harddisk F		;
; Destroys AX,BX,CX,DX			;
;---------------------------------------;
SetHddType	proc	near
	cmp	dl,_hddD
	ja	sht6			; >D, jump

	mov	ah,0fh			; mask for D
	mov	bx,extd_hdisk_c		; extd type base = 19h for C/D
	je	sht1			; =D, jump
	mov	ah,0f0h			; mask for C
sht1:
	cmp	al,15
	ja	sht2			; > type15, jump
	add	bl,dl			; extd type offset, C=19h/D=1ah
	mov	_cmos[bx],0		; make it 0 for < type 15
	mov	bx,harddisk_cd		; offset for C/D type
	mov	dl,ah			; get mask in dl
	jmp	short	sht3
sht2:					; > type 15
	or	_cmos[harddisk_cd],ah	; put 15 here
	jmp	short	sht7
sht6:
	mov	bx,harddisk_e-2		; type base = 29h for E/F
sht7:
	add	bl,dl			; C=19/D=1a/E=2b/F=2c
	mov	dl,3fh			; mask
sht3:
	lea	bx,_cmos[bx]		; get full address
	call	PutSparseVal		; put new value
	ret
SetHddType	endp
;---------------------------------------;
	public	GetHddTypeC
GetHddTypeC	label	far
	mov	al,0
	jmp	short	hdd_together
;---------------------------------------;
	public	GetHddTypeD
GetHddTypeD	label	far
	mov	al,1
	jmp	short	hdd_together
;---------------------------------------;
	public	GetHddTypeE
GetHddTypeE	label	far
	mov	al,2
	jmp	short	hdd_together
;---------------------------------------;
	public	GetHddTypeF
GetHddTypeF	label	far
	mov	al,3
;---------------------------------------;
hdd_together:
	call	GetHddType
; now find the string
	mov	bh,str_not_installed
	or	al,al			; if type 0
	jz	ght_2			; say not installed
	cbw				; ah=0
	mov	bh,str_user
	cmp	al,47			; if not between 1..46
	je	ght_2			; 47 = User
	ja	ght_0			; > 47
; here comes types 1..46
	push	ds
	pop	es
	mov	di, offset _temp_buffer	; es:di = buffer
	push	di			; save offset
	call	PutCharWord		; convert to ascii
	sub	al,al
	stosb				; put zero at end
	pop	bx			; get offset in bx
	mov	dx,es			; dx:bx = ptr to string
	retf
ght_0:					; type > 47
	mov	bh,str_auto
	cmp	al,49
	jb	ght_2			; auto
	mov	bh,str_cdrom
	jz	ght_2			; cdrom
	mov	bh,str_floptical	; floptical
ght_2:
	mov	bl,_StrSet2
	call	get_setup_$_ptr		; get string ptr
	mov	bx,ax			; return in dx:bx
	retf
;---------------------------------------;
HdMetrix	STRUC
	_Cyl	dw	?
	_Head	db	?
	_WP	dw	?
	_Sec	db	?
	_Type	dw	?
	_StrSet	db	?
	_StrID	db	?
HdMetrix	ENDS
;---------------------------------------;
_Type47Loc	label	byte		; type 47 area for drives
	db	uc_cylinder		; primary master
	db	ud_cylinder		; primary slave
	db	ue_cylinder		; secondary master
	db	uf_cylinder		; secondary slave
;---------------------------------------;
;	GetHdMetrix			;
; This routine returns drive params	;
; viz. type, cyl, head, sec/trk etc. in	;
; a structure.				;
; Input :				;
;	ax	harddisk type		;
;	bx	ptr to structure buffer	;
;	dx	drive ID		;
; 		0  harddisk C		;
;	   	1  harddisk D		;
;	   	2  harddisk E		;
;	   	3  harddisk F		;
;---------------------------------------;
size_p	equ	6
;---------------------------------------;
	public	GetHdMetrix
GetHdMetrix	proc	near
	pusha
	mov	di,bx
	push	ds
	pop	es

	mov	(HdMetrix ptr [di])._StrSet,_StrSet2
	mov	(HdMetrix ptr [di])._StrID,0
	mov	(HdMetrix ptr [di])._Cyl,0

	mov	bl,str_not_installed
	or	ax,ax
	jz	ghm3			; not installed
	mov	bl,str_auto
	mov	cx,ax			; save type in cx
	sub	ax,47
	ja	ghm0			; Auto/CDROM
	je	ghm1			; type 47

; Type 1..46 ---------------------------;
; calculate offset into parameter table
	mov	ax,cx
	dec	ax
	shl	ax,4			; * 16
	add	ax,offset cgroup:hd_tbl_start	; add with base address
	mov	bx,ax
; retrieve parameters from table
	mov	ax,cs:[bx]		; cylinder
	stosw
	mov	al,cs:[bx+2]		; head
	stosb
	mov	ax,cs:[bx+5]		; write precomp
	stosw
	mov	al,cs:[bx+14]		; sector
	stosb
	jmp	short	ghm2
ghm1:
; Type 47 ------------------------------;
	push	di
	mov	bx,dx			; current hard disk (0..3)
	mov	bl,cs:_Type47Loc[bx]	; type 47 area offset
	lea	si,_cmos[bx]		; si = drive parms
	mov	cx,size_p
	rep	movsb			; copy params
	mov	bl,str_user
	pop	di
	jmp	short	ghm3
ghm0:
	dec	al
	jz	ghm3
	mov	bl,str_cdrom
	dec	al
	jz	ghm3
	mov	bl,str_floptical
ghm3:
	mov	(HdMetrix ptr [di])._StrID,bl
ghm2:
	popa
	ret
GetHdMetrix	endp
;---------------------------------------;
FieldTbl	label	byte
	db	2			; Width of 1st field (Cylinder)
	db	2			; Cylinder
	db	1			; Head
	db	2			; WPcom
	db	1			; Sec
;---------------------------------------;
;	SetUserHdd			;
; Set Type47 Fields.			;
; Input :				;
; 	al	1 - Cyl			;
;		2 - Head		;
;		3 - Write Precomp	;
;		4 - Sector		;
;	bx	Drive ID		;
;	dx	New value		;
;---------------------------------------;
SetUserHdd	proc	near
	mov	si,offset FieldTbl+1	; Field width table
	mov	bl,cs:_Type47Loc[bx]	; type 47 area offset
	sub	bx,2
BuildBL:
	add	bl,cs:[si-1]		; Forward pointer
	mov	ah,cs:[si]		; Keep current field width
	inc	si			; Next table pointer
	dec	al
	jnz	BuildBL
;;;;	mov	byte ptr _cmos[bx],cl	; BUG should be DL..01/23/96
	mov	byte ptr _cmos[bx],dl
	inc	bx
	cmp	ah,1			; Byte or word ?
	jz	RetMT47			; Yes, done
;;;;	mov	byte ptr _cmos[bx],ch	; else move upper byte..BUG should be DH..01/23/96
	mov	byte ptr _cmos[bx],dh	; else move upper byte
RetMT47:
	ret
SetUserHdd	endp
;---------------------------------------;
;	DetectIDE			;
; Input :				;
;	ax	Drive ID		;
;	bx	Scratch Buffer		;
;---------------------------------------;
DetectIDE	proc	near
	mov	di,cgroup:ide_prim_base_addr
	cmp	al,02h
	jb	hd_prim_sec
	mov	di,cgroup:ide_sec_base_addr
hd_prim_sec:
	and	al,01h
	add	al,80h
	mov	dl,al			; DL = drive# 80h/81h
;  DI = base address..DL = drive# 80h/81h
	mov	si,40*4			; maxm wait time 40secs
	push	ds
	pop	es			; ES:BX ptr to buffer
	mov	cl,0ffh			; CX <> 0000, invoked from setup
	call	auto_hd_type		; ES:BX has scrach buffer address
;;;;	mov	al,0
;;;;	jc	hd_ret
;;;;	inc	al
;;;;hd_ret:
	ret
DetectIDE	endp
;---------------------------------------;
_AdvIdeLocn	label	byte
	db	adv_ide_c		; for prim master
	db	adv_ide_d		; for prim slave
	db	adv_ide_e		; for sec  master
	db	adv_ide_f		; for sec  slave
;---------------------------------------;
;	UpdateIDEParams			;
;  This routine updates the enhenaced	;
;  parameters in cmos buffer.		;
;  Input :				;
;	al	0/1/2/3 for C:/D:/E:/F:	;
;	es:bx	ptr to buffer having	;
;		info from identify drive;
;		command			;
;  output:				;
;	none				;
;  register destroyed..NONE		;
;---------------------------------------;
UpdateIDEParams	proc	near
	pusha
	push	bx
	mov	bx,offset cgroup:_AdvIdeLocn
	xlat	cgroup:_AdvIdeLocn	; AL = cmos register used
	pop	bx
	movzx	di,al
	add	di,offset _cmos		; DI = ptr to cmos buffer offset
	xor	cl,cl			; form info in CL
	test	es:byte ptr [bx+2*49+1],02h; bit-1 = 0/1..LBA not/yes supported
	jz	lba_mode		; LBA mot supported
	or	cl,lba_bit		; indicate LBA supported
lba_mode:
	cmp	es:byte ptr [bx+2*47],00h; #of sectors per interrupt = 00 ?
	jz	block_mode		; yes..so block mode not supported
	or	cl,block_bit		; indicate block mode supported
block_mode:
	push	cx
	call	get_pio_mode_value	; BL = mode value
	pop	cx
	inc	bl
	cmp	bl,06h
	jbe	bm_00
	mov	bl,06h
bm_00:
	shl	bl,pio_shift		; proper bit posn
	or	cl,bl
	and	byte ptr [di],bit32_bit	; keep 32bit info
	or	byte ptr [di],cl	; update other info
	popa
	ret
UpdateIDEParams	endp
;---------------------------------------;
;	Verify_Password			;
; Input :				;
;	al 	0..supervisor password	;
;		1..user password	;
;	ds:bx   ptr to buffer		;
; Output:				;
;	al	= 00 match		;
;		<>00 not match		;
; register destroyed : AX		;
;---------------------------------------;
verify_password	proc	near
	pusha
	push	bx
	mov	si,bx			; DS:SI = ptr to given buffer
	call	buffer_password_length	; CX = entered password length
	push	cx			; save entered password length
	mov	si,offset _common_cmos_buffer+38h; supervisor password
	or	al,al
	jz	vp_00
	mov	si,offset _common_cmos_buffer+4ch; user password
vp_00:
	push	si
	call	buffer_password_length	; CX = installed password length
	pop	di			; DS:DI = ptr to installed encoded password
	pop	dx			; DX = entered password length
	pop	si			; DS:SI = ptr to entered ASCIIZ password
	cmp	cx,dx
	jnz	vp_01			; length mismatch..so error
	jcxz	vp_01			; length match and length = 0..so ok
;  installed and entered password length same..verify the password..
;  DS:DI = ptr to buffer of installed encoded password..
;  DS:SI = prt to buffer of entered ASCIIZ password..
;  CX = length of password..
	mov	bl,80h			; start seed
vp_03:
	lodsb				; get next byte of entered password ASCII char
	call	ascii_to_scan		; AL = scan code
	call	get_bl_al		; BL = encoded value
	inc	di
	cmp	bl,[di-1]
	loopz	vp_03
vp_01:
	popa
	mov	al,00h
	jz	vp_02			; ok
	not	al
vp_02:
	ret
verify_password	endp
;---------------------------------------;
;	Set_Password			;
; Input :				;
;	al	0..supervisor password	;
;		1..user password	;
;	ds:bx   ptr to asciiz password 	;
;		string			;
;---------------------------------------;
set_password	proc	near
	push	es
	pusha
	mov	si,bx			; DS:SI = ptr to source buffer
	push	ds
	pop	es
	mov	di,offset _common_cmos_buffer+38h; ES:DI = ptr to destn buffer
					; of supervisor password
	or	al,al
	jz	sp_00
	mov	di,offset _common_cmos_buffer+4ch; ES:DI = ptr to destn buffer
					; of user password
sp_00:
	mov	cx,06h			; maxm length of password
	mov	bl,80h			; start seed
sp_03:
	lodsb				; get next ascii char
	or	al,al
	jz	sp_01			; end of password
	call	ascii_to_scan
	call	get_bl_al		; BL = encoded value
	mov	al,bl
sp_01:
	stosb
	or	al,al
	loopnz	sp_03
sp_02:
	popa
	pop	es
	ret
set_password	endp
;---------------------------------------;
;	ASCII_TO_SCAN			;
;  this routine returns the scan code of;
;  the given ascii code.		;
;  input :				;
;	al	ascii code		;
;  output:				;
;	al	scan code		;
;  register destroyed..AX		;
;---------------------------------------;
	public	ascii_to_scan
ascii_to_scan:
;  AL = ASCII code..convert it to lower case ascii if alphabet..
	cmp	al,'A'
	jb	epp_03			; not alpha
	cmp	al,'Z'
	ja	epp_03			; not alpha
	add	al,20h			; lower case ascii code
epp_03:
;  get scan code from ASCII..
	push	cx
	push	si
	mov	cx,80h
	mov	ah,al			; AH = ascii
	mov	si,offset cgroup:base_tbl; table in INT-9.ASM
epp_02:
	db	2eh
	lodsb				; get next ascii from table
	cmp	al,ah			; match ?
	loopnz	epp_02			; continue till end
	sub	cx,80h
	neg	cx
	mov	al,cl
	pop	si
	pop	cx
	ret
;---------------------------------------;
;	STANDARD_SETUP_INIT		;
; this routine is called from		;
; _FILL_CMOS_BUFFER routine		;
;---------------------------------------;
	public	standard_setup_init
standard_setup_init	proc	near
	cli
	mov	ax,268ah		; initialize status A register
	call	cmos_data_out
	mov	ax,8b8bh		; status register B
	call	cmos_data_in
	and	al,00000001b		; day light saving bit
	or	al,00000010b
	xchg	al,ah			; initialize status B register
	call	cmos_data_out
	mov	al,8dh			; initialize status D register
	call	cmos_data_in
	mov	al,8ch			; initialize status C register
	call	cmos_data_in
	sti
;---------------------------------------;
;	READ/WRITE CURRENT DATE		;
;---------------------------------------;
	call	read_date
	mov	ah,05h			; set current date
	int	1ah
;---------------------------------------;
;	READ/WRITE CURRENT TIME		;
;---------------------------------------;
	call	read_time
	mov	ah,03h			; set current time
	int	1ah
;---------------------------------------;
;	SET IPL BIT, RESERVED BITS	;
;---------------------------------------;
	mov	bx,offset _common_cmos_buffer
	or	byte ptr [bx+equipment],00000001b
;---------------------------------------;
;	BASE MEMORY ADJUST		;
;---------------------------------------;
	push	ds
	xor	ax,ax
	mov	ds,ax
	mov	ax,ds:[413h]
	cmp	ds:byte ptr [0472h],'H'	; hot key setup ?
	pop	ds
	jz	skip_adjust
	mov	[bx+base_mem_low],ax	; store base memory size
;---------------------------------------;
;	EXTD MEMORY ADJUST		;
;---------------------------------------;
	cli
	mov	ax,3031h		; low_ext_mem_addr*256+high_ext_mem_addr
	call	read_cmos_word		; read extd memory
	mov	[bx+expn_mem_low],ax	; store extd. memory size
	mov	ax,3536h		; low_ext_mem_64_addr*256+high_ext_mem_64_addr
	call	read_cmos_word		; read extd memory
	mov	[bx+expn_mem_low_64],ax	; store extd. memory size (unit 64k)
	sti
skip_adjust:
;---------------------------------------;
;	DISPLAY TYPE SETTING		;
;---------------------------------------;
	test	byte ptr [bx+equipment],00111000b; display installed ?
	jz	vdo_3
	push	ds
	xor	ax,ax
	mov	ds,ax
	int	11h			; display info from equipment byte
	cmp	ds:word ptr [42h],0c800h; INT-10 segment
	jb	vdo_1			; EGA/VGA at C000 - C800
	cmp	ds:word ptr [42h],0e000h; INT-10 segment
	jb	vdo_2			; not EGA/VGA
	cmp	ds:word ptr [42h],0f000h; INT-10 segment
	jae	vdo_2			; video ROM absent
vdo_1:
	mov	al,00000000b
vdo_2:
	pop	ds
	and	al,00110000b		; display type
	or	al,00001000b		; make display installed
	and	byte ptr [bx+equipment],11001111b
	or	[bx+equipment],al
vdo_3:
	ret
standard_setup_init	endp
;---------------------------------------;
;	READ DATE ROUTINE		;
;---------------------------------------;
	public	read_date
read_date:
	mov	ah,04h
	int	1ah			; read date
	jnb	cal_1_x			; (dh) = month
	mov	ah,04h			; (dl) = day
	int	1ah			; (cx) = year
cal_1_x:
	mov	ax,cx
	call	check_bcd
	jnb	cal_1			; error
	cmp	ax,1901h
	jb	cal_1			; error
	cmp	ax,2099h
	ja	cal_1			; error
	mov	ax,dx
	call	check_bcd
	jnb	cal_1			; error
	or	al,al
	jz	cal_1			; error
	or	ah,ah
	jz	cal_1			; error
	cmp	ah,12h
	ja	cal_1			; error
	cmp	al,31h
	jbe	cal_2
cal_1:
%out === Modify default year/date here ===
	mov	cx,1999h		; 1980h		08/06/96
	mov	dx,0301h
cal_2:
	ret
;---------------------------------------;
;	READ TIME ROUTINE		;
;---------------------------------------;
	public	read_time
read_time:
	mov	ah,02h
	int	1ah
	jnb	time_0			; (ch) = HH
	mov	ah,02h			; (cl) = MM
	int	1ah			; (dh) = SS
time_0:
	mov	ax,cx
	call	check_bcd
	jnb	time_1			; error
	cmp	ah,23h
	ja	time_1			; error
	cmp	al,59h
	ja	time_1			; error
	mov	al,dh
	call	check_bcd
	jnb	time_1			; error
	cmp	al,59h
	jbe	time_2
time_1:
	xor	cx,cx			; time = 00:00:00
	xor	dx,dx
time_2:
	ret
;---------------------------------------;
;	CHECK BCD NUMBERS OF DATE/TIME	;
;---------------------------------------;
check_bcd:
	push	ax
	and	ax,0f0fh
	cmp	al,0ah
	jae	bcd_exit
	cmp	ah,0ah
	jae	bcd_exit
	pop	ax
	push	ax
	and	ax,0f0f0h
	cmp	al,0a0h
	jae	bcd_exit
	cmp	ah,0a0h
bcd_exit:
	pop	ax
	ret
;---------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
_text	ends
END
