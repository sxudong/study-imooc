	page	,132
	title	CPU POST MODULE

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
;*****************************************************************;


	extrn	AbsOverwriteByte	:byte
	extrn	AbsVendor		:byte
	extrn	AbsVendorNo		:byte
	extrn	AbsCPUID		:byte
	extrn	AbsCPU			:byte
	extrn	AbsCPUNo		:byte
	extrn	cpu_$_start		:byte
	extrn	cpu_vendor		:byte

	extrn	Vendor_Name_Tbl		:byte
	extrn	Vendor_Name_Tbl_End	:byte
	extrn	Vendor_Check_Procs	:byte
	extrn	Vendor_Check_Procs_End	:byte

	extrn	Vendor_Post_Data_Base	:word

	extrn	UnknownCPU_$		:abs
	extrn	Unknown_$		:abs
	extrn	_max_vendor_support	:abs
;	extrn	Q_CPU_OVERRIDE		:abs

	extrn	check_cmos_8e		:near
	extrn	check_cmos_data		:near


;*****************************************************************************;
cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
	.486p
;*****************************************************************************;

		INCLUDE 	cpumac.mac	; Macros used
		INCLUDE 	cpuequ.equ	; Equates used
		INCLUDE		cpustruc.def	; Structure definitions

;*****************************************************************************;

	vndr_post_struc_size	db	sizeof VNDRPSTSTRUC

;*****************************************************************************;

		comment �
		���������������������������������������������
		�					    �
		�   I N T E R F A C E	 R O U T I N E S    �
		�					    �
		���������������������������������������������
		�

Public		CPU1ModuleStart
CPU1ModuleStart:

		   comment �
		   ������������������������������������ͻ
		   �	       GetVendorName		�
		   ������������������������������������͹
		   �  This routine returns the current	�
                   �  CPU's vendor name string pointer  �
		   ������������������������������������Ķ
		   �  Environment  : Stack available	�
		   �  Invoked	   : from anytime	�
		   ������������������������������������Ķ
		   �  Input	   : none		�
		   �  Output	   : DX:AX = string ptr �
		   �		     BL = functional	�
		   �		          vednor#	�
		   �		     BH = Vendor# from	�
		   �		          from ResetID	�
		   ������������������������������������Ķ
		   �   REGISTER DESTROYED: AX, DX, BX	�
		   ������������������������������������ͼ
		   �

Public			GetVendorName
GetVendorName		proc	near

	pusha
	mov	bp,sp
	call	GetVendorHandle 	; AL = VendorHandle
	mov	ah,al			; AH = VendorHandle
	xor	bx,bx
	mov	bh,UnknownCPU_$		; To print 'XX'
	cmp	al,UnknownVendor
	jz	retgvn

;;	call	GetCPUHandle		; BX = CPUHandle
;;	call	CheckOverwrite		; Overwrite ?, AX/BX will be set

	push	ax
	call	check_cmos_8e
	pop	ax
	jnz	cmos_bad
;;	push	ax
;;	mov	al,Q_CPU_OVERRIDE
;;	call	check_cmos_data		; AL.7-4 = selected CPU
;;;;;;	shr	al,4
;;	mov	bl,al
;;	cmp	al,_max_vendor_support	; Is this exceeds supported vendors ?
;;	pop	ax
;;	ja	cmos_bad		; cpu selection will be auto
;;	mov	al,bl
cmos_bad:
	mov	si,ax			; SI = vendor handle
	mul	cs:byte ptr vndr_post_struc_size
	xchg	si,ax			; SI = offset in vendor data base
	mov	si,cs:Vendor_Post_Data_Base[si].VNDRPSTSTRUC.wMemDBase
	mov	bl,cs:[si].FMLYHDRSTRUC.bFmly$Set
	mov	bh,cs:[si].FMLYHDRSTRUC.bFmly$Num
	test	cs:byte ptr AbsOverwriteByte,AbsVendorBit
	jz	retgvn
	mov	bx,cs:word ptr AbsVendor; BH/BL = string set/ string#
retgvn:
	mov	word ptr[bp+StackPosBX],ax
	call	Get$Ptr			; DX:AX = pointer to the string
	mov	word ptr[bp+StackPosAX],ax
	mov	word ptr[bp+StackPosDX],dx
	popa
	ret

