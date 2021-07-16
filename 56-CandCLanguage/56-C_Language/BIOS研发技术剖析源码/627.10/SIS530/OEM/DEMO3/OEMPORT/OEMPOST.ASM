        page    ,132
        title   OEM POST HOOKS
;-----------------------------------------------------------------------;
; This file is derived from POST.ASM and NPOST.ASM files.               ;
; ======================== NOTE === NOTE === NOTE ===================== ;
; If the routine name in this file starts with "OEM_", then this routine;
; is called from the corresponding generic chipset hook (in POST.ASM or ;
; NPOST.ASM file). For example, OEM_DO_MEMORY_SIZE routine is called    ;
; from DO_MEMORY_SIZE hook in POST.ASM file.                            ;
; ======================== NOTE === NOTE === NOTE ===================== ;
; If the routine name in this file does not start with "OEM_", then this;
; routine is called directly from Core file. For example, BEFORE_VECTOR ;
; is called from core file RM.ASM.                                      ;
;-----------------------------------------------------------------------;
; NOTE: Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.   ;
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1996, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-246-8600.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
; $Header: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/oempost.asm 4     9/19/97 3:43p Juand $
;
; $Revision: 4 $
;
; $Date: 9/19/97 3:43p $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/oempost.asm $
; 
; (CORE0228) James Tue 06-01-1999
; * DC.ASM + DEVINFO.ASM = module to create more room for POST+RUNTIME
; - dc_oem_arrangement is using equates instead of offset.
; - Any OEM routine used to display is put to
;   dc_oem_routines_table and the equate should start
;   from dc_oem_index_start.  See the example.
; - Must use display_dc_colon to display string "xxxx :" in OEM
;   display routine.
; see DC.ASM DC.EQU+ GS1.ASM PI.ASM PI.EQU JMP.ASM
;     ME5.ASM ME5.EQU+
;     DEVINFO.ASM OEMPOST.ASM
;     DC.MAK+ CORE.MAK BIOS.MAK OBJ.MAK
;
; (CORE0218) James Fri 02-26-1999
; Build event logs in buffer at LOG_BUFFER_SEG:0000 before
; running Setup.
;
; (CORE0206) James Tue 01-19-1999
; Added sc_items_table for customizing system configuration screen.
; You can add or arrange any item from that split screen.
;
; 4     9/19/97 3:43p Juand
; Added programming of Search DMA Resources in cp_init setup table.
;
; 3     9/18/97 7:09p Juand
;
; 2     9/16/97 11:23a Juand
; Enabled IRQ8# signal in PIIX4 reg B1h
;
; 1     9/15/97 5:57p Juand
;
; 1     9/11/97 6:41p Juand
;
; 1     6/05/97 12:43p Debkumar
;
; 5     5/20/97 5:03p Debkumar
; Beep is removed from CHANGE_DISPLAY_TO_OEM routine to make it silent.
;
; 4     3/14/97 9:52a Debkumar
; OEM_INIT_SILENT_BOOT, OEM_DYNAMIC_SILENT_BOOT_DISPLAY hooks are added
; to allow OEM to display any dynamic information durin OEM display mode.
;
; 3     3/12/97 4:01p Debkumar
; Hooks for Silent Boot added.
;
; 2     2/04/97 3:09p Debkumar
; GET_HD_STANDBY_VALUE routines for PM,PS,SM,SS moved to OEMRUN.ASM file
; from OEMPOST.ASM file.
;
; 1     1/31/97 1:15p Debkumar
; New files for 62700.
;
; 1     1/13/97 2:22p Debkumar
; New file for 6.27.00.
;
;*****************************************************************;
;---------------------------------------;
        include mbiosmac.mac
        include mbiosequ.equ
        include cf.equ
        include setupequ.ext
        include makeflag.equ
;---------------------------------------;
	include rt.equ
        include pci.equ
        include escd.equ
        include dim.equ
        include dim.dat
	include sis530.equ
;---------------------------------------;
        extrn   check_cmos_data:near
        extrn   check_cmos_8e:near
        extrn   disable_l1_cache:near
        extrn   enable_l1_cache:near
        extrn   cmos_data_in_x:near
        extrn   cmos_data_out_x:near

        extrn   get_cmos_item:near
	extrn	read_sio_byte:near
	extrn	write_sio_byte:near
	extrn	read_bri_byte:near
	extrn	write_bri_byte:near
	extrn	read_pci_byte:near
	extrn	write_pci_byte:near

;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _OEMPOST_STARTS
_OEMPOST_STARTS label   byte            ; marks start of module
;-----------------------------------------------------------------------;
;               THE HOOKS ARE IN ORDER OF EXECUTION                     ;
;-----------------------------------------------------------------------;
;                       INIT_AFTER_KB_BAT                               ;
;-----------------------------------------------------------------------;
; check_point           : 0E                                            ;
; This routine can be used if any special work involved after BAT command
; to 8042 keyboard controller is successful in RM.ASM. The special work ;
; can be many things. e.g. auto-sensing of external keyboard & mouse    ;
; mostly used in laptop, etc.                                           ;
; input:                                                                ;
;       DS      0000H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage -- can destroy any register except BP, DS, ES          ;
;-----------------------------------------------------------------------;
init_after_kb_bat       proc    near
if      MKF_KB_PS2_CONNECTOR_SWAP
        extrn   auto_detect_kb_ms:near
        call    auto_detect_kb_ms
endif
        ret
init_after_kb_bat       endp
;-----------------------------------------------------------------------;
;                         OEM_DETECT_L2_CACHE                           ;
;-----------------------------------------------------------------------;
; check_point           : 13                                            ;
; This routine is called from CP_INIT (POST.ASM) after chipset register ;
; initialization and L2 cache sizing is done.                           ;
; This routine can be used to override the result of L2 cache sizing    ;
; and testing done in CP_INIT. For example, if OEM motherboard always   ;
; has fixed L2 cache (e.g. 512K, as is the case with most Notebooks),   ;
; then L2 cache sizing code can be renoved (which will create some space;
; for some other thing) and L2 cache registers can be programmed with   ;
; fixed L2 cache size. Of course L2 cache testing must be done in either;
; case.                                                                 ;
; Note : Another way is not to do the L2 cache sizing and testing in    ;
;        POST.ASM. Do the L2 cache sizing/testing here according to the ;
;        requirement. In that case, the deafult code here must do the   ;
;        L2 cache sizing and testing. And then the deafult code can be  ;
;        modified according to OEM requirement.                         ;
; input :                                                               ;
;       DS      0000H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       BL      bit-0 = 0 cache is bad                                  ;
;                       1 cache is good                                 ;
;               bit7-1= MUST BE returned as 0                           ;
; register usage -- can destroy any register except EBP,DS,ES,FS,GS     ;
; Note: 1. this routine is called from at the end of CP_INIT in POST.ASM;
;       2. this routine should do cache sizing and testing. Use the     ;
;       routines GO_TO_FLAT_MODE_STACK and COMEBACK_FROM_FLAT_MODE_STACK;
;       for going to and coming back from flat mode.                    ;
;       3. if the board has fixed cache size, then do not do the cache  ;
;       sizing (this is the case in almost all Notebooks, it will save  ;
;       a lot of space), do only the testing.                           ;
;-----------------------------------------------------------------------;
        public  oem_detect_l2_cache
oem_detect_l2_cache:
	pushf					; Save Interrupt Flag
	call	open_extend_cmos

