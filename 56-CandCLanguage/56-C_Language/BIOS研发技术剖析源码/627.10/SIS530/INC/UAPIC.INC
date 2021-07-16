;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1995, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(404)-263-8181.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
; THIS CODE IS TAKEN FROM PAGE A-2 OF INTEL PC+MP MULTIPROCESSOR
; PLATFORM SPECIFICATION. VERSION 1.1 DATED OCT 1994.

	extrn	go_to_flat_mode:near
	extrn	comeback_from_flat_mode:near

;THIS ROUTINE PROGRAMS LOCAL APIC IN VIRTUAL-WIRE MODE
; ----------------------------------------------------------------------;
; Initialize the local APIC if it exists and is hardware enabled.	;
;-----------------------------------------------------------------------;

u_init_local_apic:	
	mov	al,080h		; ensure NMI disable
	out	070h,al
	
	mov	al,0ffh		; mask all off
	out	021h,al		
	out	0a1h,al
;
; The APIC has an error interrupt and a spurious interrupt. The spurious
; interrupt must be pointed to a vector whose lower nibble is 0fh, that is 
; 0xfh, where x is 0 -f. The ERRINT interrupt can be vectored to any
; interrupt vector. Here we point both of them to Int 00fh, which has 
; already been initialised in memory, and supplies the necessary IRET.
;
; First set ERRINT to vector 00fh
;
	mov	esi,ERRINT
	mov	eax,[esi]
	and 	eax,0ffffff00h
	or	eax,00000000fh
	mov	[esi],eax
	
;
; Next enable the APIC via SVR, and set the spuroius interrupt to use Int 00fh
;
	mov	esi,SVR
	mov	eax,[esi]	;read SVR
	and	eax,0ffffff0fh	;clear spurious vector (use vector 00fh)
	or	eax,APIC_ENABLED	;bit 8=1
	mov	[esi],eax	; write SVR
	
;
; Program LVT1	as ExtInt which delivers the signal to the INTR signal of all
; processor's cores listed in the destination as an interrupt that originated
; in an externally connected interrupt controller.

	mov	esi,LVT1
	mov	eax,[esi]		; read LVT1
	and	eax,0fffe58ffh		; not masked, edge, active high
	or	eax,000000700h		; ExtInt
	mov	[esi],eax		; write LVT1
	
;
; program LVT2 as NMI which delivers the signal on the NMI signal of all
; processor's cores listed in the destination.
;
	
	mov	esi,LVT2
	mov	eax,[esi]		; read LVT2
	and	eax,0fffe58ffh		; not masked, edge, active high
	or	eax,0ffff0400h		; NMI
	mov	[esi],eax		; write LVT2
	
	jmp	u_init_local_apic_end

.286p	
	
	
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1995, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(404)-263-8181.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