GetVendorName		endp


	 comment �
	 ������������������������������������������������������ͻ
	 �			 GetCPUID			�
	 ������������������������������������������������������͹
	 �	This routine is used to get the CPU		�
	 �	related information at any time.		�
	 ������������������������������������������������������Ķ
	 �	Environment : Stack available			�
	 �	Invoked     : from any time			�
	 ������������������������������������������������������Ķ
	 �	Input	    : none				�
	 �	Output	    : DX:AX = string pointer		�
	 �		      BX = FuncField			�
	 �		      CL = CPU#				�
	 ������������������������������������������������������Ķ
	 �    FuncField:					�
	 �    --------- 					�
	 �		      					�
	 �    High Byte 	Low Byte			�
	 �    ���������������Ŀ ���������������Ŀ		�
	 �    �7�6�5�4�3�2�1�0� �7�6�5�4�3�2�1�0�		�
	 �    ����������������� �����������������		�
	 �     � ��� � ����� �	 � ��� ��� � ���		�
	 �     �  �CPUID �   �	 �  �	�  � VendorCachePgm	�
	 �     �  �0: no �   �	 �  �	�  �			�
	 �    Res.�1: yes�   �	 �  �	� Reserved		�
	 �	  � 	 �   � SMI  �	�			�
	 �	  � 	 �   � 0=no � Clock Info		�
	 �      SMI Type �   � 1=yes� 00=1X			�
	 �	00: Intel�   �	    � 01=2X			�
	 �	01: Cyrix�   FPU    � 10=3X			�
	 �	10: AMD	 �   0=no   � 11=4X			�
	 �	11: Res. �   1=yes  �				�
	 �		 �	  Bus Size			�
	 �	      InitCode	  00=16 bit			�
	 �			  01=32 bit			�
	 �			  10=64 bit			�
	 �			  11=reserved			�
	 �							�
	 �  * VendorCachePgm : This is the chche method 	�
	 �		       for a particular vendor. 	�
	 �		       For a particular vendor		�
	 �		       there may be different		�
	 �		       kinds of cache methods.		�
	 �		       This will give the method	�
	 �		       number.				�
	 �							�
	 �  * InitCode	     : This is the CPU init method.	�
	 �		       For different CPU there may	�
	 �		       be initialization methods.	�
	 �							�
	 �  * SMI	     : This bit tells whether CPU has	�
	 �		       SMI support or not.		�
	 �							�
	 �  * FPU	     : This bit tells whether CPU has	�
	 �		       integrated FPU or not.		�
	 �		      					�
	 �  * CPUID	     : This bit tells whether CPU does	�
	 �		       support CPUID instruction.	�
	 �		      					�
	 �  * SMI Type       : This is the SMI method, the CPU	�
	 �		       supports.			�
	 ������������������������������������������������������Ķ
	 �	     REGISTER DESTROYED : AX, BX, CX, DX	�
	 ������������������������������������������������������ͼ
	 �


Public			GetCPUID
GetCPUID		proc	near

	pushad				; Save registers (32 bits)
	mov	bp,sp			; BP = ptr to reg stack bottom
	test	cs:byte ptr AbsOverwriteByte,AbsCPUBit
	jz	getcid
	mov	ax,cs:word ptr AbsCPUID	; AX = CPUID for absolute overwrite CPU
	mov	bx,cs:word ptr AbsCPU	; BH/BL = string set/string#
	jmp	short retcid
getcid:
	call	GetVendorHandle 	; AX = VendorHandle, DX = ResetID
	push	dx
	push	bx
	call	GetVendorName	 	; BL = VendorHandle
	movzx	ax,bl			; AX = VendorHandle
	pop	bx
	pop	dx
	cmp	al,UnknownVendor
	jnz	ok_vndr_get_id

;---------------------------------------;
;	UNKNOWN VENDOR			;
;---------------------------------------;

	xor	bx,bx
	mov	dl,UnknownCPU
	mov	bh,Unknown_$
	jmp	short retcid
ok_vndr_get_id:
	call	GetCPUHandle		; BX = CPUHandle
	call	GetCPUID@Reset		; AX = FuncField, BH/BL = str set/#
retcid:
	mov	word ptr[bp+StackPosEBX],ax
	mov	byte ptr[bp+StackPosECX],dl
	call	get$ptr			; DX:AX = string pointer
	mov	word ptr[bp+StackPosEDX],dx
	mov	word ptr[bp+StackPosEAX],ax
	popad
	ret

