;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1997, American Megatrends Inc.	**;
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
;		DIFFERENT STRUCTURE INIT ROUTINE DURING POST		;
;-----------------------------------------------------------------------;
;			POST_BIOS_INIT					;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the BIOS INFORMATION data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of SMBIOS data structure			;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_bios_init:
	ret
;-----------------------------------------------------------------------;
;			POST_PROCESSOR_INIT				;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the PROCESSOR data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_processor_init:
; find the start of 1st PROCESSOR_INFORMATION_TYPE structure
	mov	bp,0ffffh		; BP =	0 for BSP
					;	n for APn
ppi_01:
; DS:SI = ptr to next available structure
; DS:DI = ptr to end of all structures
	mov	al,PROCESSOR_INFORMATION_TYPE
	call	get_ptr_to_structure	; DS:SI = ptr to first occurence of the concerned structure
					; DS:BX = ptr to immediate next structure
	jnc	short ppi_14		; ok
	jmp	ppi_00			; no structure found
ppi_14:
	inc	bp			; next processor#, 0 = BSP, n = APn
	cld
	push	di
	push	bx
	push	si
	push	bp
	mov	bp,PROCESSOR_INFO_FUNC	; func#
	call	cgroup:dword ptr post_interface_routine; Get processor information (BIOS)
					; ESI = offset:segment BSP structure
					; EDI = offset:segment AP structure
; CL = #of processor installed
	pop	bp
	push	esi
	pop	es
	pop	bx			; ES:BX = ptr to BSP information array
	pop	si			; DS:SI = ptr to start of Processor structure
	or	bp,bp			; BSP ?
	jz	short ppi_02		; yes
; this is an AP, find the ptr to this AP information array
; CL = #of processor installed
	movzx	cx,cl			; CX = #of processor installed (1-based)
	cmp	bp,cx			; valid processor# ?
	jae	short ppi_16		; invalid processor#
	push	bp
	push	edi
	pop	es
	pop	bx			; ES:BX = ptr to next AP information array
ppi_04:
	dec	bp			; BP = AP# (0-based)
	jz	short ppi_03		; NC, ES:BX = ptr to concerned AP information array
	cmp	bx,0ffffh		; end of AP information array ?
	jnz	short ppi_05		; not yet
	mov	ax,es
	cmp	ax,0ffffh		; end of AP information array ?
	stc				; indicate error
	jz	short ppi_03		; yes
ppi_05:
	les	bx,es:dword ptr (APPLCPUHEADERSTRUC ptr [bx]).wNextPtr; ES:BX = ptr to next AP information array
	jmp	short ppi_04
ppi_03:
	pop	bp
	jnc	short ppi_13		; ok
ppi_16:
	pop	bx			; DS:BX = ptr to start of next structure
	pop	di			; DS:DI = ptr to end of all atructures
; DS:SI = ptr to the processor structure which and other processor structures
;	  if present needs to be initialized with default values
ppi_15:
	push	di
	push	bx
%OUT	May need to be updated properly
	mov	al,CPU_UNKNOWN
	mov	ds:byte ptr (PROC_STRUC ptr [si]).bProcType,al
	mov	ds:byte ptr (PROC_STRUC ptr [si]).bProcFamily,al
	xor	eax,eax
	mov	ds:byte ptr (PROC_STRUC ptr [si]).bProcStatus,00h
	mov	ds:dword ptr[si].PROC_STRUC.qProcID,eax
	mov	ds:dword ptr[si+4].PROC_STRUC.qProcID,eax
; clear manufacturer string, version string
	movzx	cx,ds:byte ptr [si].PROC_STRUC.bProcManufacturer; CX = string# for CPU manufacturer
	jcxz	short ppi_17	        ; no string for CPU manufacturer
	push	si
	call	get_string_details	; DS:SI = ptr to concerned string in the structure
					; CX = length of concerned string in the structure
	push	es
	push	ds
	pop	es
	mov	di,si			; ES:DI = ptr to manufacturer string
	mov	al,20h			; clear string with blank
	rep	stosb
	pop	es
	pop     si			; restore pointer to start of Struct
