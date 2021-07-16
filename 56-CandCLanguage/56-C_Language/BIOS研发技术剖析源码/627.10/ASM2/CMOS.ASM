 	page	50,130
	title	CMOS.ASM
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
include	ramdata.inc
;-----------------------------------------------------------------------------
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup,ds:fgroup
.386p
;---------------------------------------;
	public	_CMOS_STARTS
_CMOS_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------------
	include	mbiosequ.equ
	include	mbiosmac.mac
	include	cf.equ
;=======================================================================;
;	COMMON ROUTINES FOR ALL BIOS					;
;=======================================================================;
public	@fill_cmos_buffers		; called before setup screen display
public	@load_adv_cmos_chipset_values	; called for loading adv cmos & chipset values
public	@load_adv_cmos_values		; called for loading adv cmos values
public	@load_chipset_values		; called for loading chipset values
public	@load_pwr_mgmt_values		; called for loading pwr mgmt values
public	@load_peripheral_values		; called for loading peripheral values
; $$$CORE0027+ >>>
public	@load_plus_values		; called for loading plus values
; $$$CORE0027+ <<<
public	_pFuncLoadVal
public	get_std_reboot_status		; (zf) = 0/1, reboot/no reboot
public	get_hk_reboot_status		; (zf) = 0/1, reboot/no reboot
;------------------------------------------------------------------------------
extrn	check_cmos_8e:near		; check cmos bad/good (NZ/ZR)
extrn	cmos_data_in_x:near		; read cmos data
extrn	cmos_data_out_x:near		; write cmos data
extrn	get_cmos_reg_mask_x:near

extrn	init_buffer_adv_optimal:near
extrn	init_buffer_chipset_optimal:near
extrn	init_buffer_power_optimal:near
extrn	init_buffer_pci_optimal:near
extern	init_buffer_prf_optimal(dummy_ret):near
extern	init_buffer_plus_optimal(dummy_ret):near	; $$$CORE0027+
extrn	init_buffer_adv_fail_safe:near
extrn	init_buffer_chipset_fail_safe:near
extrn	init_buffer_power_fail_safe:near
extrn	init_buffer_pci_fail_safe:near
extern	init_buffer_prf_fail_safe(dummy_ret):near
extern	init_buffer_plus_fail_safe(dummy_ret):near	; $$$CORE0027+
extrn	dummy_ret:near

extrn	standard_setup_init:near	; (CS.ASM) memory size, etc.
extrn	init_buffer_before_setup:near	; do any change in _common_cmos_buffer

extrn	default_cmos_0e_0f:byte		; ROM table
extrn	_default_cmos_10_3f:byte	; ROM table
extrn	cmos_table:word			; start of strucs for cmos registers.
extrn	cmos_table_end:word		; end of strucs for cmos registers.
extrn	advanced_table:word		; start of strucs for adv. cmos regs
extrn	advanced_table_end:word		; end of strucs for adv. cmos regs
extrn	chipset_table:word		; start of strucs for adv. chipset regs
extrn	chipset_table_end:word		; end of strucs for adv. chipset regs
extrn	pwr_mgmt_table:word		; start of strucs for pwr mgmt regs
extrn	pwr_mgmt_table_end:word		; end of strucs for pwr mgmt regs
extrn	pci_table:word			; start of strucs for pci regs
extrn	pci_table_end:word		; end of strucs for pci regs
extrn	peripheral_table:word		; start of table for peripheral
extrn	peripheral_table_end:word	; end of table for peripheral
; $$$CORE0027+ >>>
extern	plus_table(dummy_ret):word		; start of strucs for CPU CFG regs
extern	plus_table_end(dummy_ret):word		; end of strucs for CPU CFG regs
; $$$CORE0027+ <<<
;---------------------------------------;
extrn	num_advanced_cmos_regs:word	; cmos regs for adv. cmos setup.
extrn	num_chipset_regs:word		; cmos regs for adv. chipset setup.
extrn	num_pwr_mgmt_regs:word		; cmos regs for pwr mgmt setup.
extrn	num_pci_regs:word		; cmos regs for pwr mgmt setup.
extrn	num_peripheral_regs:word	; number of peripherals
; $$$CORE0027+ >>>
extern	num_plus_regs(dummy_ret):word	; cmos regs for CPU CFG setup.
; $$$CORE0027+ <<<
extrn	total_cmos_regs:word		; total cmos registers for adv. setup.
extrn	_last_cmos_register:word	; last register for calculating chk sum
;---------------------------------------;
	ifndef NO_SWAP
extrn	q_floppy_swap:abs
	endif
