;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1997, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;**********************************************************************;
;**********************************************************************;
;----------------------------------------------------------------------------;
	include	makeflag.equ
	include	oemmake.equ
	include	acpi.equ
	include	acpi_css.equ
	include	acpi_oem.equ
;----------------------------------------------------------------------------;
cgroup  group   _text
_text   segment page    public  USE16   'CODE'
	assume  cs:cgroup
.486p
;---------------------------------------;
	include acpi.dat		; MUST be the 1st file before any code
;---------------------------------------;

	ORG	ACPI_MODULE_ENTRY_OFFSET
;-----------------------------------------------------------------------;
; acpi_generate_tables_far - Far Call Setup (porting not required)	;
;									;
; Input :								;
;	DS:SI	ptr to AML Code						;
;	CX	length of AML code in bytes				;
;	EAX	32Bit Start address of ACPI tables			;
;	EBX	32Bit Start address of BOOT table			;
; Output:								;
;	EAX	Pointer to the Firmware Wake Vector Field		;
; Register Destroyed : ALL except FS GS					;
;-----------------------------------------------------------------------;
acpi_generate_tables_far	proc	near

	call	acpi_generate_tables
	retf
	
acpi_generate_tables_far	endp		     

;-----------------------------------------------------------------------;
; acpi_generate_tables - Code to build tables, init pointers and	;
;                        checksum (porting not required)		;
;									;
; Input :								;
;	DS:SI	ptr to AML Code						;
;	CX	length of AML code in bytes				;
;	EAX	32Bit Start address of ACPI tables			;
;	EBX	32Bit Start address of BOOT table			;
; Output:								;
;	EAX	Pointer to the Firmware Wake Vector Field		;
; Register Destroyed : ALL except FS GS					;
;-----------------------------------------------------------------------;
acpi_generate_tables	proc	near

	push	eax			; EAX = 32bit start destm address of ACPI table

; Build RSDT Table, ORG 0 of the Segment where we explode this code
	push	cs
	pop	es

; Before a CALL was made to this Routine from POSTACPI.ASM, the PCode was
; decompressed in Lower RAM, CX has the Size. If there is any problem with
; PCode Size/Chcksum, check to see if correct size is getting Passed
; Although DSDT requires a Header, but the AML (DSDT Block) has the Header

	mov	di,offset dsdt_buffer.dsdt_table

; CX has the size of the AML Code, before coming here had uncompressed the
; the AML Code and CX had the number of BYTES

	rep	movsb
	push	cs
	pop	ds
	xor	si,si
	xor	di,di

;-----------------;
; Init RSDT Table ;
;-----------------;
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_signature,RSDT_SIGN_DW
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_rev,ACPI_REV
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_length,size rsdt_table
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_oem_id_1,TBL_OEMID1
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_oem_id_2,TBL_OEMID2
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_creator_id,CREATOR_VEND_ID
	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_creator_rev,CREATOR_REV
	mov	dword ptr rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_oem_rev,RSDT_OEM_REV

;------------------;
; Build FACP Table ;
;------------------;
	mov	facp_buffer.facp_table.facp_header.genhdr.table_signature,FACP_SIGN_DW
	mov	facp_buffer.facp_table.facp_header.genhdr.table_rev,ACPI_REV
	mov	facp_buffer.facp_table.facp_header.genhdr.table_length,size facp_table
	mov	facp_buffer.facp_table.facp_header.genhdr.table_oem_id_1,TBL_OEMID1
	mov	facp_buffer.facp_table.facp_header.genhdr.table_oem_id_2,TBL_OEMID2
	mov	facp_buffer.facp_table.facp_header.genhdr.table_creator_id,CREATOR_VEND_ID
	mov	facp_buffer.facp_table.facp_header.genhdr.table_creator_rev,CREATOR_REV
	mov	dword ptr facp_buffer.facp_table.facp_header.genhdr.table_oem_rev,FACP_OEM_REV

IF MKF_ACPI_APIC_TBL
	mov	facp_buffer.facp_table.int_model,MULTIPLE_APIC
ELSE
	mov	facp_buffer.facp_table.int_model,DUAL_PIC