ppi_17:
; fill Processor Version
	movzx	cx,cs:byte ptr [si].PROC_STRUC.bProcVersion; CX = string# for Processor Version
	jcxz	short ppi_18		; no string for CPU version
	push	si
	call	get_string_details	; DS:SI = ptr to concerned string in the structure
					; CX = length of concerned string in the structure
	push	es
	push	ds
	pop	es
	mov	di,si			; ES:DI = ptr to manufacturer string
	mov	al,20h			; clear string with blank
	rep	stosb
	pop	es
	pop	si
ppi_18:
	pop	si			; DS:SI = ptr to next available structure
	pop	di			; DS:DI = ptr to end of all structures
	mov	al,PROCESSOR_INFORMATION_TYPE
	call	get_ptr_to_structure	; DS:SI = ptr to first occurence of the concerned structure
					; DS:BX = ptr to immediate next structure
	jnc	short ppi_15		; init next processor stucture
	jmp	ppi_00			; exit
ppi_13:
; ES:BX = ptr to AP information structure
	add	bx,size APPLCPUHEADERSTRUC
ppi_02:
; ES:BX = ptr to CPU information structure
; DS:SI = ptr to start of Processor structure
; fill Processor manufacturer string
	movzx	cx,ds:byte ptr [si].PROC_STRUC.bProcManufacturer; CX = string# for CPU manufacturer
	jcxz	short ppi_06	        ; no string for CPU manufacturer
	push	si
	call	get_string_details	; DS:SI = ptr to concerned string in the structure
					; CX = length of concerned string in the structure
	push	es
	push	ds
	mov	di,si
	mov	si,es:word ptr[bx].CPUINFOSTRUC.dVndr$Ptr
	mov	ax,es:word ptr[bx+2].CPUINFOSTRUC.dVndr$Ptr; AX:SI = BIOS vendor str
	push	ds
	pop	es			; ES:DI = ptr to destn string
	mov	ds,ax			; DS:SI = ptr to source string
	call	copy_string
	pop	ds
	pop	es			; ES:BX = CPU Info struc ptr
        pop     si			; restore pointer to start of Struct
ppi_06:
; ES:BX = ptr to CPU information structure
; DS:SI = ptr to start of Processor structure
; fill Processor Version
	movzx	cx,ds:byte ptr [si].PROC_STRUC.bProcVersion; CX = string# for Processor Version
	jcxz	short ppi_07		; no string for CPU version
	push	si
	call	get_string_details	; DS:SI = ptr to concerned string in the structure
					; CX = length of concerned string in the structure
	push	es
	push	ds
	mov	di,si
	mov	si,es:word ptr[bx].CPUINFOSTRUC.d$Ptr
	mov	ax,es:word ptr[bx+2].CPUINFOSTRUC.d$Ptr
	push	ds
	pop	es
	mov	ds,ax
	call	copy_string
	pop	ds
	pop	es
	pop	si
ppi_07:
; ES:BX = ptr to CPU information structure
; DS:SI = ptr to start of Processor structure
; fill Processor ID
	mov	eax,es:dword ptr [bx].CPUINFOSTRUC.dResetID
	mov	ds:dword ptr[si].PROC_STRUC.qProcID,eax
	mov	eax,es:dword ptr [bx].CPUINFOSTRUC.dFeature
	mov	ds:dword ptr[si+4].PROC_STRUC.qProcID,eax
; ES:BX = ptr to CPU information structure
; DS:SI = ptr to start of Processor structure
; fill Processor Family
	mov	ax,CPU_UNKNOWN*256+CPU_UNKNOWN	; value for Unknown
	mov	cl,es:byte ptr (CPUINFOSTRUC ptr [bx]).bVndrNum; Vendor#
	cmp	cl,0ffh			; unknown vendor# ?
	jz	short ppi_08		; unknown vendor
	cmp	es:byte ptr (CPUINFOSTRUC ptr [bx]).bNum,0ffh; unknown CPU# ?
	jz	short ppi_08		; unknown vendor and unknown CPU