extrn	detected_cpu_vendor:byte
;extrn	_ccp_vendor_support:byte
; $$$CORE0049- >>>
;extrn	cpu_selection_table:byte
;extrn	cpu_selection_table_end:byte
; $$$CORE0049- <<<
;---------------------------------------;
;-----------------------------------------------------------------------;
cmos_data_struc	struc
	cmos_reg_number	db	(?)
	reg_mask	db	(?)
	best_reg_def	db	(?)
	poweron_reg_def	db	(?)
	std_reboot_mask	db	(?)
	hk_reboot_mask	db	(?)
cmos_data_struc	ends

adv_struc_fixed_part	struc
	string_no	db	(?)	; Question String #
	cmos_reg	db	(?)	; Cmos register number.
					; if bit-7 = 1 then option is  present
					; else option is absent.
	mask_value	db	(?)	; Mask to be used to acess the value from cmos register.
	info_byte	db	(?)	; Information about variablr part of structure
adv_struc_fixed_part	ends

msb_mask			equ	80h
;-----------------------------------------------------------------------;
;	@FILL_CMOS_BUFFERS						;
;-----------------------------------------------------------------------;
; If cmos is good, this function reads the cmos & initialise the buffer	;
; If cmos is bad, this function will fill the buffer with default values;
; This routine will be called always before SETUP menu is displayed.	;
; The common cmos buffer is copied into the old cmos buffer		;
;-----------------------------------------------------------------------;

@fill_cmos_buffers	proc	near
	cli
	push	si
	push	di
	push	ds			; (ds) = (es)
	pop	es
	mov	di,offset _common_cmos_buffer + 10h	; Init Di.
	call	check_cmos_8e
	jnz	fcb_2			; Cmos bad, put def. values.
	mov	cx,cs:_last_cmos_register; No. of regs. <<<<
	sub	cx,8fh
	mov	al,90h			; Get 1st CMOS reg number.
fcb_1:
	push	ax			; Save value of Ax.
	call	cmos_data_in_x		; Read from the CMOS.
	stosb				; Store the value in ES:DI.
	pop	ax			; Restore value of Ax.
	inc	al			; Increment value of Al.
	loop	fcb_1			; Read the next CMOS register.
	jmp	short fcb_3
fcb_2:
;-----------------------------------------------------------------------;
; This part is required for standard cmos setup.
;-----------------------------------------------------------------------;
	mov	cx,30h			; No. of regs.
	mov	si,offset cgroup:_default_cmos_10_3f; get data from ROM table
; di is already initialized to offset _common_cmos_buffer + 10h
	rep	movs	byte ptr [di],cs:[si]

;-----------------------------------------------------------------------;
; This part is required for advanced cmos setup.
;-----------------------------------------------------------------------;
	mov	al,1
	call	@load_adv_cmos_chipset_values	; put adv cmos, chipset & pwr defaults
	mov	al,1
	call	@load_pwr_mgmt_values		; put power mgmt defaults
	mov	al,1
	call	@load_peripheral_values		; put peripheral defaults
;-----------------------------------------------------------------------;
; If you have no extended cmos and chipset registers, then the previous	;
; call should be as follows :						;
;	call	@load_adv_cmos_values					;
;-----------------------------------------------------------------------;
fcb_3:
	call	standard_setup_init	; init memory,display,floppy etc..
	call	init_buffer_before_setup ; do any change in _common_cmos_buffer
ifndef NO_SWAP
;  floppy swap..
	mov	al,q_floppy_swap
	call	get_cmos_reg_mask_x	; AH = mask, AL bit6-0 = cmos register
	and	al,7fh
	movzx	si,al
	test	ds:byte ptr _common_cmos_buffer[si],ah; swap enabled ?
	mov	al,ds:byte ptr _common_cmos_buffer[10h]; bit7-4 = drive A:, bit3-0 = drive B:
	jz	fab_com_2		; swap disabled
	ror	al,04h
	mov	ds:byte ptr _common_cmos_buffer[10h],al; bit7-4 = drive A:, bit3-0 = drive B:
fab_com_2:
endif;	ifndef NO_SWAP
;---------------------------------------;
;  update cmos buffer for auto/cdrom for primary master
	mov	al,ds:byte ptr _common_cmos_buffer[2ah]
	shr	al,06h
	jz	hdd_c_0
;;;;	cmp	al,03h			; 3 is now for AFD
;;;;	jz	hdd_c_0
	add	al,47
	mov	ds:byte ptr _common_cmos_buffer[19h],al