;; Calculate checksum
	sub	dx,dx
	mov	cx,6
	mov	ah,90h
@@:
	mov	al,ah
	call	cmos_data_in_x
	or	al,al
	jz	@f
	add	dl,al
	adc	dh,0
	inc	ah
	loop	@b
@@:
	cmp	ah,90h			; first byte is zero?
	jz	keypass_disable

	mov	ax,08e8fh
	call	cmos_data_in_x
	xchg	al,ah
	call	cmos_data_in_x
	cmp	ax,dx
	jnz	keypass_disable

;; Load CMOS Password to Keyboard
	mov	al,0a5h				;  set keyboard pass
	extrn	write_key_board_command:near
	call	write_key_board_command
	mov	ah,90h
	mov	cx,06h
load_cmos_to_key:
	mov	al,ah
	call	cmos_data_in_x
	inc	ah
	or	al,al
	jz	save_in_key_over
	extrn	write_key_board_data:near
	call	write_key_board_data
	loop	load_cmos_to_key
save_in_key_over:
	xor	al,al
	call	write_key_board_data
	
	call	close_extend_cmos
	
	call	open_apc_cmos

	mov	ax,8383h		    	; APC Register 03h
	call	cmos_data_in_x
	test	al,80h				; Power Lost?
	jz 	normal_path     
	and	al,not 80h			; Disabled Power Button
	xchg	ah,al			    
	call	cmos_data_out_x

	mov	ax,8585h		      	; APC Register 05h 
	call	cmos_data_in_x
	or	al,040h			    	; Enabled Keyboard Password
	xchg	ah,al			    
	call	cmos_data_out_x

	call	close_apc_cmos

	mov	al,34h				; Power Off
        mov     dx,MKF_PM_BASE_ADDRESS+5 	
	out	dx,al				 
	jmp	short $

keypass_disable:
	call	close_extend_cmos
;	call	open_apc_cmos
;	mov	ax,8383h		    	; APC Register 03h
;	call	cmos_data_in_x
;	or	al,80h	       			; Enable Power Button
;	xchg	al,ah
;	call	cmos_data_out_x

normal_path:

	call	close_apc_cmos

	popf					; Restore Interrupt Flag 

COMMENT ~
;; Clock Generator ICS 9248-59
;	mov	al,Q_CLKGEN_PCI_DIMM
;	call	get_cmos_item
;; PaiLin debug {
;	mov	bx,0ffffh			; BL = Byte 3 / BH = Byte 4 
;; } PaiLin debug
;;      jz      check_dimm_done


       mov     di,0f000h

       mov     bh,1
        mov     si,offset cgroup:row2bankconvert
start_row:
       mov     al,bh
       call    dmi_mem_module_info
       cmp     bl,7fh
       jz      next_row2bank
       sub     ax,ax
       mov     cx,4
@@:
        db      02eh
        lodsb
        bts     di,ax
       loop    @b
       jmp     short row_end
next_row2bank:
       add     si,4
row_end:
       inc     bh
       cmp     bh,4                            ; 3 DIMM
        jnz     start_row

       mov     bx,di                           ; BL = Byte 3

check_dimm_done:

	mov	al,Q_SPREAD_SPECTRUM
	call	get_cmos_item
	mov	cl,00000000b		; Spread Spectrum Enabled (ICS)
	jz	short spread_function_disable
	mov	cl,00000010b		; Spread Spectrum Disabled (ICS)
	dec	al
	shl	al,7			; to position
	or	cl,al			; set it
spread_function_disable:

	mov	al,Q_FREQ_SELECT
	call	get_cmos_item
	jz	short hardware_select_freq
	or	cl,00001000b
hardware_select_freq:

	mov	al,Q_CPU_FREQ
	call	get_cmos_item
	cmp	al,8
	jb	short asyn_mode
	or	cl,00000100b
asyn_mode:
	and	al,not 08h
	shl	al,4
	or	cl,al

;; PaiLin debug {
;;      mov     al,Q_CLKGEN_PCI_DIMM
;;      call    get_cmos_item
;;      mov     ch,11111111b            ; Ch = Byte 2
;;      jz      slot3_done 
;       mov     ch,11111000b            ; PCICLK_F/PCI4/PCI3 Always used.
;;; Check PCI Slot use or not
;       mov     dx,0048h
;       call    read_pci_slot
;       jz      slot1_done
;       or      ch,00000001b
;slot1_done:
;       add     dl,10h
;       call    read_pci_slot
;       jz      slot2_done
;       or      ch,00000010b
;slot2_done:
;       add     dl,10h
;       call    read_pci_slot
;       jz      slot3_done
;       or      ch,00000100b
;slot3_done:
;; } PaiLin debug

;; Program ICS 9248-59

;Reset Host Status Register 
	mov	ax,0107h			; Clear Status High Byte
	call	write_smbus_reg
	mov	ax,00f0h			; Clear Status Low Byte
	call	write_smbus_reg

;Clock generator address = D2h 
	mov	ax,04d2h
	call	write_smbus_reg

;Command byte = 0
	mov	ax,0500h
	call	write_smbus_reg

;Number of bytes to program 
	mov	ax,0706h		;Data Count = 6 
	call	write_smbus_reg

	mov	al,cl			; Byte 0 
	mov	ah,08h
	call	write_smbus_reg

	mov	ax,09ffh		; Byte 1   
	call	write_smbus_reg

;	mov	al,ch			; Byte 2
	mov	al,0ffh			; always on
	mov	ah,0ah			; PCI Clock
	call	write_smbus_reg

	mov	al,bl			; SDRAM Clock
	mov	ah,0bh			; (Byte 3) 
	call	write_smbus_reg

	mov	al,bh			; SDRAM Clock
	mov	ah,0ch			; (Byte 4) 
	call	write_smbus_reg

	mov	ax,0dffh		; Byte 5
	call	write_smbus_reg

	mov	ax,021ah		; Start Block Write
	call	write_smbus_reg

	mov	cx,13333
	extrn	fixed_delay:near
	call	fixed_delay
~

;; PaiLin debug {
;; for system Fan
        mov     dx,MKF_LM78_BASE_ADDRESS
	mov	al,47h
	out	dx,al
	jmp	short $+2
	inc	dx
	in	al,dx
	jmp	short $+2
	or	al,030h
	jmp	short $+2
	out	dx,al
;; } PaiLin debug

        ret
COMMENT ~
read_pci_slot:
	push	dx
	xchg	dl,dh
	movzx	eax,dx
	bts	eax,31
	mov	dx,0cf8h
	out	dx,eax
	jcxz	short $+2
	mov	dl,0fch
	in	eax,dx
	inc	eax
	pop	dx
	ret
~

row2bankconvert label byte
        db      0,1,2,3         ; DIMM 0
        db      4,5,6,7         ; DIMM 1
        db      8,9,10,11       ; DIMM 2

write_smbus_reg proc near
;; Input:
;; AH = SMBus Register Index
;; AL = Write Value
;; Modified: None							       ;
	push	dx
	mov	dx,MKF_PM_BASE_ADDRESS+38h
	xchg	al,ah
	out	dx,al
	jcxz	short $+2
	jcxz	short $+2
	inc	dx
	xchg	al,ah
	out	dx,al
	pop	dx
	ret