GetCPUID		endp



		   comment �
		   �������������������������������������ͻ
		   �	       GetCPUID@Reset		 �
		   �������������������������������������͹
		   �  This routine returns functional	 �
		   �  information about the CPU. Does	 �
		   �  not returns the Name string like	 �
                   �  "GetCPUID" routine.                �
		   �������������������������������������Ķ
		   �  Environment : No stack usage	 �
		   �  Invoked	  : Anytime		 �
		   �������������������������������������Ķ
		   �  Input	  : AX = VendorHandle	 �
		   �		    BX = CPUHandle	 �
		   �		    DX = ResetID/CPUID	 �
		   �			 (SearchHandle)  �
		   �  Output	  : AX = FuncField*	 �
		   �		    BH = String# (name)  �
		   �		    BL = StringSet	 �
		   �		    DL = CPU#		 �
		   �					 �
		   �  * See FuncField definition in the  �
                   �    "GetCPUID" routine.              �
		   �������������������������������������Ķ
		   � Used : EAX, BX, ECX, EDX, DI, ESP+  �
		   �������������������������������������ͼ
		   �

Public			GetCPUID@Reset
GetCPUID@Reset		proc	near

	mov	cx,ss			; Save current SS
	PushNS	ecx			; Save CX
	PushNS	esp			; Save current SP
	mov	di,cs
	mov	ss,di			; Create ROM stack

;-----------------------------------------------------------------------------;
; AX = New overwrite VendorHandle, BX = new overwrite CPUHandle		      ;
;-----------------------------------------------------------------------------;

	mul	cs:byte ptr vndr_post_struc_size
	xchg	ax,bx			; AX = CPUHandle, BX = offset in vendor
					; database
	mov	bx,cs:word ptr Vendor_Post_Data_Base[bx].VNDRPSTSTRUC.wMemDBase
					; BX = Family database pointer
	mov	di,bx			; DI = Family database ptr
	add	bx,sizeof FMLYHDRSTRUC	; Skip header
	mov	cx,6
	mul	cx			; AX = offset in family database
	add	bx,ax			; BX = ptr to family database element
get_funcfield:
	mov	ax,cs:[bx].FAMILYSTRUC.wFuncField
	mov	dl,cs:[bx].FAMILYSTRUC.bCPUNum
	mov	bh,cs:[bx].FAMILYSTRUC.b$num
	mov	bl,cs:[di].FMLYHDRSTRUC.bFmly$Set
	PopNS	esp			; Get back old SP
	PopNS	ecx			; Get back CX
	mov	ss,cx			; Restore SS
	ret

GetCPUID@Reset		endp


		comment �
		��������������������������������������ͻ
		�	    GetVendorHandle	       �
		��������������������������������������͹
		� This routine returns the VendorHandle�
		� which is needed to detect CPU vendor �
		� name and the CPUHandle to get the CPU�
		� name/functional information.	       �
		�				       �
		� Invoked: from the runtime BIOS or    �
		�	   application interface(may be�
		�	   throutgh INT-16h)	       �
		�				       �
		� Environment: Stack available	       �
		�	       Minimum CPU information �
		�	       is already saved.       �
		��������������������������������������Ķ
		�      Input   : None		       �
		�      Output  : AX = VendorHandle     �
		�		 BL = 0: no CPUID      �
		�		      1: CPUID present �
		�		 DX = computed ResetID �
		��������������������������������������Ķ
		�   Register Destroyed: AX, BL, DX     �
		��������������������������������������ͼ
		�


Public			GetVendorHandle
GetVendorHandle 	proc	near

	pushfd
	push	ds
	push	es
	pushad				; Save all registersd
	mov	bp,sp
	push	cs
	pop	ds
	lds	si,ds:dword ptr [0fea8h]; DS:SI = ptr to CPU info structure
	mov	byte ptr[bp+StackPosEBX],0
	pushfd
	pop	eax			; EAX = EFLAG
	and	eax,0ffdfffffh		; Bit 21 (ID bit) = 0
	push	eax
	popfd				; Set Flags
	xor	ax,ax			; Perform operation to modify FLAG
	pushfd
	pop	eax			; EAX = new EFLAGS
	test	eax,00200000h		; ID bit set ?
        jnz     short no_cpuid          ; This CPU does not support 'CPUID'
	or	eax,00200000h		; Set bit 21, ID bit
	push	eax
	popfd				; Update FLAG
	xor	ax,ax			; Operation modify FLAG
	pushfd
	pop	eax			; EAX = new EFLAG
	test	eax,00200000h		; Bit 21 still set ?
        jz      short no_cpuid          ; No, CPU does not support 'CPUID'