; vendor and CPU is known
	movzx	di,cl			; DI = Vendor#
	shl	di,1			; DI = offset in the Generation Map Table
	mov	di,cs:[_Generation_Map+di]; DI = ptr to genaration table for the concerned Vendor
	mov	ax,es:word ptr (CPUINFOSTRUC ptr [bx]).wFuncField; Function Field
	and	ax,0e00h		; Seperate Generation code
	shr	ax,9			; AX = Generation Code = offset in the Generation Map Table
	add	di,ax			; DI = offset in Generation map table
	mov	ah,cs:byte ptr [di]	; get processor family
	mov	al,CPU_CENTRAL_PROCESSOR; processor type
ppi_08:
	mov	ds:[si].PROC_STRUC.bProcFamily,ah
	mov	ds:[si].PROC_STRUC.bProcType,al
; Fill Clock information details
	push	bp
	mov	bp,CPU_CLOCK_DETAILS_FUNC	; func#
	call	cgroup:dword ptr post_interface_routine; AX = CPU clock, BX = External Clock
	pop	bp
	mov	ds:[si].PROC_STRUC.wCurrentSpeed,ax
	mov	ds:[si].PROC_STRUC.wExternalClock,bx
; Fill Processor Status
	mov	ds:byte ptr (PROC_STRUC ptr [si]).bProcStatus,41h
					; Bit-6 = 1....socket populated
					; Bit2-0= 001..CPU Enabled
	pop	si			; DS:SI = ptr to start of next structure
	pop	di			; DS:DI = ptr to end of all atructures
	jmp	ppi_01			; continue for next Processor structure
ppi_00:
	ret
;-----------------------------------------------------------------------;
;			POST_MEMORY_CONTROLLER_INIT			;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the MEMORY CONTROLLER data structure.				;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	DMI data structure initialized					;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_memory_controller_init:
	ret
;-----------------------------------------------------------------------;
;			POST_MEMORY_MODULE_INIT				;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the MEMORY MODULE data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_memory_module_init:
	xor	bp,bp				; BP = memory module# (1-based)
; find the start of MEMORY_MODULE_INFORMATION_TYPE structure
pmmi_02:
; DS:SI = ptr to next available structure
; DS:DI = ptr to end of all structures
	inc	bp				; next memory module#
	mov	al,MEMORY_MODULE_INFORMATION_TYPE
	call	get_ptr_to_structure		; DS:SI = ptr to first occurence of the concerned structure
						; DS:BX = ptr to immediate next structure
        jc      short pmmi_00                   ; no (more) structure found
	push	di
	push	bx
	push	bp
	mov	ax,bp				; AX = AL =  memory module# (1 based)
	mov	bp,MEMORY_MODULE_INFO_FUNC	; BP = function#
	call	cgroup:dword ptr post_interface_routine
	pop	bp
        jc      short pmmi_01			; error
; AL : Bank Connection
; AH : Current Speed
; CX : Current Memory Type
; BL : Installed Size				
;	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bBankCon,al
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bCurrentSpd,ah
	mov	ds:word ptr (MEMMOD_INFO_STRUC ptr [si]).wCurrentMemType,cx
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bInstSize,bl
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bEnabledSize,bl
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bErrStatus,00h
	pop	si				; DS:SI = ptr to next structure
	pop	di				; DS:DI = ptr to end of all structures
	jmp	short pmmi_02			; go to check next structure
pmmi_01:
	pop	bx				; DS:BX = ptr to next structure
	pop	di				; DS:DI = ptr to end of all structures