write_smbus_reg endp
;-----------------------------------------------------------------------;
;                               BEFORE_VECTOR                           ;
;-----------------------------------------------------------------------;
; check_point           : 24                                            ;
; This routine ia called from RM.ASM and can be used for any init before;
; interrupt vector table is initialised by BIOS after base 64k memory   ;
; test is passed.                                                       ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   cpu_freq:word
        extrn   cpu_freq_x100:word
	extrn	cpu_clock		:near
	extrn	CatProcPRating		:near
        extrn   rt_cmos_byte:byte
        public  before_vector
before_vector:

        cmp     cgroup:word ptr cpu_freq,0ffffh
        jnz     bv_00                   ; cpu clock already executed
IF      MKF_BUP6
        call    p6_cpu_clock            ; find P6 CPU clock
ELSE
        call    cpu_clock               ; find CPU clock
bv_01:
ENDIF
; AX = CPU clock in MHZ, BX = CPU Clock x 100 in MHz
        mov     cgroup:cpu_freq,ax
        mov     cgroup:cpu_freq_x100,bx
bv_00:
IFE      MKF_BUP6
; prepare string for display P-Rating  needed for CYRIX and AMD.
; this routine must be here before "RET"
	call	CatProcPRating
endif

        ret
	public	pci_irq_avail_table
pci_irq_avail_table	label byte
if	MKF_ITE8661
	db	Q_IT8661F_COMB_PORT , 3
	db	Q_IT8661F_LPT_PORT , 7
	db	Q_IT8661F_COMA_PORT , 4
	db	Q_IT8661F_FLOPPY_CONTROLLER , 6
endif
if	MKF_WIN877
	db	Q_WIN877_COMB_PORT , 3
	db	Q_WIN877_LPT_PORT , 7
	db	Q_WIN877_COMA_PORT , 4
	db	Q_WIN877_FLOPPY_CONTROLLER , 6
endif
;-----------------------------------------------------------------------;
;                       GET_POST_INFO                                   ;
;-----------------------------------------------------------------------;
;  check point  : 25                                                    ;
;  check point  : 87                                                    ;
;  this routine returns information about POST.                         ;
;  input :                                                              ;
;       none                                                            ;
;  output:                                                              ;
;       ax      POST information                                        ;
;               bit-0 = 0 normal                                        ;
;                       1 clear password                                ;
;               bit-1 = 0 normal                                        ;
;                       1 clear CMOS                                    ;
;               bit-2 = 0 enable setup                                  ;
;                       1 disable setup                                 ;
;               bit15-3..reserved for future use                        ;
;  register usage : do not destroy any register except AX               ;
;-----------------------------------------------------------------------;
        public  get_post_info
get_post_info:
        xor     ax,ax
        ret
;-----------------------------------------------------------------------;
;                               C000_CONTROL_BEFORE                     ;
;-----------------------------------------------------------------------;
; check_point           : 2B                                            ;
; This routine is called for any work before C000 ROM control in RM.ASM.;
; If DIM is present, then this routine will be called only if DIM can not
; initialise the Video ROM i.e. if DIM can initialise video ROM, this   ;
; routine will NOT be called.                                           ;
; If DIM is present, this routine will not be called because DIM will   ;
; initialise the video ROM.                                             ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output :                                                              ;
;       (ZF)    1 -> no further control to C000 ROM                     ;
;               0 -> C000 ROM will get control                          ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; The following things can be done here:-                               ;
; 1.    You may want to bypass optional ROM control at C000:0..7FFF by  ;
;       setting (ZF) = 1.                                               ;
; 2.    You may have VIDEO ROM BIOS at  E000 segment, like most of the  ;
;       time Portable PC has this option and you do not want C000:0     ;
;       optional ROM control, you may give control to E000 segment      ;
;       at this point or in the next routine C000_CONTROL_AFTER.        ;
; 3.    You want to shadow C000 segment to E000 segment and give control;
;-----------------------------------------------------------------------;
        public  c000_control_before
c000_control_before:
        or      sp,sp                   ; (ZF) = 0, give control C000 ROM &
        ret                             ; C000_control_after else none.
;-----------------------------------------------------------------------;
;                               C000_CONTROL_AFTER                      ;
;-----------------------------------------------------------------------;
; check_point           : 2D                                            ;
; This routine is called for any special work after C000 ROM control in ;
; RM.ASM. this routine will always be called.                           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; The following things can be done here:-                               ;
; 1.    If you have E000 VIDEO ROM check for INT 10 vector, if any      ;
;       optional card already present or not, and depending on that you ;
;       may want to give coontrol to E000 VIDEO BIOS                    ;
;-----------------------------------------------------------------------;
        extrn   rt_cmos_byte:byte
        public  c000_control_after
c000_control_after:
	mov	ah,3eh
	call	read_bri_byte
	test	al,08h
	jnz	agp_present
	or	al,04h
	call	write_bri_byte
agp_present:
;; PaiLin debug {
	mov	ah,70h
	call	read_sio_byte
	out	90h,al
;; } PaiLin debug

	ret
;-----------------------------------------------------------------------;
;                         OEM_DO_MEMORY_SIZE                            ;
;-----------------------------------------------------------------------;
; check_point           : 57                                            ;
; This routine is called at the end of DO_MEMORY_SIZE in POST.ASM (i.e. ;
; any adjustment regarding base memory and extended memory is already   ;
; done) and can be used to do any OEM specific stuff.                   ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
oem_do_memory_size      proc    near
        ret
oem_do_memory_size      endp
;-----------------------------------------------------------------------;
;                               BEFORE_SETUP                            ;
;-----------------------------------------------------------------------;
; check_point           : 86                                            ;
; This routie can be used for any programming before cmos setup in      ;
; GS1.ASM.                                                              ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE: difference between INIT_BUFFER_BEFORE_SETUP and BEFORE_SETUP    ;
;       is in input values of DS, ES                                    ;
;-----------------------------------------------------------------------;
	extrn	open_extend_cmos:near
	extrn	close_extend_cmos:near
        public  before_setup
before_setup:

					; (CORE0218+)>
if (MKF_EVENT_LOG)
	include	event.equ
	extrn	dummy_ret:near
	extern	init_event_log_buffer(dummy_ret):near
	mov	ax,LOG_BUFFER_SEG
	call	init_event_log_buffer
endif;	if (MKF_EVENT_LOG)
					; <(CORE0218+)
	sub	dx,dx
	mov	ah,1
	int	17h

        mov     dx,MKF_LM78_BASE_ADDRESS
        mov     al,40h
        out     dx,al
        jmp     short $+2
        inc     dx
        in      al,dx
        jmp     short $+2
        jmp     short $+2
        cmp     al,01h
        mov     al,01h
        jz      lm78_present
        mov     al,3
lm78_present:
        mov     byte ptr cs:[0f6c6h], al; Hardware Monitor Disabled

;; PaiLin debug {
;	pushf
;	call	open_extend_cmos
;	mov	cx,6
;write_password_cmos:
;	mov	al,8fh
;	add	al,cl
;	call	cmos_data_in_x
;	mov	ah,al
;	mov	al,97h
;	add	al,cl
;	call	cmos_data_out_x
;	loop	write_password_cmos
;	call	close_extend_cmos
;	popf
;; } PaiLin debug

;; PaiLin debug {
;;; PaiLin { 13:26:57  Tue 06-01-1999
;;; f000 cacheable for setup cursor move speed
;	mov	ah,76h
;	call	read_pci_byte
;	or	al,40h
;	call	write_pci_byte
;;; } PaiLin
;; } PaiLin debug
	
        ret                              ; Keyboard Password Enable