hdd_c_0:
	cmp	ds:byte ptr _common_cmos_buffer[19h],30h
	jb	hdd_c_1
	or	ds:byte ptr _common_cmos_buffer[12h],0f0h
hdd_c_1:
;  update cmos buffer for auto/cdrom for primary slave
	mov	al,ds:byte ptr _common_cmos_buffer[2bh]
	shr	al,06h
	jz	hdd_d_0
;;;;	cmp	al,03h			; 3 is now for AFD
;;;;	jz	hdd_d_0
	add	al,47
	mov	ds:byte ptr _common_cmos_buffer[1ah],al
hdd_d_0:
	cmp	ds:byte ptr _common_cmos_buffer[1ah],30h
	jb	hdd_d_1
	or	ds:byte ptr _common_cmos_buffer[12h],0fh
hdd_d_1:
;  update cmos buffer for auto/cdrom for secondary master
	mov	al,ds:byte ptr _common_cmos_buffer[2ch]
	shr	al,06h
	jz	hdd_e_0
;;;;	cmp	al,03h			; 3 is now for AFD
;;;;	jz	hdd_e_0
	add	al,47
	mov	ds:byte ptr _common_cmos_buffer[27h],al
hdd_e_0:
;  update cmos buffer for auto/cdrom for secondary slave
	mov	al,ds:byte ptr _common_cmos_buffer[2dh]
	shr	al,06h
	jz	hdd_f_0
;;;;	cmp	al,03h			; 3 is now for AFD
;;;;	jz	hdd_f_0
	add	al,47
	mov	ds:byte ptr _common_cmos_buffer[28h],al
hdd_f_0:
;---------------------------------------;
;  copy to old cmos buffer..
	mov	si,offset _common_cmos_buffer; ptr to common cmos buffer
	mov	di,offset _old_cmos_buffer	; update _old_cmos_buffer
	mov	cx,80h
	rep	movsb
;  adjust cpu selection in common cmos buffer..
; $$$CORE0049- >>>
;	call	adjust_cpu_selection		; adjust cpu selection
; $$$CORE0049- <<<
	pop	di
	pop	si
	sti
	ret
@fill_cmos_buffers	endp
; $$$CORE0049- >>>
; $$$CORE0049- <<<
;-----------------------------------------------------------------------;
_pFuncLoadVal	label	near
	dw	offset cgroup:@load_adv_cmos_values
	dw	offset cgroup:@load_chipset_values
	dw	offset cgroup:@load_pwr_mgmt_values
	dw	offset cgroup:@load_pci_values
	dw	offset cgroup:@load_peripheral_values
	dw	offset cgroup:@load_plus_values	; $$$CORE0027+
;-----------------------------------------------------------------------;
optimal_table	label	near
	dw	offset cgroup:init_buffer_adv_optimal
	dw	offset cgroup:init_buffer_chipset_optimal
	dw	offset cgroup:init_buffer_power_optimal
	dw	offset cgroup:init_buffer_pci_optimal
	dw	offset cgroup:init_buffer_prf_optimal
	dw	offset cgroup:init_buffer_plus_optimal	; $$$CORE0027+
;-----------------------------------------------------------------------;
fail_safe_table	label	near
	dw	offset cgroup:init_buffer_adv_fail_safe
	dw	offset cgroup:init_buffer_chipset_fail_safe
	dw	offset cgroup:init_buffer_power_fail_safe
	dw	offset cgroup:init_buffer_pci_fail_safe
	dw	offset cgroup:init_buffer_prf_fail_safe
	dw	offset cgroup:init_buffer_plus_fail_safe; $$$CORE0027+
;-----------------------------------------------------------------------;
;			@LOAD_ADV_CMOS_CHIPSET_VALUES			;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for advanced cmos and	;
; advanced chipset setup. The values are written into the		;
; _common_cmos_buffer. Depending on the value of Al, the values are	;
; read from the following place.					;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
@load_adv_cmos_chipset_values	proc	near
;;	call	@load_standard_values		; (CORE0229+) MUST load first
	push	ax
	call	@load_adv_cmos_values
	pop	ax
	push	ax
	call	@load_pwr_mgmt_values
	pop	ax
	push	ax
	call	@load_pci_values
	pop	ax
	push	ax
	call	@load_peripheral_values
	pop	ax
; $$$CORE0027+ >>>
	push	ax
	call	@load_plus_values
	pop	ax