ENDIF

	call	acpi_css_return_sci_vector			; returns in DX
	mov	facp_buffer.facp_table.sci_int_vect,dx

	call	acpi_css_return_smi_port			; returns in EDX
	mov	facp_buffer.facp_table.smi_cmd_port,edx

	mov	facp_buffer.facp_table.acpi_val_enb,ACPI_ENABLE
	mov	facp_buffer.facp_table.acpi_val_dis,ACPI_DISABLE

	mov	facp_buffer.facp_table.p_lvl2_lat_val,LVL2_LATENCY_VALUE
	mov	facp_buffer.facp_table.p_lvl3_lat_val,LVL3_LATENCY_VALUE

	mov	facp_buffer.facp_table.flush_size_val,FLUSH_SIZE
	mov	facp_buffer.facp_table.flush_stride_val,FLUSH_STRIDE

	mov	facp_buffer.facp_table.duty_offset_val,DUTY_OFFSET
	mov	facp_buffer.facp_table.duty_width_val,DUTY_WIDTH

	mov	facp_buffer.facp_table.day_alarm_val,DAY_ALARM_IDX
	mov	facp_buffer.facp_table.month_alarm_val,MTH_ALARM_IDX
	mov	facp_buffer.facp_table.century_val,CENT_VAL

	call	acpi_oem_set_facp_flags				; [acpi_oem.inc]
	mov	facp_buffer.facp_table.facp_flags,edx

IF MKF_ACPI_APIC_TBL
%out APIC Code In
;------------------;
; Build APIC Table ;
;------------------;
	mov	apic_buffer.apic_table.apic_header.genhdr.table_signature,APIC_SIGN_DW
	mov	apic_buffer.apic_table.apic_header.genhdr.table_rev,ACPI_REV
	mov	apic_buffer.apic_table.apic_header.genhdr.table_length,size apic_table

; Proc Struc HARD CODE for NOW : SVCV Board
	mov	apic_buffer.apic_table.proc_1_entry.procstruc.struc_type,STRUC_PROC_TYPE
	mov	apic_buffer.apic_table.proc_1_entry.procstruc.proc_length,12d
; APIC ID has been declared as 1 in ASL
	mov	apic_buffer.apic_table.proc_1_entry.procstruc.apic_proc_id,1d
;; Hard Coded NOW, Needs to changed for OTHER SYSTEMS
	mov	apic_buffer.apic_table.proc_1_entry.procstruc.apic_id,00
;; FEE00000h
;;	mov	apic_buffer.apic_table.local_apic_addr,0000e0feh
	mov	apic_buffer.apic_table.local_apic_addr,0FEE00000h

; System has Dual 8259 Setup as well
	mov	apic_buffer.apic_table.multiple_apic_flags,1

;; IO APIC Struc Hard Code for NOW... SV / CV
	mov	apic_buffer.apic_table.ioapic_1_entry.ioapicstr.struc_type,STRUC_IOAPIC_TYPE
	mov	apic_buffer.apic_table.ioapic_1_entry.ioapicstr.ioapic_length,12d

;; Hard Coded 2 FOR NOW...
	mov	apic_buffer.apic_table.ioapic_1_entry.ioapicstr.io_apic_id,02h
;;	mov	apic_buffer.apic_table.ioapic_1_entry.ioapicstr.io_apic_addr,0000c0feh
	mov	apic_buffer.apic_table.ioapic_1_entry.ioapicstr.io_apic_addr,0FEC00000h
	mov	apic_buffer.apic_table.ioapic_1_entry.ioapicstr.sys_vect_base,12000000h

ENDIF

;--------------;
; FACP --- CSS ;
;--------------;

	call	acpi_css_clear_status_flags			; [acpi_css.inc]
	call	acpi_oem_clear_status_flags			; [acpi_oem.inc]

	call	acpi_css_setup_pm1a_evt_cnt			; [acpi_css.inc]
	mov	facp_buffer.facp_table.pm1a_evt_blk_addr,edx	; FACP Table - PM1a_EVT_BLK
	mov	facp_buffer.facp_table.pm1a_cnt_blk_addr,ebx	; FACP Table : PM1a_CNT_BLK

	call	acpi_css_setup_pm1b_evt_cnt			; [acpi_css.inc]
	mov	facp_buffer.facp_table.pm1b_evt_blk_addr,edx	; FACP Table - PM1a_EVT_BLK
	mov	facp_buffer.facp_table.pm1b_cnt_blk_addr,ebx	; FACP Table : PM1a_CNT_BLK

	call	acpi_css_setup_pm1_length			; [acpi_css.inc]
	mov	facp_buffer.facp_table.pm1_evt_length,dl	; FACP Tabme - PM1_EVT_LEN
								; (PM1a_EVT_BLK + PM1b_EVT_BLK)
	mov	facp_buffer.facp_table.pm1_cnt_length,bl	; FACP Table : PM1_CNT_LEN
								; (PM1a_CNT_BLK + PM1b_CNT_BLK)

	call	acpi_css_setup_pm2_blk				; [acpi_css.inc]
	mov	facp_buffer.facp_table.pm2_cnt_blk_addr,edx	; FACP Table - PM2_CNT_BLK
	mov	facp_buffer.facp_table.pm2_cnt_length,bl

	call	acpi_css_setup_gpe0_blk				; [acpi_css.inc]
	mov	facp_buffer.facp_table.gpe0_blk_addr,edx
	mov	facp_buffer.facp_table.gpe0_blk_length,bl

	call	acpi_css_setup_gpe1_blk				; [acpi_css.inc]
	mov	facp_buffer.facp_table.gpe1_blk_addr,edx
	mov	facp_buffer.facp_table.gpe1_blk_length,bl

	call	acpi_css_setup_pm_tmr_blk			; [acpi_css.inc]
	mov	facp_buffer.facp_table.pm_tmr_blk_addr,edx	; FACP Table : PM_TMR_BLK
	mov	facp_buffer.facp_table.pm_tmr_length,bl