;-----------------------------------------------------------------------;
;                       OEM_PROGRAM_PARAMETERS_AFTER_SETUP              ;
;-----------------------------------------------------------------------;
; check_point           : 8C                                            ;
; This routine is called at the end of PROGRAM_PARAMETERS_AFTER_SETUP in;
; POST.ASM and can be used to do any OEM specific programming (also OEM ;
; specific setup programmign) even if cmos setup is not executed.       ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
	extrn	open_apc_cmos:near
	extrn	close_apc_cmos:near
	extrn	read_apc_cmos:near
oem_program_parameters_after_setup      proc    near
	mov	ah,08h
	call	read_sio_byte
	cmp	al,01h
	jbe	short ps2_mouse_present 
;; Next revision will be solve this bug.
	mov	bh,05h
	call	read_apc_cmos
	test	bl,40h
	jnz	short ps2_mouse_present

        test    byte ptr cgroup:rt_cmos_byte,40h        ; Check PS/2 mouse present?
        jnz     short ps2_mouse_present
	mov	ah,70h
	call	read_sio_byte
	and	al, not 4
	call	write_sio_byte
ps2_mouse_present:
        ret
oem_program_parameters_after_setup      endp
;-----------------------------------------------------------------------;
;                               C800_CONTROL_BEFORE                     ;
;-----------------------------------------------------------------------;
; check_point           : 96                                            ;
; this routine is called for ADAPTER ROM shadow before C800 ROM control ;
; in GS1.ASM.
; if DIM is present, this routine will be called only if DIM can not    ;
; initialise the optional ROMs. this routine will not be called if DIM  ;
; is present.                                                           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       (ZF)    1 -> no further control to C800 ROM                     ;
;               0 -> C800 ROM will get control                          ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        public  c800_control_before
c800_control_before:
        or      sp,sp                   ; (ZF) = 0, give control to C800
        ret                             ; else no control to C800_control_after
;-----------------------------------------------------------------------;
;                               C800_CONTROL_AFTER                      ;
;-----------------------------------------------------------------------;
; check_point           : 98                                            ;
; this routine is always called from GS1.ASM after ADD-ON ROMs are      ;
; initialized.                                                          ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   init_gpc_apm:near
        extrn   check_cmos_data:near
;        extrn   disable_l1_cache:near
;        extrn   enable_l1_cache:near
        extrn   enable_l2_cache:near
        public  c800_control_after
c800_control_after:
;  initialise SMRAM for greenpc power management..
        call    init_gpc_apm            ; initialise SMRAM for green PC
;  enable/disable cache according to setup selection..
        and     ds:byte ptr [0016h],11101111b; indicate cache disabled
        mov     al,q_internal_cache
        call    check_cmos_data
        jnz     ct_7                    ; disable internal cache
        call    disable_l1_cache
        jmp     short ct_8
ct_7:
        call    enable_l1_cache
        mov     al,q_external_cache
        call    check_cmos_data
        jz      ct_8                    ; disable ext cache
        call    enable_l2_cache         ; enable ext cache
        or      ds:byte ptr [0016h],00010000b; indicate cache enabled
ct_8:
        ret
;-----------------------------------------------------------------------;
;                       OEM_PROGRAM_WS                                  ;
;-----------------------------------------------------------------------;
; check point           : A4                                            ;
; This routine is used to do any OEM specific time dependent programming;
; e.g. wait state and called from PROGRAM_WS_SHADOW_CACHEABLE routine in;
; POST.ASM.                                                             ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
oem_program_ws  proc    near

        and     byte ptr ds:[15h],0bfh	; Clear SWAP flag for INT-40 routine
if	MKF_ITE8661
        mov     ax,Q_FLOPPY_SWAP
        call    get_cmos_item           ;AL = 0/1 for drive swap disable/enable
        jz      drive_not_swap
	mov	ah,04h
drive_not_swap:

        mov     al,q_fdd_access_control
        call    get_cmos_item           ;AL = 0/1 for drive protect disable/enable
        jz      drive_protect
	or	ah,1
drive_protect:
	mov	bl,0
        mov     al,0f0h
        extrn   IT8661FWriteIO:near
        call    IT8661FWriteIO
endif
if	MKF_WIN877
        mov     al,Q_FLOPPY_SWAP
        call    get_cmos_item
        jz      no_swap
        and     byte ptr ds:[15h],0bfh  ; Clear SWAP flag for INT-40 routine
        mov     ax,8001h
        extrn   Win877WriteIO:near
        call    Win877WriteIO
no_swap:
        mov     al,q_fdd_access_control
        call    get_cmos_item
        jz      fdd_rw
        mov     ax,3008h
        call    Win877WriteIO
fdd_rw:
endif
        ret
oem_program_ws  endp
;-----------------------------------------------------------------------;
;                               E000_CONTROL_BEFORE                     ;
;-----------------------------------------------------------------------;
; check point           : A7                                            ;
; this routine is called for OPTIONAL ROM shadow before E000 ROM control;
; in GS1.ASM.                                                           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       (ZF)    1 -> no further control to E000 ROM.                    ;
;               0 -> E000 ROM will get control                          ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE:                                                                 ;
;       1. Disable E000 shadow.                                         ;
;       2. Disable E000 ROM CS.                                         ;
; Purpose: if any ISA ROM is present at E000, this routine will enable  ;
;       ISA ROM access.                                                 ;
;-----------------------------------------------------------------------;
        public  e000_control_before
e000_control_before:
; Disable E000 Shadow
	mov	ax,7400h
	call	write_pci_byte
	mov	ah,75h
	call	write_pci_byte

; Disable E000 ROM CS
	mov	ah,040h
	call	read_sio_byte
	and	al,0fch
	call	write_sio_byte

        or      sp,sp                   ; (ZF) = 0, give control to E000
        ret                             ; else no control to e000_control_after
;-----------------------------------------------------------------------;
;                               E000_CONTROL_AFTER                      ;
;-----------------------------------------------------------------------;
; check point           : A9                                            ;
; this routine is called for ADAPTER ROM shadow after E000 ROM control  ;
; in GS1.ASM.                                                           ;
; input :                                                               ;
;       CX    = 0000H, no ISA ROM found at E000 segment                 ;
;             <>0000H, some ISA ROM found at E000 segment               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE:                                                                 ;
;       1. If no ISA ROM found at E000, simply ret.                     ;
;       2. If ISA ROM found at E000 and if E000 shadow is enabled in    ;
;       Setup (there is no Setup Question for this, you need to implement
;       it), enable E000 shadow and copy E000 ISA ROM to E000 shadow.   ;
;-----------------------------------------------------------------------;
        public  e000_control_after
e000_control_after:
        jcxz    eca_00          ; no ROM found at E000 segment

;  ROM found at E000 segment, write code here to enable E000 shadow and
;  copy E000 ROM to shadow.............................................

eca_00:
        ret
;-----------------------------------------------------------------------;
;                       OEM_SPECIAL_CONFIG_DISPLAY                      ;
;-----------------------------------------------------------------------;
; check point           : AA                                            ;
; this routine is called from special_config_display in POST.ASM to     ;
; display any OEM specific configuration.                               ;
; input :                                                               ;
;       ds      0040h                                                   ;
;       es      0000h                                                   ;
;       stack available                                                 ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   edo_memory_msg:abs
        extrn   rsdram_memory_msg:abs
        extrn   sdram_memory_msg:abs
        extrn   fpm_memory_msg:abs
	extrn	write_tty:near
        extrn   display_0d0a:near
        extrn   display_message_set:near
	extrn	read_cursor_posn:near
	extrn	set_cursor_posn:near
	extrn	dmi_mem_module_info:near

        public  oem_special_config_display