;�����������������������������������������������������������Ŀ
;� This CPU has inbuilt CPUID instruction. CPUID instruction �
;� returns vendor name string and CPU idendification code.   �
;�������������������������������������������������������������

	xor	eax,eax 		; Case 0 for CPUID instruction
	cpu_id				; EAX <- max level
					; EBX, ECX, EDX = vendor name string
	mov	eax,ebx
	mov	bx,offset Vendor_Name_Tbl
next_vendor_search::
	cmp	eax,cs:dword ptr[bx]	; First 4 letter check
	jnz	short next_vendor	; No..
	cmp	edx,cs:dword ptr[bx+4]	; Next 4 letter ?
	jnz	short next_vendor	; No..
	cmp	ecx,cs:dword ptr[bx+8]	; Next 4 letter ?
	jnz	short next_vendor	; No..

;�������������������������������������������������Ŀ
;� CPUID vendor string matched. Take VendorHandle. �
;���������������������������������������������������

	mov	byte ptr[bp+StackPosEBX],1
	xor	ax,ax
	mov	al,cs:byte ptr[bx+12]	; AL = VendorHandle
	jmp	ret_gvh
next_vendor::
	add	bx,13			; Next name entry
	cmp	bx,offset Vendor_Name_Tbl_End
	jc	short next_vendor_search
	mov	ax,UnknownVendor	; No vendor string matched
	jmp	ret_gvh
no_cpuid::
	mov	al,[si].CPUINFOSTRUC.bVndrNum
	xor	ah,ah
ret_gvh::
	mov	edx,[si].CPUINFOSTRUC.dResetID
	mov	word ptr[bp+StackPosEDX],dx
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Get back registers, return parameters
	pop	es
	pop	ds
	popfd
	ret

GetVendorHandle 	endp

		   comment �
		   ��������������������������������������ͻ
		   �		GetCPUHandle		  �
		   ��������������������������������������͹
		   �  This routine returns the CPUHandle  �
		   �  for detecting any CPU at any point  �
		   �  of time. CPUHandle is used to find  �
		   �  a particular CPU in the system.	  �
		   ��������������������������������������Ķ
		   �  Environment  : Stack available	  �
		   �  Invoked	   : from any time	  �
		   ��������������������������������������Ķ
		   �  Input	   : AX = VendorHandle	  �
		   �		     BL = 0: no CPUID	  �
		   �			  1: use CPUID	  �
		   �		     DX = ResetID	  �
		   �  Output	   : BX = CPUHandle	  �
		   ��������������������������������������Ķ
		   �	   Register Destroyed : BX	  �
		   ��������������������������������������ͼ
		   �


Public			GetCPUHandle
GetCPUHandle		proc	near

	cmp	al,UnknownVendor
	jz	ret_gch			; Vendor/CPU cannot be detected !!
	pusha				; Save all registers
	mov	bp,sp
	mov	cl,bl			; CL = CPUID information
	mov	bx,ax			; BX = VendorHandle
	mul	cs:byte ptr vndr_post_struc_size
	xchg	ax,bx			; AX = VendorHandle, BX = offset in
					; Vendor data base
	call	cs:Vendor_Post_Data_Base[bx].VNDRPSTSTRUC.wMemProc
	mov	word ptr[bp+StackPosBX],ax
	mov	word ptr[bp+StackPosDX],dx
	popa				; Get back regs, return params
ret_gch:
	ret

GetCPUHandle		endp


;---------------------------------------;


Get$Ptr		proc	near
;  input : BH = string#, BL = seting set#
;  output: DX:AX = ptr to string
;  register usage: can destroy any 16-bit register

	mov	si,offset cgroup:cpu_$_start
	mov	cl,bh
	mov	ch,00h			; CX = string#
	jcxz	g$p_00			; 1st string
g$p_01:
	lods	cs:byte ptr [si]
	or	al,al
	jnz	g$p_01
	loop	g$p_01
