;*****************************************************************;
;-----------------------------------------------------------------------;
	include mbiosmac.mac
	include makeflag.equ
;-----------------------------------------------------------------------;
	extrn	check_p6:near
	extrn	go_to_flat_mode_stack:near
	extrn	comeback_from_flat_mode_stack:near
	extrn	flash_write_enable:near
	extrn	flash_write_disable:near
	extrn	read_sio_byte:near
	extrn	write_sio_byte:near
	extrn	e000_read_rom_write_x:near
	extrn	flash_found_table:byte
	extrn	update_blocks:word
;---------------------------------------;
cgroup	group	_text
_text	segment word	public	'CODE'
	assume	cs:cgroup
.586p
;-----------------------------------------------------------------------;
;	BIOS Update Feature for Pentium Pro (P6) Processor		;
;-----------------------------------------------------------------------;
;  The specification as described in Pentium Pro Processor BIOS Writer's;
;  Guide Version 2.0 January, 1996 is implemented.			;
;-----------------------------------------------------------------------;
;  return codes
success 		equ	00h
not_implemented 	equ	86h
erase_failure		equ	90h
write_failure		equ	91h
read_failure		equ	92h
storage_full		equ	93h
cpu_not_present 	equ	94h
invalid_header		equ	95h
invalid_header_cs	equ	96h
security_failure	equ	97h
invalid_revision	equ	98h
update_num_invalid	equ	99h
;  other equates
block_length		equ	2048
header_version		equ	00000001h
loader_revision 	equ	00000001h

extern	micro_code_start_addr:dword

;-----------------------------------------------------------------------;
UpdateHeaderStruc	struc
	HeaderVersion		dd	?	; update header version#
	UpdateRevision		dd	?	; update version#
	Date			dd	?	; update date in binary
						; 07/18/95 as 0x07181995
	Processor		dd	?	; type, family,model,stepping of CPU
	Checksum		dd	?	; checksum
	LoaderRevision		dd	?	; update loader version#
	Reserved		db	24 dup(?); 24 bytes reserved
UpdateHeaderStruc	ends
;-----------------------------------------------------------------------;
;			INT-15.ASM					;
; this routine is called from INT-15 ISR to support any special int-15	;
; function if any. if you do not have any special func, simply return	;
; control to INT-15 ISR by RET. otherwise balance stack and return	;
; control to caller of INT-15 by IRET or RET 2. 			;
; here is how INT-15 code will look like.				;
;int_15 proc	far							;
;	cmp	ah,87h							;
;	jz	int_15_87						;
;	call	special_int_15						;
;	...								;
;int_15_87:								;
;	...								;
;int_15 endp								;
;=======================================================================;
; EXAMPLE:  INT15 function to GATE-A20 support. 			;
;	    input :	(ah)	24h					;
;			(al)	03h					;
;	    output:	(ah)	return code				;
;				00h  successful 			;
;				86h  function not supported		;
;			(NC)	successful				;
;			(CY)	unsuccessful				;
;			if successful					;
;			(bx)	bit 0..0 = GateA20 not supported on 8042;
;				       1 = GateA20 supported on 8042	;
;				bit 1..0 = GateA20 not supported with	;
;					   bit-1 of I/O port 92H	;
;				       1 = GateA20 supported with bit-1 ;
;					   of I/O port 92H		;
; Let us assume the chipset concerned has the support for GateA20 thru' ;
; bit-1 of I/O port 92H. In this case SPECIAL_INT_15 shoule be like as	;
; follows:								;
;									;
; special_int_15:							;
;	cmp	ah,24h			; func# 24h ?			;
;	jnz	si15_00 		; no..				;
;	cmp	al,03h			; subfunc# 03h ?		;
;	jnz	si15_00 		; no..				;
;	POP	BX			; ===VERY VERY IMPORTANT===	;
;					; discard return address	;
;	mov	bx,02h			; bit 1 = 1..GateA20 thru' bit-1;
;					; of I/O port 92H		;
;	sti				; enable interrupt		;
;	xor	ah,ah			; AH = 00..successful		;
;					; NC..successful		;
; x??	proc	far							;
;	ret	0002							;
; x??	endp								;
;									;
; si15_00:								;
;	ret								;
;-----------------------------------------------------------------------;
;				SPECIAL_INT_15				;
;-----------------------------------------------------------------------;
;  input :								;
;	none								;
;	stack	available						;
;  register usage : do not destroy any register 			;
;-----------------------------------------------------------------------;
	public	check_bu		; special int 15 func if any