oem_special_config_display:
;; Display DRAM Types Information
	mov	dx,10			; Check SDRAM
        mov     bh,sdram_memory_msg
	call	display_dram_info

	mov	dx,4			; Check EDO
        mov     bh,edo_memory_msg
	call	display_dram_info

	mov	dx,3			; Check FP
        mov     bh,fpm_memory_msg
	call	display_dram_info

        ret

display_dram_info:
	mov	ax,1
next_dimm:
	push	ax
	call	dmi_mem_module_info
	pop	ax
	cmp	bl,7fh
	jz	dimm_no_dram
	bt	cx,dx
	jnc	dimm_no_dram
	or	ah,ah
	jnz	skip_show_title
	push	ax
        mov     bl,09h
        call    display_message_set
	pop	ax
skip_show_title:
	or	ah,ah
	jz	@f
	push	ax
	mov	al,','
	call	write_tty
	pop	ax
@@:
	push	ax
	add	al,30h
	call	write_tty
	pop	ax
	mov	ah,0ffh
dimm_no_dram:
	inc	ax
	cmp	al,4
	jnz	next_dimm
	or	ah,ah
	jz	dis_info_done
	call	read_cursor_posn	; DH,DL = row,col of cursor
	cmp	dl,40
	ja	goto_next_row
	mov	dl,40
set_cursor:
	call	set_cursor_posn		; set cursor posn
dis_info_done:
	ret
goto_next_row:
	call	display_0d0a
	ret

;-----------------------------------------------------------------------;
					; (CORE0228),(CORE0206+)>
	include	dc.equ
dc_oem_arrangement	label	byte
	db	dc_math_processor,	dc_base_memory
	db	dc_floppy_a,		dc_ext_memory
	db	dc_floppy_b,		dc_serial_port
	db	dc_display_type,	dc_parallel_port
	db	dc_amibios_date,	dc_processor_clock
	db	dc_l2_cache,		dc_apm_smi
;	db	dc_sdram_type,		dc_ecc_info
;	db	dc_k6_3_l2_cache,	dc_apm_version
	db	0ffh			; end

dc_oem_routines_table	label	word
;dc_sdram_type		equ	dc_oem_index_start
;	dw	offset cgroup:sdram_type
;
;dc_ecc_info		equ	dc_oem_index_start+1
;	dw	offset cgroup:ecc_info
;
;dc_k6_3_l2_cache	equ     dc_oem_index_start+2
;	dw	offset cgroup:k6_3_l2_cache
;
;dc_apm_version		equ	dc_oem_index_start+3
;	dw	offset cgroup:apm_version
;---------------------------------------;
; Example				;
;---------------------------------------;-------------------------------;
; Input:
;	None
; Output:
;	Message displayed with ':'
; Registers destroyed:
;	All except BP,DS,ES,FS,GS
; NOTES: Please use display_dc_colon for "xxxx : " string
;-----------------------------------------------------------------------;
;	extrn	sdram_type_msg:abs
;sdram_type:
;	mov	bl,9
;	mov	bh,sdram_type_msg
;	call	display_dc_colon	; "SDRAM TYPE      : "
;	ret
;ecc_info:
;	mov	bl,9
;	mov	bh,
;	call	display_dc_colon
;	ret
;k6_3_l2_cache
;	mov	bl,9
;	mov	bh,
;	call	display_dc_colon
;	ret
;apm_version
;	mov	bl,9
;	mov	bh,
;	call	display_dc_colon
;	ret

;-----------------------------------------------------------------------;
; Input:
;	DI	index
;---------------------------------------;
	public	dc_oem_routines
dc_oem_routines:
	sub	di,dc_oem_index_start
	shl	di,1
	call	word ptr cs:dc_oem_routines_table[di]
	retf
;---------------------------------------;
display_dc_colon:
	push	bp
	push	ds

	push	cs
	push	offset dc_return	; return address for retf

	extern	ram_segment:word
	mov	ds,cgroup:ram_segment
	push	ds:[0feb4h+2]		; segment
	push	ds:[0feb4h]		; offset
	mov	bp,dc_display_colon
	retf				; far jump to DC public routines entry
dc_return:
	pop	ds
	pop	bp
	ret
;---------------------------------------;
; Output:
;	ES:SI	point to dc_oem_arrangement
;---------------------------------------;
	public	get_dc_oem_table
get_dc_oem_table:
	push	cs
	pop	es
	mov	si,offset cgroup:dc_oem_arrangement
	ret
					; <(CORE0228),(CORE0206+)
;-----------------------------------------------------------------------;
;                       GET_SHADOW_STATUS                               ;
;-----------------------------------------------------------------------;
; this routine returns the information whether shadow ram can be made   ;
; readable and writeable at the same time i.e. whether read ram and     ;
; write ram is possible.                                                ;
; input :                                                               ;
;       stack   available                                               ;
; output:                                                               ;
;       cy      routine not implemented                                 ;
;       nc      routine implemented                                     ;
;       DI      shadow ram attribute                                    ;
;               bit-0 = 0 shadow ram read and write not possible        ;
;                       1 shadow ram read write possible                ;
;               bit-1 = 0 VGA memory not USWC                           ;
;                       1 VGA memory USWC                               ;
;               bit15-2= reserved (set to 0)                            ;
;       SI      bit 3-0 = C000 shadow ram cacheable in 16k granularity  ;
;                   bit-0 C0000-C3FFF                                   ;
;                   bit-1 C4000-C7FFF                                   ;
;                   bit-2 C8000-CBFFF                                   ;
;                   bit-3 CC000-CFFFF                                   ;
;               bit 7-4 = D000 shadow ram cacheable in 16k granularity  ;
;               bit11-8 = E000 shadow ram cacheable in 16k granularity  ;
;               bit15-12= F000 shadow ram cacheable in 16k granularity  ;
;       ECX,EDX USWC memory region1 32-bit start address, size in bytes ;
;       EAX,EBX USWC memory region2 32-bit start address, size in bytes ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE: 1. do not program anything in this routine.                     ;
;       2. in this routine, CS should NOT be assumed as F000.           ;
;       3. if read ram and write ram is possible, then in the hooks     ;
;       E000_READ_X_WRITE_RAM and F000_READ_X_WRITE_RAM, make read ram  ;
;       and write ram.                                                  ;
;       4. Set both start address and size to 0000 for a region which   ;
;       will not be set to USWC.                                        ;
;-----------------------------------------------------------------------;
first_shadow_question   label   byte
        db      Q_DC000_SHADOW
        db      Q_D8000_SHADOW
        db      Q_D4000_SHADOW
        db      Q_D0000_SHADOW
        db      Q_CC000_SHADOW
        db      Q_C8000_SHADOW
;        db      Q_C4000_SHADOW
        db      Q_C0000_SHADOW
        db      Q_C0000_SHADOW
last_shadow_question    label   byte
number_shadow_questions equ     (last_shadow_question - first_shadow_question)
        public  get_shadow_status
get_shadow_status:
        xor     si,si                   ; default to no areas shadowed

        call    check_cmos_8e           ; check if cmos checksum good
        jnz     gss_exit                ; exit if not

        test    bp,ins_key_err_bit      ; <INS> key pressed ?
        jnz     gss_exit                ; exit if yes

        mov     di,offset first_shadow_question
        mov     cx,number_shadow_questions