g$p_00:
	mov	dx,cs
	mov	ax,si
	ret

Get$Ptr		endp

;�����������������������������������������������������������������������������;

		comment �
		��������������������������������������������ͻ
		�		GetVendor@Reset		     �
		��������������������������������������������͹
		�   This routine returns the detected CPU    �
		�   vendor# at reset time.		     �
		��������������������������������������������Ķ
		�   Environment   : Stack available	     �
		�   Invoked	  : at reset		     �
		��������������������������������������������Ķ
		�   Input	  : EDX = ResetID	     �
		�   Output	  : AX  = Vendor#	     �
		��������������������������������������������Ķ
		�   Destroyed: ALL except DS, ES, BP	     �
		��������������������������������������������ͼ
		�
Public	GetVendor@Reset
GetVendor@Reset	proc	near

	mov	si,offset Vendor_Check_Procs
check_other_vendor:
	mov	ax,Intel		; Default VendorHandle
	cmp	si,offset Vendor_Check_Procs_End
	jz	do_init_cpu
	Call	cs:word ptr[si]		; Routine address to check other vendor
	mov	ax,cs:word ptr[si+2]	; AX = VendorHandle
	jz	do_init_cpu
	add	si, sizeof VNDRCHKSTRUC
	jmp	short check_other_vendor
do_init_cpu:
	ret

GetVendor@Reset	endp

		comment �
		��������������������������������������������ͻ
		�		 InitCPU@Reset		     �
		��������������������������������������������͹
		�   This routine initializes the CPU at      �
		�   reset time.  			     �
		��������������������������������������������Ķ
		�   Environment   : No Stack available	     �
		�   Invoked	  : at POST		     �
		��������������������������������������������Ķ
		�   Input	  : EDX = ResetID	     �
		�   Output	  : None		     �
		��������������������������������������������Ķ
		�   Destroyed: EAX, EBX, ECX, ESI, EDI, ESP+ �
		��������������������������������������������ͼ
		�

public	InitCPU@Reset
InitCPU@Reset:

	mov	es,sp
	movzx	ax,cs:byte ptr cpu_vendor; functional cpu vendor#
	cmp	al,UnknownVendor
	jz	ret_icr
	mov	bx,ax
	PushNS	eax			; Save VendorHandle in upper 16 bits
	mov	ax,bx			; AX = vendor handle
	mul	cs:byte ptr vndr_post_struc_size
	mov	bx,ax			; BX = offset in that table
	mov	ax,cs:Vendor_Post_Data_Base[bx].VNDRPSTSTRUC.wRstMemProc
	mov	bx,cs:Vendor_Post_Data_Base[bx].VNDRPSTSTRUC.wRstInitProc
	PushNS	ebx
	CallNS	ax			; Returns: AX = CPUHandle
	mov	bx,ax			; BX = CPUHandle
	ror	ebx,16			; Upper 16 bits = CPUHandle
					; BX = CPU initialization fn address
	CallNS	bx			; InitCPU
ret_icr:
	mov	sp,es			; restore SP
	ret

;-----------------------------------------------------------------------------;

Public	GetHandle
GetHandle:

;  ���������������������������������������������Ŀ
;  � Routine returns CPUHandle			 �
;  � Input : AX = ResetID/CPUID as table entry	 �
;  �	     BX = Family database pointer	 �
;  � Output: AX = CPUHandle, CX = ResetID/CPUID  �
;  � Register destroyed : BX, EDX, CX		 �
;  �						 �
;  � Restriction: NO STACK USAGE		 �
;  �����������������������������������������������


	mov	dx,cs:word ptr[bx]	; DX = end of the structure
	add	bx,sizeof FMLYHDRSTRUC	; Skip header
	mov	cx,bx			; ptr to start of data
next_i_mem:
	cmp	bx,dx			; End of table ?
	jz	fnd_i_mem		; Yes, get latest CPUHandle
	cmp	ax,cs:[bx].FAMILYSTRUC.wHndlID
	jz	fnd_i_mem
	add	bx,sizeof FAMILYSTRUC	; Next field
	jmp	short next_i_mem
fnd_i_mem:
	sub	bx,cx
	mov	cx,ax			; output CX = RESETID/CPUID
	mov	ax,sizeof FAMILYSTRUC
	xchg	ax,bx
	xor	dx,dx
	div	bx			; AX = CPUHandle
	ret


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