check_bu:
	cmp	ax,0d042h		; BU function ?
	jz	bu_00			; yes
bu_02:
	ret
;-----------------------------------------------------------------------;
;		PROCESSOR SPECIFIC UPDATE FUNCTIONS			;
;-----------------------------------------------------------------------;
bu_00:
	call	check_p6		; check for P6 presence
	jnz	bu_02			; P6 absent
	add	sp,0002h		; discard return address
	mov	ah,not_implemented
	cmp	bl,(offset cgroup:bu_func_table_end-offset cgroup:bu_func_table)/2
	jae	bu_01			; invalid subfunc
	push	bx
;	movzx	bx,bl
	xor	bh,bh
	shl	bx,1
	mov	ax,cgroup:word ptr [bu_func_table+bx]
	pop	bx
	call	ax
bu_01:
	mov	al,00h			; AL = 00 additional OEM info
	cmp	ah,01h
	cmc				; status in return carry flag
	sti
	retf	0002
;-----------------------------------------------------------------------;
;				BU_FUNC_TABLE				;
;-----------------------------------------------------------------------;
bu_func_table		label	byte
	dw	offset cgroup:bl_00		; subfunc 00h
	dw	offset cgroup:bl_01		; subfunc 01h
	dw	offset cgroup:bl_02		; subfunc 02h
	dw	offset cgroup:bl_03		; subfunc 03h
bu_func_table_end	label	byte
;-----------------------------------------------------------------------;
;			PRESENCE TEST					;
; this function verifies that BIOS has implemented the required BIOS	;
; update functions.							;
; input :								;
;	AX	D042							;
;	BL	00							;
; output:								;
;	CF	return status						;
;		NC = success						;
;		CY = error						;
;	AH	return code						;
;	AL	additional OEM information				;
;	EBX	Signature Part-1 ('INTE')				;
;	ECX	Signature Part-2 ('LPEP')				;
;	EDX	Version# of BIOS update loader				;
;	SI	Update count (1-based) indicating #of update blocks	;
;		system can record in NVRAM				;
;-----------------------------------------------------------------------;
bl_00:
	mov	ebx,'INTE'		; signature part-1
	mov	ecx,'LPEP'		; signature part-2
	mov	edx,loader_revision	; version# 1
	mov	si,cgroup:update_blocks ; #of update blocks (each of 2KBytes
					; length) available in NVRAM
	mov	ah,success		; return code
	ret
;-----------------------------------------------------------------------;
;			WRITE BIOS UPDATE DATA				;
; this function integrates a new BIOS update into the BIOS storage area.;
; input :								;
;	AX	D042							;
;	BL	01							;
;	ES:DI	Real Mode Pointer to the Intel Update structure 	;
;		this buffer is 2048 bytes in length			;
;	CX	Scratch Pad1 (Real Mode Scratch segment 64K in length)	;
;	DX	Scratch Pad2 (Real Mode Scratch segment 64K in length)	;
;	SI	Scratch Pad3 (Real Mode Scratch segment 64K in length)	;
;	SS:SP	Stack (32K minimum)					;
; output:								;
;	CF	return status						;
;		NC = success						;
;		CY = error						;
;	AH	return code						;
;	AL	additional OEM information				;
;-----------------------------------------------------------------------;
bl_01:
	push	es
	push	ds
	push	di
	push	si

	push	es
	pop	ds
	xchg	si,di			; DS:SI = ptr to update structure
					; DI = scratch pad3
	mov	ah,invalid_header	; errro code