gss_00:
        mov     al,byte ptr cs:[di]
        call    check_cmos_data
        inc     di              ; point to next CMOS question
        cmp     al,2            ; is shadow cache enabled?
        jne     gss_01          ; jump if NOT
        or      si,01h          ; else OR in this bit
gss_01:
        shl     si,1            ; shift si for next shadow region
        loop    gss_00          ; do this for up to 8 regions
        shr     si,1            ; fix up after testing last region
;
; Next see if we are supposed to cache the system BIOS region (0f0000)
;
        mov     al,Q_CACHE_BIOS
        call    check_cmos_data
;;        or      al,al           ; is system BIOS cacheable set?
        jz      gss_02          ; jump if not
        or      si,0f000h       ; else OR in the 4 0F0000 page bits
;
; next decide whether to set the VGA frame buffer region to
; USWC memory type.
;
gss_02:
        xor	di,di
;        mov     al,VGA_FRAME_BUFFER_USWC
;        call    check_cmos_data
;        jz      gss_exit
;        or      di,00000010b

gss_exit:
        xor     ecx,ecx         ; no USWC region1
        xor     edx,edx
        xor     eax,eax         ; no USWC region2
        xor     ebx,ebx
        clc
        ret
;-----------------------------------------------------------------------;
;                       DISPLAY_CPU_NAME_PRATING                        ;
; This routine displays CPU name and PRating.                           ;
; If you do not want to display the PRating along with the CPU name,    ;
; then you have to modify this routine to display only the CPU name.    ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       none                                                            ;
; register usage : do not destroy any register                          ;
;-----------------------------------------------------------------------;
        extrn   cpu_name_display_buffer:byte
        extrn   write_tty:near
        extrn   display_message_cs:near
        public  display_cpu_name_prating
display_cpu_name_prating:
	pusha
	mov	si,offset cgroup:cpu_name_display_buffer
	call	display_message_cs	; display cpu name
;---------------------------------------;
; if you do not want to display PRating along with the CPU name,
; then comment out the following lines between {PR_STARTS and PR_ENDS}
	extrn	pr_string:byte
	cmp	byte ptr cgroup:[pr_string+2],0 ; James 012497
	jz	dcnp_00
	mov	si,offset pr_string
	call	display_message_cs
dcnp_00:
;---------------------------------------;
	popa
        ret
;-----------------------------------------------------------------------;
;                       CHECK_DISPLAY_CPU_CLOCK                         ;
; This routine returns the information whether the CPU clock will be    ;
; displayed.                                                            ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       NC      display cpu clock                                       ;
;       CY      do not display cpu clock                                ;
; register usage : do not destroy any register                          ;
; Note :                                                                ;
; 1. For AMD CPU, you may want not to display PRating along with        ;
; the CPU name and may want to display PRating in place of CPU clock.   ;
; In this case, this routine should return as CLC (i.e. display CPU     ;
; clock) and DISPLAY_CPU_CLOCK routine should display PRating instead of;
; CPU clock frequency.                                                  ;
; 2. Default code returns CY i.e. not to display CPU clock frequency for;
; AMD CPU with PRating. For AMD CPU without PRating, default code will  ;
; return NC i.e. to display CPU clock frrequency.                       ;
;-----------------------------------------------------------------------;
        public  check_display_cpu_clock
check_display_cpu_clock:
	extrn	_sysinfo_flag:word
	test	cgroup:byte ptr _sysinfo_flag,01h	; bit0=0, don't display clock
	jz	cdcc_no_clock
	cmp	cs:byte ptr [pr_string+2],00h; PRating exists ?
	jnz	cdcc_no_clock		; yes, do not display clock if PRating
	clc				; NC, display clock
	jmp	short cdcc_exit
cdcc_no_clock:
	stc				; CY, do not display CPU clock
cdcc_exit:
	ret
;-----------------------------------------------------------------------;
;                       DISPLAY_CPU_CLOCK                               ;
; This routine displays the CPU clock.                                  ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       none                                                            ;
; register usage : do not destroy any register                          ;
; Note :                                                                ;
; 1. For AMD CPU, you may want not to display PRating along with        ;
; the CPU name and may want to display PRating in place of CPU clock.   ;
; In this case, the CHECK_DISPLAY_CPU_CLOCK routine should return as CLC;
; (i.e. display CPU clock) and this routine should display PRating      ;
; instead of CPU clock frequency.                                       ;
; 2. Default code is to display CPU clock frequency.                    ;
;-----------------------------------------------------------------------;
        extrn   mhz_msg:abs
        extrn   cpu_freq:word
        extrn   display_ax:near
	extrn	get_reset_id:near
	extrn	write_tty:near
        extrn   display_message_set0:near
        public  display_cpu_clock
display_cpu_clock:
	pusha
	mov	ax,cs:cpu_freq
	call	display_ax
	mov	bh,mhz_msg
	call	display_message_set0
	popa
        ret

;-----------------------------------------------------------------------;
;-----------------------------------------------------------------------;
;                       SILENT BOOT HOOKS                               ;
;-----------------------------------------------------------------------;
IF      MKF_SILENT_BOOT
;-----------------------------------------------------------------------;
;                       OEM_INIT_SILENT_BOOT                            ;
; this routine initializes any OEM specific stuff for silent boot. this ;
; routine is called from INIT_SILENT_BOOT routine at check point 37h    ;
; while initializing the data areas needed for silent boot.             ;
; allowed.                                                              ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       none                                                            ;
; register usage : Do not destroy any register                          ;
;                                                                       ;
;                       IMPLEMENTATION NOTE                             ;
; 1. This routine can be used to initialize any OEM specific data area  ;
; which can be used to display any OEM specific stuff dynamically e.g.  ;
; status of BIOS POST progress.                                         ;
; 2. A 16 byte data area VideoOemData is defined for this purpose in    ;
; DIMDATASEG.                                                           ;
;-----------------------------------------------------------------------;
        public  oem_init_silent_boot
oem_init_silent_boot:
        ret
;-----------------------------------------------------------------------;
;                       OEM_DYNAMIC_SILENT_BOOT_DISPLAY                 ;
; this routine is called from INT1C handler inside timer interrupt if   ;
; the current active display is OEM.                                    ;
; input :                                                               ;
;       none                                                            ;
;       EOI has not yet been issued to Interrupt Controller             ;
; output:                                                               ;
;       none                                                            ;
; register usage : Do not destroy any register                          ;
;                                                                       ;
;                       IMPLEMENTATION NOTE                             ;
; 1. This routine can be used to display any OEM specific dynamic       ;
; information e.g. status of BIOS POST progress.                        ;
; 2. If any data area is needed for this, 16 byte data area VideoOemData;
; is defined for this purpose in DIMDATASEG. This data area should be   ;
; initialized in OEM_INIT_SILENT_BOOT hook and can be updated in this   ;
; hook.                                                                 ;
; 3. Use INT 10h to display anything from here. DO NOT USE any BIOS     ;
; display routines because BIOS display routines will put the concerned ;
; charecters in the local buffer instead of on the screen because at    ;
; this time the current active display is OEM.                          ;
;-----------------------------------------------------------------------;
        public  oem_dynamic_silent_boot_display
oem_dynamic_silent_boot_display:
        ret