;------------------;
; Build FACS Table ;
;------------------;
	mov	facs_buffer.facs_table.facs_signature,FACS_SIGN_DW
	mov	facs_buffer.facs_table.facs_length,size facs_table

;-----------------;
; Init Table PTRs ;
;-----------------;
; 'get_start_acpi_table_address' will invoke Int 15H E820 and cycle
; through all Memory Ranges to find out where ACPI Reclaim Type
; Memory Starts

	pop	eax			; EAX = 32bit start destn address of ACPI table
	push	eax
	mov	ebx,eax

	xor	esi,esi
	mov	si, offset facp_buffer.facp_table
	add	eax,esi

	mov	rsdt_buffer.rsdt_table.facp_ptr,eax	; Start Address for FACP Init

	xor	esi,esi
	mov	si, offset facs_buffer.facs_table
	mov	eax,ebx
	add	eax,esi

	mov	facp_buffer.facp_table.facs_ptr,eax

	xor	esi,esi
	mov	si, offset dsdt_buffer.dsdt_table
	mov	eax,ebx
	add	eax,esi

	mov	facp_buffer.facp_table.dsdt_ptr,eax

IF MKF_ACPI_APIC_TBL
	xor	esi,esi
	mov	si, offset apic_buffer.apic_table
	mov	ecx,ebx
	add	ecx,esi

	mov	rsdt_buffer.rsdt_table.apic_ptr,ecx	; Start Address for APIC Table
ENDIF

;-----------------;
; Checksum Tables ;
;-----------------;
	push	cs
	pop	es

	mov	si,offset rsdt_buffer.rsdt_table
	mov	cx,size rsdt_table

	call	checksum_acpi_table

	mov	rsdt_buffer.rsdt_table.rsdt_header.genhdr.table_checksum, ah

	mov	si,offset facp_buffer.facp_table
	mov	cx,size facp_table
	call	checksum_acpi_table

	mov	facp_buffer.facp_table.facp_header.genhdr.table_checksum, ah

IF MKF_ACPI_APIC_TBL
	mov	si,offset apic_buffer.apic_table
	mov	cx,size apic_table
	call	checksum_acpi_table

	mov	apic_buffer.apic_table.apic_header.genhdr.table_checksum, ah
ENDIF

; EAX Address of Wake Vector
	pop	eax			; EAX = 32bit start destn address of ACPI table
	xor	esi,esi
	mov	si, offset facs_buffer.facs_table.fw_wake_vector
	add	eax,esi			; Address of Waking Vector

	ret
acpi_generate_tables	endp
;-----------------------------------------------------------------------;

;-----------------------------------------------------------------------;
; CHECKSUM_ACPI_TABLE (no porting changes)				;
;									;
; Description:	This routine checksums each ACPI table and stores its	;
; 		length in the table header.				;
;									;
; Input:	ES:SI	Pointer to Start of ACPI table			;
;      		CX      Length of the Table				;
; Output:	AH	Checksum Value of ACPI Table			;
; Stack:	Available						;
; Registers destroyed: AX, CX, SI, DI					;
;-----------------------------------------------------------------------;
checksum_acpi_table	proc	near
	xor	ax,ax		; checksum

checksum_loop:
        lodsb	es:[si]
        add     ah,al
        loop    checksum_loop
        neg	ah

	ret
checksum_acpi_table	endp

;-----------------------------------------------------------------------;
; ACPI_DELAY (no porting changes)					;
;									;
; Description:	Delay Loop						;
;-----------------------------------------------------------------------;
acpi_delay	proc	near
	push	cx
	xor	cx,cx
	loop	$
	pop	cx
	ret
acpi_delay	endp
;-----------------------------------------------------------------------;

;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1997, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;
	include	acpi_css.inc		; Chipset Porting Routines (REQUIRED)
	include	acpi_oem.inc		; OEM Porting Routines (REQUIRED)
;-----------------------------------------------------------------------;
_text   ends
end