pmmi_03:
; CS:SI = ptr to current memory module structure which and other memory module
;	  stuctures (if present) need to be initialized with default values
	push	di
	push	bx
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bBankCon,MM_NO_BANK_CONNECTION
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bCurrentSpd,MM_SPEED_UNKNOWN
	mov	ds:word ptr (MEMMOD_INFO_STRUC ptr [si]).wCurrentMemType,MM_TYPE_UNKNOWN
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bInstSize,MM_NOT_INSTALLED
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bEnabledSize,MM_NOT_ENABLED
	mov	ds:byte ptr (MEMMOD_INFO_STRUC ptr [si]).bErrStatus,00h
	pop	si				; DS:SI = ptr to next structure
	pop	di				; DS:DI = ptr to end of all structures
	mov	al,MEMORY_MODULE_INFORMATION_TYPE
	call	get_ptr_to_structure		; DS:SI = ptr to first occurence of the concerned structure
						; DS:BX = ptr to immediate next structure
        jnc     short pmmi_03                   ; init next structure
pmmi_00:
	ret
;-----------------------------------------------------------------------;
;			POST_EXTERNAL_CACHE_INIT			;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the external CACHE data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_external_cache_init:
peci_02:
; DS:SI = ptr to nest available structure
; DS:DI = ptr to end of all structures
	mov	al,CACHE_INFORMATION_TYPE
	call	get_ptr_to_structure	; DS:SI = ptr to the concerned structure
					; DS:BX = ptr to immediate next structure
	jc	short peci_00		; no more structure found
	push	di
	push	bx
	mov	al,ds:byte ptr (CACHE_INFO_STRUC ptr [si]).wCacheConfig; get config
	shr	al,05h			; bit6-5 -> bit1-0
	and	al,03h
	cmp	al,01h			; external cache ?
;	jnz	short peci_03		; no, so no need to init this structure
	jz	short peci_05
        mov     eax,cr0
        test    eax,40000000h           ; is cache enabled?
        jz      short peci_03		; Yes, Skip
; Set Cache Disable
	and	ds:byte ptr (CACHE_INFO_STRUC ptr [si]).wCacheConfig, NOT 80h
; Set Cache Operation Mode Unknow
	or	ds:word ptr (CACHE_INFO_STRUC ptr [si]).wCacheConfig, 300h
        jmp     short peci_03		
peci_05:

	mov	bp,EXT_CACHE_INFO_FUNC	; BP = function#
	call	cgroup:dword ptr post_interface_routine
;  AX = installed cache size (KB), 40h = 64KB, 200h = 512KB
;  CX = current cache configuration
;	bit15-10= reserved (must be 0)
;	bit9-8= cache mode
;		00 -> write-through, 01 -> write-back
;		10 -> reserved,      11 -> unknown
;	bit-7 = current status
;		0 -> disabled, 1 -> enabled
;	bit6-5= physical position relative to CPU
;		00 -> inside CPU, 01 -> outside CPU
;		10 -> reserved, 11 -> unknown
;	bit-4 = reserved (must be 0)
;	bit-3 = socket information
;		0 = not socketed, 1 = socketed
;	bit-2..0 = cache level (1 to 8), 1 = L1, 2 = L2
;  DX = current cache type (bit mapped)
;	bit15-7......reserved (must be 0)
;	bit-6 = 1 -> asynchronous
;	bit-5 = 1 -> synchronous
;	bit-4 = 1 -> pipeline burst
;	bit-3 = 1 -> burst
;	bit-2 = 1 -> non-burst
;	bit-1 = 1 -> unknown
;	bit-0 = 1 -> reserved (must be 0)
;  BH = cache speed in nanosecs
;	e.g. BH = 28h -> 40ns (0 if unknown)
;  BL = error correction type
;	01 -> Other		02 -> Unknown		03 -> None
;	04 -> Parity		05 -> Single Bit ECC	06 -> MultiBit ECC
;  DI	Bit15-8..System Cache Type
;	01 -> Other		02 -> Unknown		03 -> Instruction
;	04 -> Data		05 -> Unified
;  DI	Bit7-0...Associativity
;	01 -> Other		02 -> Unknown		03 -> Direct Mapped
;	04 -> 2way Set Assoc	05 -> 4way Set Assoc	06 -> Fully Assoc
	jnc	short peci_01		; ok
	xor	ax,ax			; force external cache size = 00
	mov	cx,000000110110000b	; make cache config unknown
	mov	dx,02h			; make cache type unknown