;  check header version
	cmp	(UpdateHeaderStruc ptr ds:[si]).HeaderVersion,header_version
	jnz	bl01_00 		; header version error
;  check loader revision
	cmp	(UpdateHeaderStruc ptr ds:[si]).LoaderRevision,loader_revision
	jnz	bl01_00 		; loader revision error
;  verify the update structure checksum
	mov	ah,invalid_header_cs	; errro code
	pushad
	mov	cx,block_length/4	; CX = block length in unit of DWORD
	xor	ebx,ebx
bl01_01:
	lods	ds:dword ptr [si]
	add	ebx,eax
	loop	bl01_01
	popad
	jnz	bl01_00 		; error, invalid checksum
;  read 128K flash containing microcode in scratch buffer..
	push	es
	pushad
	mov	es,cx			; use scratch pad1 for read 1st 64k
	xor	di,di			; ES:DI = pointer to read buffer
	xor	cx,cx			; #of bytes to read (=0000, 64k)
	mov	esi,cgroup:micro_code_start_addr
	and	esi,0ffff0000h		; read from 1st 64k flash
	push	esi
	call	read_bytes		; read to scratch pad1
	mov	es,dx			; use scratch pad2 for read 2nd 48k
	xor	di,di			; ES:DI = pointer to read buffer
	xor	cx,cx			; 64k
	pop	esi
	add	esi,10000h		; read from 2nd 64k flash in case of the micore module cross the 64k flash boundary
	call	read_bytes		; read to scratch pad2
	popad
	pop	es
;  128K flash is read at scratch pad1:0000, 64K
;		      at scratch pad2:0000, 64K
;  check the validity of update..
;  DS:SI = Pointer to update (source) buffer

;  search for any existing update block having the same processor signature
;  as in supplied update data
	push	es
	pushad

	mov	es,cx			; ES = scratch pad1
	mov	bp,dx			; BP = scratch pad2
	xor	ebx,ebx 		; EBX bit31-16 = segment of 1st empty block
					;     bit15-0  = offset  of 1st empty block
					; EBX = 0000 => no empty block found
	mov	eax,cgroup:micro_code_start_addr
	and	eax,0000ffffh		; keep offset in scratch pad1
	mov	di,ax			; di = micro code start offset in scratch pad1 (1st flash)
	mov	eax,(UpdateHeaderStruc ptr ds:dword ptr [si]).Processor; get processor signature
	movzx	ecx,cgroup:word ptr update_blocks; ECX = #of blocks to be searched in scratch pad1
					; ECX bit31-16 = #of blocks to be searched in scratch pad2
bl01_03:
	cmp	(UpdateHeaderStruc ptr es:[di]).HeaderVersion,000000000h; empty ?
	jnz	bl01_05 		; no, so check for processor
;  this block is empty
	or	ebx,ebx 		; empty block already found ?
	jnz	bl01_06 		; yes
	push	es
	push	di
	pop	ebx			; EBX bit31-16 = segment of 1st empty block
					;     bit15-0  = offset  of 1st empty block
	jmp	short bl01_06
bl01_05:
	cmp	eax,(UpdateHeaderStruc ptr es:[di]).Processor; match ?
	jz	bl01_04 		; yes..
bl01_06:
	add	di,block_length 	; ES:DI ptr to next block
	jnc	bl01_30			; not cross boundary yet..
	mov	es,dx			; ES = next scratch pad (pad2)
bl01_30:
	loop	bl01_03 		; continue search
bl01_07:
;  no existing data block contain data for given processor
;  EBX bit31-16 = segment of 1st empty block
;      bit15-0	= offset  of 1st empty block
	push	eax
	mov	eax,cgroup:micro_code_start_addr
	and	eax,0000ffffh		; keep offset in next scratch
	mov	di,ax
	pop	eax

	or	ebx,ebx
	jz	bl01_12
	push	ebx
	pop	di
	pop	es			; ES:DI = ptr to empty block
bl01_12:
	mov	ebx,(UpdateHeaderStruc ptr ds:[si]).UpdateRevision; get update revision from given data
	jmp	short bl01_13