;-----------------------------------------------------------------------;
;                       CHANGE_BACK_TO_OEM_DISPLAY                      ;
; this routine returns whether the change back to OEM display mode is   ;
; allowed.                                                              ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       CY      change back to OEM display mode allowed                 ;
;       NC      change back to OEM display mode not allowed             ;
; register usage : Do not destroy any register                          ;
;                                                                       ;
;                       IMPLEMENTATION NOTE                             ;
; 1. This routine is called when at least one transition from OEM       ;
; display mode to BIOS display mode has already been happened and a     ;
; request has come again to change the display mode to OEM.             ;
; 2. This routine should return the information whether the change back ;
; to OEM display mode is allowed or not.                                ;
; 3. If change back to OEM display mode is allowed, the display mode    ;
; can be toggled by pressing the hot key even if the display was forced ;
; to change to BIOS display mode for some reason (e.g. some error       ;
; display, etc.).                                                       ;
; 4. If change back to OEM display mode is not allowed, the display mode;
; can not be changed back to OEM (i.e. it will in BIOS display mode) if ;
; the display mode was changed to BIOS display mode for some reason     ;
; (e.g. toggle hot key is pressed, soft error display, etc.).           ;
; 5. Default implementation is                                          ;
;       STC             ; change back to OEM display allowed            ;
;       RET                                                             ;
; 6. If change back to OEM display mode is not allowed, the code of this;
; routine will be                                                       ;
;       CLC             ; change back to OEM display NOT allowed        ;
;       RET                                                             ;
;-----------------------------------------------------------------------;
        public  change_back_to_oem_display
change_back_to_oem_display:
        stc                             ; CY, change back to OEM display allowed
        ret
;-----------------------------------------------------------------------;
;                       CHANGE_DISPLAY_TO_OEM                           ;
; this routine changes the display to OEM display mode and is called    ;
; from INT1C handler inside timer interrupt when display mode needs to  ;
; be changed to OEM mode.                                               ;
; input :                                                               ;
;       none                                                            ;
;       EOI has not yet been issued to Interrupt Controller             ;
; output:                                                               ;
;       NC      display change successful                               ;
;       CY      display change not successful                           ;
; register usage : Do not destroy any register                          ;
;                                                                       ;
;                       IMPLEMENTATION NOTE                             ;
; 1. This routine will be called whenever display needs to changed to   ;
; OEM display mode.                                                     ;
; 2. Uncompress the OEM logo module, save the segment where the OEM logo;
; module is uncompressed, give control to OEM logo module to display the;
; OEM logo.                                                             ;
; 3. The OEM Logo Module ID is 0Eh.                                     ;
; 5. The OEM Logo Module can be incorporated into the system ROM image  ;
; by AMIMM utility.                                                     ;
; 6. If you need to have separate module for OEM Logo Code and Data,    ;
; use Module ID 0Eh for Code and any user defined module ID for Data.   ;
; 7. The necessary data areas in DIMDATASEG is                          ;
;       OemSegment      DW      ; contain the segment where the         ;
;                               ; OEM logo module is uncompressed       ;
;                                                                       ;
;                       IMPLEMENTATION ALGORITHM                        ;
; Step-0: Check whether OEM logo module is already uncompressed in      ;
; OemSegment. If already uncompressed, go to Setp-4.                    ;
; Step-1: Uncompress the OEM logo module.                               ;
; Step-2: If uncompress is not successful, Set Carry flag (CY), Exit.   ;
; Step-3: Save the segment where OEM logo module is uncompressed in     ;
;         OemSegment data area in DIMDATASEG.                           ;
; Step-4: Give control to OEM logo module.                              ;
; Step-5: Reset carry flag (NC), Exit.                                  ;
;                                                                       ;
;                       OEM LOGO MODULE FORMAT                          ;
; Note that this format is a suggesstion only (the code given here is   ;
; written based on this format). Any format is allowed in which case    ;
; the code in this routine needs to be modified accordingly.            ;
;                                                                       ;
; Offset-0: Word having the signature 55AA.                             ;
; Offset-2: Byte having the module size in 512Bytes unit.               ;
; Offset-3: The entry point of OEM logo display module.                 ;
;                                                                       ;
;-----------------------------------------------------------------------;
        extrn   uncom_segment:word
        extrn   scratch_segment:word
        extrn   uncompress_general_module:near
        public  change_display_to_oem
change_display_to_oem:
        push    es
        push    ds
        pushad
        push    DIMDATASEG
        pop     ds
        mov     ds,ds:word ptr OemSegment
        cmp     ds:word ptr [0000h],0aa55h
        jz      short cdto_01           ; OEM module already uncompressed
;---------------------------------------;
; uncompress OEM code
        cli
        mov     ax,cgroup:uncom_segment
        mov     ds:word ptr OemSegment,ax
        mov     es,ax
        mov     ds,cgroup:scratch_segment
        mov     bl,graphic_logo_code_id
        call    uncompress_general_module; uncompress OEM module
        stc                             ; display change not successful
        jnz     short cdto_00           ; no OEM module present
;---------------------------------------;
;; PaiLin {
;; for 256 color Logo
	mov	es,cgroup:uncom_segment
	mov	ds,cgroup:scratch_segment
	mov	bl,33h;graphic_logo_data_id
	call	uncompress_general_module; uncompress OEM module
	stc				; display change not successful
	jnz	short cdto_00		; no OEM module present
;	push	ds
;        push    DIMDATASEG
;        pop     ds
;        mov     ax,cgroup:uncom_segment
;	shr	cx,4
;	add	ax,cx
;        mov     ds:word ptr OemSegment,ax
;        mov     es,ax
;        mov     ds,cgroup:scratch_segment
;        mov     bl,graphic_logo_data_id 
;        call    uncompress_general_module; uncompress OEM module
;        stc                             ; display change not successful
;	pop	ds
;        jnz     short cdto_00           ; no OEM module present
;; } PaiLin
;---------------------------------------;
cdto_01:
        sti
        push    cs
        push    offset cgroup:cdto_ret
        push    ds
        push    0003h                   ; OEM routine offset is at 0003h
        retf
cdto_ret:
        clc                             ; display change successful
cdto_00:
        sti
        popad
        pop     ds
        pop     es
        ret
;-----------------------------------------------------------------------;
ENDIF
;-----------------------------------------------------------------------;
;			GET_ONBOARD_DEVICE_INFO				;
; this routine returns the information of concerned onboard device.	;
; input :								;
;	DS:SI	ptr to concerned onboard device data structure		;
;		(See Note-1 for device type details)			;
; output:								;
;	CY	error (e.g. routine is not implemented)			;
;		(in this case, device will be assumed to be disabled)	;
;	NC	successful						;
;		AL	00, onboard device is disabled			;
;			01, onboard device is enabled			;
;  register usage : do not destroy any register except AL		;
; NOTE:									;
; 1. The input DS:SI points to the start of the concerned onboard device;
; device information structure. The bit6-0 of the byte at offset-4 of	;
; the structure contains the device type information as follows:	;
;	device type	device						;
;		00	Undefined					;
;		01	Other						;
;		02	Unknown						;
;		03	Video						;
;		04	SCSI Controller					;
;		05	Ethernet					;
;		06	Token Ring					;
;		07	Sound						;
;		08-7F	Undefined					;
; 2. If the device type is Undefined, return with AL = 00, disabled	;
;-----------------------------------------------------------------------;
	public	get_onboard_device_info
get_onboard_device_info:
	stc
	ret