peci_01:
	mov	ds:word ptr (CACHE_INFO_STRUC ptr [si]).wCurrentType,dx
	and	cl,98h			; discard bit6-5, bit2-0
	or	cl,cgroup:byte ptr external_cache_level
	mov	ds:word ptr (CACHE_INFO_STRUC ptr [si]).wCacheConfig,cx
;  AX = installed size in unit of KB
;  check the granularity of maximum cache size field
	test	ds:word ptr (CACHE_INFO_STRUC ptr [si]).wMaxCacheSize,8000h; Bit15 = 0/1 -> 1KB/64KB granularity ?
	jz	short peci_04		; 1KB granularity
;  maximum cache size is in 64KB granularity, make the installed cache size
;  also of 64KB granularity
	shr	ax,6			; AX = installed cache size in unit of 64KB
	or	ax,8000h		; make Bit15 = 1 to indicate 64KB granularity
peci_04:
	mov	ds:word ptr (CACHE_INFO_STRUC ptr [si]).wInstSize,ax
;---------------------------------------;
if	DMI_VER				; SMBIOS 2.1 Specfication
	mov	ds:byte ptr (CACHE_INFO_STRUC ptr [si]).bCacheSpd,bh
	mov	ds:byte ptr (CACHE_INFO_STRUC ptr [si]).bErrType,bl
	mov	ax,di
	mov	ds:byte ptr (CACHE_INFO_STRUC ptr [si]).bSysCacheType,ah
	mov	ds:byte ptr (CACHE_INFO_STRUC ptr [si]).bAssociativity,al
endif
;---------------------------------------;
peci_03:
	pop	si			; DS:SI = ptr to next structure
	pop	di			; DS:DI = ptr to end of structures
	jmp	short peci_02		; continue for all structures
peci_00:
	ret
;-----------------------------------------------------------------------;
;			POST_SYSTEM_SLOT_INIT				;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the SYSTEM SLOT data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_system_slot_init:
; find the start of 1st slot structure
pssi_01:
; DS:SI = ptr to next available structure
; DS:DI = ptr to end of all structures
	mov	al,SYSTEM_SLOT_INFORMATION_TYPE; Slot Information structure type
	call	get_ptr_to_structure	; DS:SI = ptr to first occurence of the concerned structure
					; DS:BX = ptr to immediate next structure
	jc	short pssi_00		; no more structure found
	push	di
	push	bx
	cmp	ds:byte ptr (SYSTEM_SLOT_INFO_STRUC ptr [si]).bSlotType,SYS_SLOT_AGP_2X; AGP Slot ?
	jnz	short pssi_04		; no, so set curr usage as Unknown
	mov	bx,0010h		; AGP Controller
        mov     di, 3eh			; PCI-PCI Bridge Control Register
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION                ; CL=Value
	test	cl,08h			; Check VGA Enable Bit
	jmp	short pssi_05
pssi_04:
	cmp	ds:byte ptr (SYSTEM_SLOT_INFO_STRUC ptr [si]).bSlotType,SYS_SLOT_PCI; PCI Slot ?
	jnz	short pssi_03		; no, so set curr usage as Unknown
	mov	ax,ds:word ptr (SYSTEM_SLOT_INFO_STRUC ptr [si]).wSlotId; AL = PCI physical slot#
	mov	ah,RT_PCI_SLOT_TO_DEV
	CALL_RT_FUNCTION		; BX = bus#/dev#/func#
	jc	short pssi_03		; error, so set curr usage as Unknown
	mov	di,PCI_REG_VENDID
	mov	ah,RT_PCI_READ_CFG_DWORD
	CALL_RT_FUNCTION		; ECX = VendorID & DeviceID
	jc	short pssi_03		; error, so set curr usage as Unknown
;	cmp	ecx,0ffffffffh		; valid VendorID & DeviceID
	inc	ecx