; $$$CORE0027+ <<<
;-----------------------------------------------------------------------;
;			@LOAD_CHIPSET_VALUES				;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for chipset setup.	;
; The values are written into the _common_cmos_buffer.			;
; Depending on the value of Al, the values are read from the foll. place;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
@load_chipset_values	proc	near
	push	si
	mov	cx,cs:num_chipset_regs		; set count.
	mov	si,offset chipset_table		; get starting offset.
	mov	ah,1				; indicate chipset
	jmp	short	pacv_1
@load_chipset_values	endp
@load_adv_cmos_chipset_values	endp
;-----------------------------------------------------------------------;
;			@LOAD_PWR_MGMT_VALUES				;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for power mgmt setup.	;
; The values are written into the _common_cmos_buffer.			;
; Depending on the value of Al, the values are read from the foll. place;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
@load_pwr_mgmt_values	proc	near
	push	si
	mov	cx,cs:num_pwr_mgmt_regs		; set count.
	mov	si,offset pwr_mgmt_table	; get starting offset.
	mov	ah,2				; indicate power mgmt
	jmp	short	pacv_1
@load_pwr_mgmt_values	endp
;-----------------------------------------------------------------------;
;			@LOAD_PCI_VALUES				;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for power mgmt setup.	;
; The values are written into the _common_cmos_buffer.			;
; Depending on the value of Al, the values are read from the foll. place;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
@load_pci_values	proc	near
	push	si
	mov	cx,cs:num_pci_regs		; set count.
	mov	si,offset pci_table		; get starting offset.
	mov	ah,3				; indicate pci
	jmp	short	pacv_1
@load_pci_values	endp
;-----------------------------------------------------------------------;
;			@LOAD_PERIPHERAL_VALUES				;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for peripheral setup.	;
; The values are written into the _common_cmos_buffer.			;
; Depending on the value of Al, the values are read from the foll. place;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
@load_peripheral_values	proc	near
	push	si
	mov	cx,cs:num_peripheral_regs	; set count.
	mov	si,offset peripheral_table	; get starting offset.
	mov	ah,4				; indicate peripheral
	jmp	short	pacv_1
@load_peripheral_values	endp
; $$$CORE0027+ >>>
;-----------------------------------------------------------------------;
;			@LOAD_PLUS_VALUES				;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for icon setup.		;
; The values are written into the _common_cmos_buffer.			;
; Depending on the value of Al, the values are read from the foll. place;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
						; (CORE0219)>
	extrn	str_end:abs
	extern	load_plus_default(str_end):abs
@load_plus_values	proc	near
	push	ax
	mov	ax,offset plus_table
	cmp	ax,offset dummy_ret		; plus_table = dummy ret ?
	je	lev_01				; yes.. not present
	mov	al,load_plus_default
	or	al,al				; NZ = load default
lev_01:
	pop	ax
	jz	lev_exit
						; <(CORE0219)
	push	si
	mov	cx,cs:num_plus_regs		; set count.
	mov	si,offset plus_table		; get starting offset.
	mov	ah,5				; indicate PLUS
	jmp	short	pacv_1
lev_exit:
	ret
@load_plus_values	endp
; $$$CORE0027+ <<<
;-----------------------------------------------------------------------;
;			@LOAD_ADV_CMOS_VALUES				;
;-----------------------------------------------------------------------;
; Fill the _common_cmos_buffer with the values for advanced cmos setup.	;
; The values are written into the _common_cmos_buffer.			;
; Depending on the value of Al, the values are read from the foll. place;
; Al=0 : Read the values from the _old_cmos_buffer			;
; Al=1 : Read the values from the best default value in the structure	;
; Al=2 : Read the values from the poweron default value in the structure;
;-----------------------------------------------------------------------;
@load_adv_cmos_values	proc	near
	push	si
	mov	cx,cs:num_advanced_cmos_regs	; set count.
	mov	si,offset advanced_table	; get starting offset.
	sub	ah,ah				; indicate advanced
pacv_1::
	jcxz	pacv_4
	xor	bh,bh
pacv_2 :
	push	ax
	mov	bl,cs:(cmos_data_struc ptr [si]).cmos_reg_number; get register number.
	dec	al		; Al=0 : Sign flag set. Al=1 : Zero flag set.
	mov	al,ds:_old_cmos_buffer[bx]	; get old value
	js	pacv_3				; flags were not altered.
	mov	al,cs:(cmos_data_struc ptr [si]).best_reg_def; get best default value.
	jz	pacv_3				; flags were not altered.
	mov	al,cs:(cmos_data_struc ptr [si]).poweron_reg_def; get poweron default value.