bl01_04:
;  DS:SI = Pointer to update (source) buffer
;  ES:DI = ptr to update data block which already contain data for given processor
	mov	ebx,(UpdateHeaderStruc ptr ds:[si]).UpdateRevision; get update revision from given data
	cmp	ebx,(UpdateHeaderStruc ptr es:[di]).UpdateRevision; given update revison > existing ?
	jbe	bl01_08 		; no, invalid update revision
;  authenticate the update
	call	get_processor_update_revision; EDX = processor update revision
	cmp	ebx,edx 		; supplied revision > current revision ?
	jbe	bl01_08 		; no, invalid update revision
bl01_13:
;  validate update revision by actually loading the update into current processor
;  DS:SI = ptr to update data
	push	0000h
	push	ds
	pop	eax			; EAX = DS
	shl	eax,4
	movzx	esi,si
	add	eax,esi 		; EAX = 32bit address of update data structure
	add	eax,sizeof UpdateHeaderStruc; EAX = 32bit address of actual update data
	mov	ecx,00000079h		; ECX = 00000079h
	xor	edx,edx 		; EDX = 00000000h
	wrmsr				; trigger BIOS update in processor
	call	get_processor_update_revision; EDX = processor update revision
	cmp	ebx,edx 		; update revision must match
	jz	bl01_09 		; processor accepts the update
;  error, processor rejects the update
	popad
	mov	ah,security_failure	; error code
	jmp	short bl01_10
bl01_08:
	popad
	mov	ah,invalid_revision	; error code
bl01_10:
	pop	es
	jmp	bl01_00 		; exit
bl01_09:
;  ES:DI = ptr to block where data will be updated
;  DS:SI = ptr to source buffer

	call	get_sum_of_update_area
	push	eax
	push	es

bl01_43:
	mov	cx,block_length		; #of BYTES to move
bl01_40:
	mov	al,ds:[si]
	mov	es:[di],al
	inc	si
	inc	di
	jnz	bl01_41			; not cross boundary..
	mov	es,bp			; next buffer (scratch pad2)
bl01_41:
	loop	bl01_40			; next byte

; Update the checksum adjustment of microcode module
	pop	es
	pop	ebx			; EBX = sum of microcode module (in dwords) before updating
	call	get_sum_of_update_area
	sub	ebx,eax			; get difference in ebx
	mov	esi,cgroup:micro_code_start_addr
	movzx	eax,cgroup:word ptr update_blocks
	shl	eax,11			; 2K unit
	add	esi,eax			; get to the end of the module
	push	esi
	pop	di
	pop	ax
	mov	esi,cgroup:micro_code_start_addr
	shr	esi,16
	cmp	ax,si			; cross the 64k boundary ?
	jz	bl01_45			; no..
	mov	es,bp			; use scratch pad2
bl01_45:
	or	ebx,ebx			; need to adjust ?
	jz	bl01_46			; no..
	and	di,0fffch		; dword align
	add	dword ptr es:[di+4],ebx	; add the adjustment
bl01_46:

	popad
	pop	es
;  update flash from scratch pad1:0000, 64K
;		     scratch pad2:0000, 64K
;  CX = segment having 1st 64k of flash
;  DX = segment having 2nd 64k of flash
	pushad
	mov	es,cx			; ES = segment having 1st 64k of NVRAM storage
	push	es
	push	dx
	call	e000_read_rom_write_x	; enable ROM
	call	flash_write_enable	; enable flash write
	call	go_to_flat_mode_stack	; go to flat mode
	pop	dx
	pop	es
	xor	esi,esi 		; ES:ESI = source buffer
	mov	edi,cgroup:micro_code_start_addr
	and	edi,0ffff0000h		; 0:EDI = 1st flash
