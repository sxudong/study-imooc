        page    ,132
        title   POST HOOKS (NO PORTING NEEDED IN GENERAL)
;---------------------------------------------------------------;
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
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _P6CLK_STARTS
_P6CLK_STARTS   label   byte            ; marks start of module
;-----------------------------------------------------------------------;
;                               CPU_CLOCK                               ;
;  this routine uses time stamp counter to find the CPU clock.          ;
;  input :                                                              ;
;       none                                                            ;
;  output:                                                              ;
;       AX      CPU Clock in MHz                                        ;
;       BX      CPU Clock * 100                                         ;
;  register destroyed : ALL except DS, ES, FS, GS, BP                   ;
;-----------------------------------------------------------------------;
        extrn   cpu_freq_table:byte
        extrn   cpu_freq_table_end:byte
        extrn   fixed_delay:near
        public  p6_cpu_clock
p6_cpu_clock:
        cli                             ; disable interrupts
        cld                             ; clear direction flag
;; get time stamp ...
	call	get_clock
	push	ax
	call	get_clock
	pop	bx
        add     bx,ax
	shr	bx,1
        mov     ax,100
        mul     bx
        mov     bx,ax                   ; BX = cpu clock * 100
        mov     si,offset cgroup:cpu_freq_table
not_yet_found:
        cmp     si,offset cgroup:cpu_freq_table_end
        jae     found_cpu_speed
        lods    cgroup:word ptr [si]    ; AX = lower limit * 100 from table
        cmp     bx,ax
        lods    cgroup:word ptr [si]    ; AX = actual rounded freq from table
        ja      not_yet_found
found_cpu_speed:
;---------------------------------------;
        ret
get_clock:
;; get time stamp ...
        mov     cx, 2
        call    fixed_delay             ; to ensure next sampling of signal
                                        ; will be done at start of the pulse

        db      0fh, 031h               ; RDTSC returns in edx:eax
        mov     ebx, eax
        mov     cx, 66                  ; 66 decimal ...
        call    fixed_delay             ; wait ~ 990us
        db      0fh, 031h               ; RDTSC returns in edx:eax
        sub     eax,ebx
        xor     edx,edx
        mov     ecx,00000990d
        div     ecx                     ; divide by fixed time...
	ret
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
;-----------------------------------------------------------------------;
        public  _P6CLK_ENDS
_P6CLK_ENDS     label   byte                    ; marks end of module
;---------------------------------------;
_text   ends
end