pacv_3 :
	mov	dl,cs:(cmos_data_struc ptr [si]).reg_mask; get mask
	and	al,dl				; mask off other bits.
	not	dl				; get not(mask)
	and	ds:_common_cmos_buffer[bx],dl	; update value
	or	ds:_common_cmos_buffer[bx],al	; in buffer
	add	si,type cmos_data_struc		; go to next structure.
	pop	ax
	loop	pacv_2
pacv_4:
	or	al,al
	jz	pacv_5
	mov	si,offset optimal_table
	cmp	al,1
	jz	pacv_6
	mov	si,offset fail_safe_table
pacv_6:
	shr	ax,8
	shl	ax,1
	add	si,ax
	call	cgroup:word ptr [si]
pacv_5:
	pop	si
; $$$CORE0049- >>>
;	call	adjust_cpu_selection		; adjust cpu selection
; $$$CORE0049- <<<
	ret
@load_adv_cmos_values	endp
;-----------------------------------------------------------------------;
;			GET_STD_REBOOT_STATUS				;
; This function determines if rebooting is necessary by comparing 	;
; _old_cmos_buffer and _common_cmos_buffer and the standard reboot mask	;
; for all cmos registers after running setup normally.			;
; Input	: NONE								;
; Output: NZ = rebooting necessary					;
;	  ZR = rebooting not necessary					;
; Register destroyed..AX BX CX SI DI					;
;-----------------------------------------------------------------------;
get_std_reboot_status	proc	near
	call	check_cmos_8e		; cmos good/bad ?
	jz	gsrs_00			; good
	ret				; NZ..reboot
gsrs_00:
;;;;	mov	di,offset std_reboot_mask; normal reboot mask
	mov	di,04h			; normal reboot mask
	jmp	short get_reboot_status
get_std_reboot_status	endp
;-----------------------------------------------------------------------;
;			GET_HK_REBOOT_STATUS				;
; This function determines if rebooting is necessary by comparing 	;
; _old_cmos_buffer and _common_cmos_buffer and the hot key reboot mask	;
; for all cmos registers after running hot-key setup.			;
; Input	: NONE								;
; Output: NZ = rebooting necessary					;
;	  ZR = rebooting not necessary					;
; Register destroyed..AX BX CX SI DI					;
;-----------------------------------------------------------------------;
get_hk_reboot_status	proc	near
;;;;	mov	di,(cmos_data_struc ptr) offset hk_reboot_mask; hot key reboot mask
	mov	di,05h			; hot key reboot mask
;;;;	jmp	short get_reboot_status
get_hk_reboot_status	endp
;-----------------------------------------------------------------------;
;			GET_REBOOT_STATUS				;
; This function determines if rebooting is necessary by comparing 	;
; _old_cmos_buffer and _common_cmos_buffer and the reboot mask for all	;
; cmos registers.							;
; Input	: DI = offset of reboot mask					;
; Output: NZ = rebooting necessary					;
;	  ZR = rebooting not necessary					;
; Register destroyed..AX BX CX SI					;
;-----------------------------------------------------------------------;
get_reboot_status	proc	near
	mov	si,offset advanced_table	; get advanced table offset
	mov	cx,cs:total_cmos_regs		; set count.
	call	check_reboot_status		; check advanced table
	ret
get_reboot_status	endp
;-----------------------------------------------------------------------;
;			CHECK_REBOOT_STATUS				;
; This function determines if rebooting is necessary by comparing 	;
; _old_cmos_buffer and _common_cmos_buffer and the reboot mask for all	;
; cmos registers in a particular table.					;
; Input : SI = table offset						;
;	  CX = table size						;
; 	  DI = offset of rebbot mask					;
; Output: NZ = rebooting necessary					;
;	  ZR = rebooting not necessary					;
; Register destroyed..AX BX CX SI					;
;-----------------------------------------------------------------------;
check_reboot_status	proc	near
	or	cx,cx				; Don't use JCXZ..
						; JCXZ does not alter Z-flag
	jz	crs2				; no entry..so no reboot needed
crs1:
	xor	bh,bh				; BH = 00
	mov	bl,cs:[si]			; get register #
	mov	al,_common_cmos_buffer[bx]	; get current value
	xor	al,_old_cmos_buffer[bx]		; get difference with old value
	mov	bx,di
	mov	ah,cs:[si+bx]			; get mask
	add	si,size cmos_data_struc		; else get next register
	and	al,ah
	loopz	crs1
crs2:
	ret
check_reboot_status	endp
					; (CORE0229+)>
					; <(CORE0229+)
;---------------------------------------;
	public	_CMOS_ENDS
_CMOS_ENDS	label	byte		; size of module
;---------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
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
	end