pssi_05:
	mov	al,SCU_IN_USE		; value for "In Use" usage
	jnz	short pssi_02		; valid VendorID & DeviceID, set curr usage as In Use
	mov	al,SCU_AVAILABLE	; value for "Available" usage
pssi_02:
	mov	ds:byte ptr (SYSTEM_SLOT_INFO_STRUC ptr [si]).bCurrentUsage,al; put curr usage
	pop	si			; DS:SI = ptr to next structure
	pop	di			; DS:DI = ptr to end of all structures
	jmp	short pssi_01		; continue for all slot structures
pssi_03:
	mov	al,SCU_UNKNOWN		; value for "Unknown" usage
	jmp	short pssi_02
pssi_00:
	ret
;-----------------------------------------------------------------------;
;			POST_ONBOARD_DEVICE_INIT			;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the ONBOARD DEVICES data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_onboard_device_init:
podi_02:
; DS:SI = ptr to nest available structure
; DS:DI = ptr to end of all structures
	mov	al,ONBOARD_DEVICE_INFORMATION_TYPE
	call	get_ptr_to_structure	; DS:SI = ptr to the concerned structure
					; DS:BX = ptr to immediate next structure
	jc	short podi_00		; no more structure found
	push	di
	push	bx
	mov	bp,ONBOARD_DEVICE_INFO_FUNC; BP = function#
	call	cgroup:dword ptr post_interface_routine; AL = 00/01, disabled/enabled
	jnc	short podi_01		; ok
	xor	al,al			; force it to indicate disabled
podi_01:
	shl	al,07h			; Bit-7 = disable/enable information
	or	ds:byte ptr (ONBOARD_DEVICE_STRUC ptr [si]).bDeviceType,al
	pop	si			; DS:SI = ptr to next structure
	pop	di			; DS:DI = ptr to end of structures
	jmp	short podi_02		; continue for all structures
podi_00:
	ret
;-----------------------------------------------------------------------;
;			POST_BIOS_LANGUAGE_INIT				;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the BIOS LANGUAGE data structure.					;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_bios_language_init:
	mov	al,BIOS_LANGUAGE_INFORMATION_TYPE
	call	get_ptr_to_structure		; DS:SI = ptr to first occurence of the concerned structure
						; DS:BX = ptr to immediate next structure
        jc      short pbli_00                   ; no (more) structure found
	mov	bp,BIOS_LANGUAGE_INFO_FUNC	; bp = func#
	call	cgroup:dword ptr post_interface_routine; ES:DI = ptr to current language string
; ES:DI = ptr to current language string
; DS:SI = ptr to structure
	movzx	cx,ds:byte ptr (BIOS_LANGUAGE_INFO_STRUC ptr [si]).bInstallableLang; CX = #of available languages
pbli_01:
	push	di
	push	si
	push	cx
	call	get_string_details		; DS:SI = ptr to concerned string
						; CX = string length in bytes excluding NULL
; ES:DI = ptr to installed language string
; DS:SI = ptr to current string in structure
; CX	= length of string in the structure
	repz	cmps ds:byte ptr [si],es:byte ptr [di]
	pop	cx
	pop	si
	pop	di
	jz	short pbli_02			; match, CX = string#
	loop	pbli_01
pbli_02:
; CL = CX = String# corresponding to installed language
;	    (0000 -> language string does not exist)
	mov	ds:byte ptr (BIOS_LANGUAGE_INFO_STRUC ptr [si]).bCurrentLang,cl; init curr language string#
pbli_00:
	ret
if MKF_EVENT_LOG				; (CORE0218+)>
	include	event.equ