;  DS:EDI = ptr flash in flat mode..
	xor	cx,cx			; #of bytes to write
	mov	bx,cgroup:word ptr flash_found_table
	cmp	bx,0ffffh		; Flash found ?
	stc
	jz	bl01_11 		; no flash part found
	call	cs:word ptr [bx+2]	; erase
	jc	bl01_11 		; error in erasing
	call	cs:word ptr [bx+4]	; program
	jc	bl01_11 		; error in programming
	mov	es,dx			; 2nd segment
	xor	esi,esi 		; ES:ESI = source buffer
	mov	edi,cgroup:micro_code_start_addr
	and	edi,0ffff0000h
	add	edi,000010000h		; 0:EDI = 2nd flash
;  DS:EDI = ptr flash in flat mode..
	xor	cx,cx			; 64K
	cmp	edi,0FFFF0000h		; 2nd is F000 sgement ?
	jne	bl01_20 		; no.. 64K can be written
	mov	cx,48*1024		; CX = #of bytes in F000 segment
bl01_20:
	call	cs:word ptr [bx+2]	; erase
	jc	bl01_11 		; error in erasing
	call	cs:word ptr [bx+4]	; program
bl01_11:
	pushf				; save status of programming flash
	call	comeback_from_flat_mode_stack
	call	flash_write_disable	; disable write to flash
	popf
	popad
	mov	ah,success		; ok
	jnc	bl01_00
	mov	ah,write_failure	; error
bl01_00:
	pop	si
	pop	di
	pop	ds
	pop	es
	ret

;-----------------------------------------------------------------------;
; Input:
;	ES    = scratch pad1:0
;	BP    = scratch pad2:0
; Output:
; 	EAX = sum of updateing area in dwords
;-----------------------------------------------------------------------;
get_sum_of_update_area:
	push	es
	push	di
	push	cx

	mov	di,word ptr cgroup:micro_code_start_addr ; di = offset in scratch pad1

	xor	eax,eax			; (eax) = dword checksum before updating
	test	di,03h			; dword boundary ?
	jz	sum_exit		; yes.. no need to update checksum

	and	di,0fffch		; dword alignment
	mov	cx,cgroup:word ptr update_blocks
	shl	cx,(11-2)		; in dwords
	add	cx,1+2			; 1 dword = not in dword alignment, 2 dwords = checksum adjustment
sum_01:
	add	eax,es:[di]
	add	di,4			; next dword
	jnz	sum_02
	mov	es,bp			; next buffer (scratch pad2)
sum_02:
	loop	sum_01
sum_exit:
	pop	cx
	pop	di
	pop	es
	ret

;-----------------------------------------------------------------------;
;			BIOS UPDATE CONTROL				;
; this function enables loading of binary updates into the processor.	;
; input :								;
;	AX	D042							;
;	BL	02							;
;	BH	Task							;
;		1 Enable update loading during initialization time	;
;		2 Return the current state of update control without	;
;		  changing its status					;
;	CX	Scratch Pad1 (Real Mode Scratch segment 64K in length)	;
;	DX	Scratch Pad2 (Real Mode Scratch segment 64K in length)	;
;	SI	Scratch Pad3 (Real Mode Scratch segment 64K in length)	;
;	SS:SP	Stack (32K minimum)					;
; output:								;
;	CF	return status						;
;		NC = success						;
;		CY = error						;
;	AH	return code						;
;	AL	additional OEM information				;
;	BL	Enable/Disable indicator				;
;		0 = Disabled, 1 = Enabled				;
; note :								;
; 1. this function allows the caller to determine the current status of ;
; update loading without changing its status.				;
; 2. this function allows the caller to enable the update loading at	;
; initialization time.							;
; 3. this function does NOT allow the caller to disable loading of	;
; binary updates as this poses security risk. The system BIOS mantains	;
; control for disabling the loading of BIOS updates through Setup or	;
; other mechanism.							;
;-----------------------------------------------------------------------;
	extrn	q_bu_update:abs
	extrn	check_cmos_8e:near
	extrn	check_cmos_data:near
	extrn	set_cmos_item_checksum:near
bl_02:
	mov	ah,not_implemented	; error for invalid task
	mov	al,01h			; AL = 01h for Enable
	cmp	bh,01h
	jb	bl02_00 		; invalid task (input BH = 00)
	jnz	bl02_01 		; input BH <> 1