;-----------------------------------------------------------------------;
;-----------------------------------------------------------------------;
;               INITIALIZATION TABLES USED IN CP_INIT                   ;
;  Put all the tables which are used in CP_INIT hook in POST.ASM        ;
;  and may be different for different OEMs.                             ;
;-----------------------------------------------------------------------;
        db      '$$CT'
        db      01h
        db      'SIS530 PCI Init', 0
        dw      offset cgroup:PCI_init_end
        db      00h
        db      'Register',0
        db      'Data',0
	public	pci_init_begin
	public	pci_init_end
PCI_init_begin        label   byte
	db	084h,060h		;
	db	085h,000h		;
	db	086h,003h		;
	db	088h,000h		;
	db	089h,010h		;
	db	08ah,07bh		;
	db	08ch,048h		;
	db	097h,001h		;
	db	0a0h,040h		;
	db	0a1h,040h		;
	db	0a2h,080h		;
	db	0a3h,000h		;

PCI_init_end          label   byte

;;----------------------------------------------------------------------;
        db      '$$CT'
        db      01h
        db      'SIS5595 PCI-ISA Init', 0
        dw      offset cgroup:PISAC_init_end
        db      00h
        db      'Register',0
        db      'Data',0
	public	PISAC_init_begin
	public	PISAC_init_end
PISAC_init_begin        label   byte
        db      041h,080h          ; INTA# Remapping Control
        db      042h,080h          ; INTB# Remapping Control
        db      043h,080h          ; INTC# Remapping Control
        db      044h,080h          ; INTD# Remapping Control

        db	046h,090h	   ; 16 bit & 8bit IO recovery time
;        db	047h,042h	   ;
        db	047h,040h	   ; 11/04/98
        db      049h,0ffh          ; ISA Master/DMA Memory Control
        db      04ah,010h          ; memory hole 16M top
        db      04bh,00fh          ; memory hole 15M bottem
	db	065h,0c0h	   ; PHOLDL# timer
	db	066h,040h	   ; Priority timer
	db	067h,004h	   ; Extended DACK#/Subtractive Decode
	db	06ah,080h	   ; SCI router
PISAC_init_end          label   byte

;;----------------------------------------------------------------------;

        db      '$$CT'
        db      01h
        db      'SIS5595 PMU Init', 0
        dw      offset cgroup:PMU_init_end
        db      00h
        db      'Register',0
        db      'Data',0
	public	PMU_init_begin
	public	PMU_init_end
PMU_init_begin        label   byte
;	db	05eh,0b2h		
;	db	05fh,000h
;	db	04dh,000h
	db	05ch,0b2h		; Set B2 I/O Trap for S/W SMI.
	db	05dh,000h

        db      060h,000h	   ; disable PMU SMI ENABLE bit
        db      061h,000h	   ;
        db      062h,000h	   ;
        db      063h,000h	   ;
        db      079h,000h	   ; clear Timer 0~2 count
        db      07ah,000h	   ;
        db      07bh,000h	   ;

PMU_init_end          label   byte


reg_struc               struc
        setup_Q         db      (?)
        reg_index       db      (?)
        mask_value      db      (?)    
	sis_dev_func_number dw  (?)
reg_struc               ends

	public	program_ws_table_start
	public	program_ws_table_end
program_ws_table_start          label   byte

reg_struc <Q_NA                      ,50h,080h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_NA_L2_HIT		     ,50h,020h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_NA_IO_CYCYE             ,50h,010h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_SINGLE_READ             ,52h,040h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;; PaiLin debug {
;reg_struc <Q_BRDY_L2_HIT             ,51h,040h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;; } PaiLin debug
reg_struc <Q_DRAM_SYNCHRONOUS        ,52h,080h,S530_BUS_NUM + S530_DEV_FUNC_NUM> 
reg_struc <Q_GRAPWIN_ADD_DECODE      ,52h,020h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_SYNCHRONOUS_CPU_DRAM    ,52h,010h,S530_BUS_NUM + S530_DEV_FUNC_NUM>


;; PaiLin debug {
;reg_struc <Q_DRAM_START_POINT        ,55h,0C0h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_PAGE_MISS_WRITE         ,55h,008h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_PAGE_MISS_DATAREAD      ,55h,004h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_PAGE_MISS_CODEREAD      ,55h,002h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_PAGE_MISS_GRAPHICS      ,55h,001h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;; } PaiLin debug

reg_struc <Q_RAS_PULSE_WIDTH         ,56h,0C0h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_REFRESH_DEPTH           ,56h,030h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_REFRESH_TIME            ,56h,00ch,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_REFRESH_ENABLE          ,56h,002h,S530_BUS_NUM + S530_DEV_FUNC_NUM>

;; PaiLin debug {
;reg_struc <Q_RAS_PRECHARGE           ,58h,0C0h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_RAS_CAS_DELAY           ,58h,030h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;; } PaiLin debug

reg_struc <Q_SDRAM_WR_RETIRE         ,5dh,010h,S530_BUS_NUM + S530_DEV_FUNC_NUM>

reg_struc <Q_SDRAM_ROWHIT	     ,5eh,040h,S530_BUS_NUM + S530_DEV_FUNC_NUM>

reg_struc <Q_DMA_REQ_CNT	     ,81h,010h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_TIME_WRITE_L2	     ,81h,008h,S530_BUS_NUM + S530_DEV_FUNC_NUM>

reg_struc <Q_CONCURRENCY_MODE        ,82h,080h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_TRDY_ASSERT_TIME        ,82h,040h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_READ_PREFETCH	     ,82h,010h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_ADD_DECODE_TIME	     ,82h,001h,S530_BUS_NUM + S530_DEV_FUNC_NUM>

reg_struc <Q_MEM_BURST_CNT	     ,83h,002h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
reg_struc <Q_MEM_POST_WRITE          ,83h,001h,S530_BUS_NUM + S530_DEV_FUNC_NUM>

;; PaiLin debug {
;reg_struc <Q_CPU_ARBITRATION	     ,87h,040h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_64BIT_RETRY	     ,87h,008h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;reg_struc <Q_LOCK_CONTROL	     ,87h,004h,S530_BUS_NUM + S530_DEV_FUNC_NUM>
;; } PaiLin debug

;;SIS 5595 
reg_struc <Q_16BIT_IO_CYCLE 	     ,46h,0c0h,S5595_PCI2ISA_DEV_FUNC_NUM shl 8 + S5595_BUS_NUM>
reg_struc <Q_8BIT_IO_CYCLE 	     ,46h,030h,S5595_PCI2ISA_DEV_FUNC_NUM shl 8 + S5595_BUS_NUM>
reg_struc <Q_16BIT_DMA_CYCLE 	     ,47h,030h,S5595_PCI2ISA_DEV_FUNC_NUM shl 8 + S5595_BUS_NUM>
reg_struc <Q_8BIT_DMA_CYCLE 	     ,47h,00ch,S5595_PCI2ISA_DEV_FUNC_NUM shl 8 + S5595_BUS_NUM>
reg_struc <Q_ISA_BUS_CLOCK 	     ,45h,0c0h,S5595_PCI2ISA_DEV_FUNC_NUM shl 8 + S5595_BUS_NUM>
;;SIS 5595 
					       
program_ws_table_end            label   byte

;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1996, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-246-8600.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;	include	i2c_b.inc
;	include	i2c.inc
;-----------------------------------------------------------------------;
        public  _OEMPOST_ENDS
_OEMPOST_ENDS   label   byte                    ; marks end of module
;---------------------------------------;
_text   ends
        end