;-----------------------------------------------------------------------;
;			POST_EVENT_LOG_INIT				;
;-----------------------------------------------------------------------;
;  this routine is called from SMBPOST INIT code to initialize/build	;
;  the EVENT LOG data structure from LOG_BUFFER_SEG:0000		;
;  input :								;
;	DS:SI	ptr to start of SMBIOS data structure			;
;	DS:DI	ptr to end of all structures				;
;	CS = ES								;
;	stack	available						;
;  output:								;
;	SMBIOS data structure initialized				;
;  register usage : can destroy any register except DS, ES		;
;-----------------------------------------------------------------------;
post_event_log_init:
	mov	al,SYSTEM_EVENT_LOG_TYPE
	call	get_ptr_to_structure		; DS:SI = ptr to first occurence of the concerned structure
						; DS:BX = ptr to immediate next structure
        jc      short peli_00                   ; no (more) structure found
	push	es
	push	LOG_BUFFER_SEG		; uncom_segment
	pop	es
	xor	di,di			; offset zero, buffer start point
	mov	al,(LOG_BUFFER ptr es:[di]).log_capacity
	shl	al,1			; bit1 = log area capacity
	or	al,(LOG_BUFFER ptr es:[di]).log_validity; bit0 = log area validity
	mov	(EVENTLOG_INFO_STRUC ptr ds:[si]).bLogStatus,al
	mov	eax,(LOG_BUFFER ptr es:[di]).change_token
	mov	(EVENTLOG_INFO_STRUC ptr ds:[si]).dLogChangeToken,eax
	movzx	eax,(LOG_BUFFER ptr es:[di]).gpnv_handle
	mov	(EVENTLOG_INFO_STRUC ptr ds:[si]).dAccessMethodAdd,eax
	pop	es
peli_00:
	ret
endif ;MKF_EVENT_LOG				; <(CORE0218+)
	
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1997, American Megatrends Inc.	**;
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
;			GET_PTR_TO_STRUCTURE				;
;  this routine copies the source string to the destn taking into	;
;  account of the length available, padding it with blanks if needed,	;
;  etc.									;
;  input :								;
;	DS:SI	ptr to the start of structure				;
;	DS:DI	ptr to the end of structure				;
;	AL	concerned structure type				;
;  output:								;
;	CY	structure not found					;
;	NC	structure found						;
;		DS:SI	ptr to concerned structure			;
;		DS:BX	ptr to next structure				;
;  registed destroyed : SI						;
;-----------------------------------------------------------------------;
get_ptr_to_structure:
gpts_01:
	cmp	al,ds:(DMIHDR_STRUC ptr [si]).bType; type match ?
	pushf
	push	cx
	call	GetStrucLen			; CX = curr structure len
	mov	bx,cx				; curr structure length
	pop	cx
	popf
	jz	short gpts_00			; yes, this is the structure
	add	si,bx				; skip this structure
	cmp	si,di				; end of structure reached ?
	jb	short gpts_01			; not yet
	stc					; end reached, structure not found
	jmp	short gpts_02
gpts_00:
	add	bx,si				; CS:BX = ptr to next structure
	clc
gpts_02:
	ret
;-----------------------------------------------------------------------;
;	TABLES USED IN PROCESSOR INFORMATION STRUCTURE INIT		;
;-----------------------------------------------------------------------;
_Intel_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	05h		; 00
		db	06h		; 01
		db	0bh		; 02
		db	0ch		; 03

_Cyrix_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	05h		; 00
		db	06h		; 01
		db	06h		; 02
		db	0bh		; 03
		db	06h		; 04

_AMD_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	05h		; 00
		db	06h		; 01

_IBM_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	05h		; 00
		db	05h		; 01
		db	06h		; 02

_TI_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	05h		; 00
		db	02h		; 01
		db	06h		; 02

_UMC_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	02h		; 00
		db	06h		; 01

_SGSTh_Generation_Map:
;					;------- OUR GENERATION CODE --------
		db	02h		; 00
		db	02h		; 01
		db	06h		; 02

;-----------------------------------------------------------------------------;
_Generation_Map:
	dw	offset _Intel_Generation_Map
	dw	offset _Cyrix_Generation_Map
	dw	offset _AMD_Generation_Map
	dw	offset _IBM_Generation_Map
	dw	offset _TI_Generation_Map
	dw	offset _UMC_Generation_Map
	dw	offset _SGSTh_Generation_Map
;-----------------------------------------------------------------------;