;  input BH = 01, Enable update loading
	call	check_cmos_8e
	mov	ah,read_failure 	; error for CMOS bad
	jnz	bl02_00 		; CMOS bad
	mov	ah,01h			; Enable
	mov	al,q_bu_update		; AH, AL = data, setup structure#
	call	set_cmos_item_checksum
	mov	bl,01h			; enable
	jmp	short bl02_02
bl02_01:
	cmp	bh,02h
	jnz	bl02_00 		; invalid task (input BH > 2)
;  input BH = 02, Return current state
	mov	al,q_bu_update		; Setup structure#
	call	check_cmos_data
	mov	bl,al			; 0/1 disable/enable
bl02_02:
	mov	ah,success		; ok
bl02_00:
	ret
;-----------------------------------------------------------------------;
;			READ UPDATE DATA				;
; input :								;
;	AX	D042							;
;	BL	03							;
;	SI	Update Number						;
;		Index number (0-based) of update block to be read	;
;	ES:DI	Pointer to update (source) buffer			;
;	ECX Bit15-00 Scratch Pad1 (Real Mode Scratch segment 64K in length)
;	ECX Bit31-16 Scratch Pad2 (Real Mode Scratch segment 64K in length)
;	DX	Scratch Pad3 (Real Mode Scratch segment 64K in length)	;
;	SS:SP	Stack (32K minimum)					;
; output:								;
;	CF	return status						;
;		NC = success						;
;		CY = error						;
;	AH	return code						;
;	AL	additional OEM information				;
;-----------------------------------------------------------------------;
bl_03:
	mov	ah,update_num_invalid	; invalid update block number
	cmp	si,cgroup:update_blocks ; valid update block# ?
	jae	bl03_00 		; invalid update block#, error
	cli
	pushad
	mov	cx,block_length
	movzx	esi,si
	shl	esi,0bh 		; 2K unit
	add	esi,cgroup:micro_code_start_addr
	call	read_bytes
	popad
	mov	ah,success		; ok
	clc
bl03_00:
	ret
;-----------------------------------------------------------------------;
;				SUBROUTINES				;
;-----------------------------------------------------------------------;
;				READ_BYTES				;
;  this routines reads the concerned NVRAM block into the given buffer. ;
;  input :								;
;	ES:DI	Pointer to read buffer					;
;	ESI	absolute address of soure				;
;	CX	#of bytes to read					;
;  output:								;
;	none								;
;  register destroyed : none						;
;-----------------------------------------------------------------------;
read_bytes:
        push    ax
	mov	ah, 40h
	call	read_sio_byte  
	push	ax
if MKF_256K_BIOS
	or	al,03h
else
	or	al,02h
endif
	call	write_sio_byte

        push    es
        push    ds
        pushad
        push    es
        call    go_to_flat_mode_stack
        pop     es
        popad
        pushad
        movzx   edi,di
rb_00:
        lods    ds:byte ptr [esi]
        stos    es:byte ptr [edi]
        loop    rb_00
        call    comeback_from_flat_mode_stack
        popad
        pop     ds
        pop     es

	pop	ax
	call	write_sio_byte
        pop     ax
        ret
;-----------------------------------------------------------------------;
;			GET_PROCESSOR_UPDATE_REVISION			;
;  this routine returns the update revision of the processor.		;
;  input :								;
;	none								;
;  output:								;
;	EDX	update revision 					;
;  register destroyed : EAX, ECX, EDX					;
;-----------------------------------------------------------------------;
get_processor_update_revision:
	push	ebx
	mov	ecx,8bh 		; Model specific register to be read
	xor	eax,eax
	xor	edx,edx
	wrmsr				; load 0 to MSR at 8Bh
	xor	eax,eax
	inc	ax
	cpuid				; CPUID will deposit an update ID value
					; in 64-bit MSR at address 8Bh
	mov	ecx,8bh 		; Model specific register to be read
	rdmsr				; EDX = update revision
	pop	ebx
	ret
;-----------------------------------------------------------------------;
_text	ends
end
