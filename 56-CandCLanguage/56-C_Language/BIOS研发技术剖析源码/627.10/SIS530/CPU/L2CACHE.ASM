;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


        page    ,132
        title   CPU CONFIGURATION MODULE
        
        extrn   uncom_segment           :word
;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
        .586p

;---------------------------------------------------------------------------
; Assembler options
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;PostSegment             SEGMENT                USE16
;---------------------------------------------------------------------------

;****************************************************************************
; ConfigureL2Cache
;
; This procedure configures the L2 cache of a Pentium(r) II processor or
; future processors.
;
; I/P = None.
; O/P = CF set for error.
;
; Destroys no working registers.
;****************************************************************************

ConfigureL2Cache        PROC    NEAR    PUBLIC

        pushad                          ; Save registers.

        jmp     CheckGeniuneIntel       ; Jump over signature.

;---------------------------------------------------------------------------
; Intel Reference BIOS Version Signature.
;---------------------------------------------------------------------------

        db      "_L2_", 35h             ; Signature to indicate which version
                                        ; of the INTEL REFERENCE BIOS CODE
                                        ; this L2 configuration routine is
                                        ; based on.  PLEASE keep this
                                        ; signature in your code.

;---------------------------------------------------------------------------
; Check for "GeniuneIntel" processor.
;---------------------------------------------------------------------------

CheckGeniuneIntel:
        xor     eax,eax                 ; CPUID signature parameter.
        cpuid                           ; Execute CPUID instruction.
        cmp     ebx,756e6547h           ; Check signature "Genu".
        jnz     ConfigureL2CacheFail    ; If not, return error.
        cmp     edx,49656e69h           ; Check signature "ineI".
        jnz     ConfigureL2CacheFail    ; If not, return error.
        cmp     ecx,6c65746eh           ; Check signature "ntel".
        jnz     ConfigureL2CacheFail    ; If not, return error.

;---------------------------------------------------------------------------
; Get feature bits now and check for processor type (family/model).
;---------------------------------------------------------------------------

CheckProcessorType:
        mov     eax,1h                  ; CPUID version/feature parameter.
        cpuid                           ; Execute CPUID instruction.
        and     ax,0fff0h               ; Mask off stepping.
        test    ax,01000h               ; Check Overdrive bit.
        jnz     ConfigureL2CacheDone    ; If it's an Overdrive processor,
                                        ; we're done, no error returned.
        cmp     ax,PENTIUM_II_PROCESSOR ; Check for Pentium(r) II processor.
        jl      ConfigureL2CacheDone    ; It's a predecessor, which doesn't
                                        ; need L2 config, so we're done,
                                        ; again no error.
        mov     bx,ax                   ; Save CPU result for after L2
                                        ; disable check.

;---------------------------------------------------------------------------
; Check here for a System Bus frequency mismatch.  If a system is
; running at a faster or slower bus frequency than the processor is designed
; for, EBL_CR_POWERON, bit 11, will be set.  Hence, if bit 11 is set, we must
; shutdown.  For simplicity, we do this shutdown with an infinite halt loop.
; In real systems, we recommend you give some sort of error before shutting
; down.  This is BIOS implementation specific, so it's not shown here.
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
; We now know it's at least a Pentium(r) II processors or greater, so it has
; an L2 cache.  Check to see if the L2 cache is disabled via hardware.  If
; it is, we don't need to do any L2 initialization.
;---------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        and     eax,00800000h           ; CTL3, hardware disable bit 23.
        jnz     ConfigureL2CacheDone    ; Exit if disabled.
        
;---------------------------------------------------------------------------
; Check for Coppermine, Cascades 1M/2M, Timna, and future processors.  These
; processors do not need any L2 initialization.
;---------------------------------------------------------------------------

        cmp     bx,680h
        jge     ConfigureL2CacheDone	; Only change for 3.3B -> 3.4. 

;---------------------------------------------------------------------------
; L2 Initialization for Pentium(r) II processors and future processors is
; different.  Handle accordingly.
;---------------------------------------------------------------------------

        cmp     bx,PENTIUM_II_PROCESSOR ; Check for Pentium(r) II processor.
        jg      BeyondPentiumIIProcessor; Handle processors after the 
                                        ; Pentium(r) II differently.

;---------------------------------------------------------------------------
; Initialize Pentium(r) II processor L2 cache.
;---------------------------------------------------------------------------

PentiumIIProcessor:

;---------------------------------------------------------------------------
; Check for safe config in EBL_CR_POWERON ratio bits [24:22].  A ratio of
; EBL_CR_POWERON [24:22] = 011b or 100b tells us to use the safe config.
;---------------------------------------------------------------------------

        mov     ecx,EBL_CR_POWERON      ; Read power on configuration MSR.
        rdmsr
        and     eax,01C00000h           ; We're interested in ratio only.
        cmp     eax,00C00000h           ; Check for ratio 011b.
        je      ConfigureL2CacheFail    ; If equal, it's a safe config and
                                        ; bypass L2 config and signal error.
        cmp     eax,01000000h           ; Check for ratio 100b.
        je      ConfigureL2CacheFail    ; If equal, it's a safe config and
                                        ; bypass L2 config and signal error.

;---------------------------------------------------------------------------
; If the BIOS would like to provide a setup option to disable the L2 cache,
; the code would be placed here.
;---------------------------------------------------------------------------

;	extrn	Q_EXTERNAL_CACHE:abs
;	mov	al,Q_EXTERNAL_CACHE
;	extrn	get_cmos_item:near
;	call	get_cmos_item
;	jz	ConfigureL2CacheDone 

;---------------------------------------------------------------------------
; Disable L2 cache first.  The L2 cache is disabled at the reset.  But, this
; step may be necessary, if control comes here from a soft reset.  This
; depends on your POST code sequence and organization.  The L2 cache is
; disabled by resetting CTL3 bit 8.  Also, we write CTL3 controlled L2
; features to default (excluding L2 cache latency) WITHOUT disturbing
; RESERVED or read only register bits.  We maintain the previous L2 cache
; latency since we don't know whether we got here from a hard or soft reset.
; If we got here from a soft reset, the L2 cache latency must remain the same
; otherwise the L2 cache latency and the L2 latency mode programmed into the
; BSRAM/CSRAM controller could be incompatible.  In the case of a hard reset,
; the L2 cache latency will be the processor's default, so we're ok.
;---------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        and     eax,0ff88061eh          ; Clear address space, disable CSER 
                                        ; checking, clear cache size,
                                        ; set 1 bank, disable L2, disable
                                        ; CRTN parity checking, disable
                                        ; victim address parity checking,
                                        ; disable ECC, and L2 not configured.
        or      eax,000044000h          ; Enable CSER checking and set 512KB.
        wrmsr

;---------------------------------------------------------------------------
; Since Pentium(r) II processor only has one l2 cache latency setting (which
; it defaults to), we don't need to do anything else here.  Also, since
; Pentium(r) II processor L2 cache controllers do not require any changes to
; their default latency mode, bypass the latency mode code and jump ahead
; to special handling for L2 controller types.
;---------------------------------------------------------------------------

        jmp     CheckL2ControllerType   ; Skip ahead to L2 device handling.

;---------------------------------------------------------------------------
; Initialize Future Processor L2 caches.
;---------------------------------------------------------------------------

BeyondPentiumIIProcessor:

;---------------------------------------------------------------------------
; Check for safe config in EBL_CR_POWERON ratio bits [25:22].  A ratio of
; EBL_CR_POWERON [25:22] = 0011b or 1100b tells us to use the safe config.
; Note: In a Katmai processor system, the system bus ECC must be off in 
; safe mode to ensure proper operation.
;---------------------------------------------------------------------------

        mov     ecx,EBL_CR_POWERON      ; Read power on configuration MSR.
        rdmsr
        and     eax,03C00000h           ; We're interested in ratio only.
        cmp     eax,00C00000h           ; Check for ratio 0011b.
        je      ConfigureL2CacheFail    ; If equal, it's a safe config and
                                        ; bypass L2 config and signal error.
        cmp     eax,03000000h           ; Check for ratio 1100b.
        je      ConfigureL2CacheFail    ; If equal, it's a safe config and
                                        ; bypass L2 config and signal error.

;---------------------------------------------------------------------------
; If the BIOS would like to provide a setup option to disable the L2 cache,
; the code would be placed here.
;---------------------------------------------------------------------------

;	extrn	Q_EXTERNAL_CACHE:abs
;	mov	al,Q_EXTERNAL_CACHE
;	extrn	get_cmos_item:near
;	call	get_cmos_item
;	jz	ConfigureL2CacheDone 

;---------------------------------------------------------------------------
; Disable L2 cache first.  The L2 cache is disabled at the reset.  But, this
; step may be necessary, if control comes here from a soft reset.  This
; depends on your POST code sequence and organization.  The L2 cache is
; disabled by resetting CTL3 bit 8.  Also, we write CTL3 controlled L2
; features to default (excluding L2 cache latency) WITHOUT disturbing
; RESERVED or read only register bits.  We maintain the previous L2 cache
; latency since we don't know whether we got here from a hard or soft reset.
; If we got here from a soft reset, the L2 cache latency must remain the same
; otherwise the L2 cache latency and the L2 latency mode programmed into the
; BSRAM/CSRAM controller could be incompatible.  In the case of a hard reset,
; the L2 cache latency will be the processor's default, so we're ok.
;---------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        and     eax,0ff88061eh          ; Clear address space, disable CSER 
                                        ; checking, clear cache size,
                                        ; set 1 bank, disable L2, disable
                                        ; CRTN parity checking, disable
                                        ; victim address parity checking,
                                        ; disable ECC, and L2 not configured.
        or      eax,000040000h          ; Enable CSER checking.
        wrmsr

        mov     bl,al                   ; Save original L2 cache latency.

;---------------------------------------------------------------------------
; Set L2 cache latency (CTL3) based on core speed.  This is only necessary
; for processors beyond the Pentium(r) II processor.
;---------------------------------------------------------------------------

        call    SetL2CacheLatency       ; Set L2 cache latency in CTL3.
        jc      ConfigureL2CacheFail    ; Check for cache/unknown speed error.

;---------------------------------------------------------------------------
; Set L2 controller latency mode.  For processors beyond the Pentium(r) II
; processor, once we set the proper L2 cache latency in CTL3 [4:1], the
; processor will return the correct L2 controller latency mode in 
; CTL3 [27:26] for that L2 cache latency.  We take this value and program it
; into the L2 control register 4 (L2_CR4).  However, in order to do this, we
; must first restore the original L2 cache latency in CTL3 [4:1], otherwise
; the write to L2 control register 4 (L2_CR4) may fail.  Then we will restore
; the new L2 cache latency in CTL3 [4:1].  Note, in the CSRAM case, the write
; to the L2 control register 4 (L2_CR4) will put the CSRAM in server timing
; mode.
;---------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr                           ; Processors beyond the Pentium(r) II
                                        ; processor will return the latency
                                        ; mode setting in CTL3 [27:26] based
                                        ; upon the L2 cache latency setting
                                        ; programmed into CTL3 [4:1].  We
                                        ; copy these two bits [27:26] into
                                        ; CR4 bits [1:0].
        mov     bh,al                   ; Save new L2 cache latency.
        mov     al,bl                   ; Restore original L2 cache latency.
                                        ; Since we zeroed all but the cache
                                        ; latency bits of CTL3 [7:0] above,
                                        ; can safely assume bits 7-5 and 0
                                        ; are zero.
        wrmsr

        and     eax,0C000000h           ; Mask out latency mode from
                                        ; CTL3 [27:26].
        shr     eax,26d                 ; Align to bit 0 for SetL2LatencyMode.
        call    SetL2LatencyMode        ; Set all L2 cache controller latency
                                        ; modes.
        jc      ConfigureL2CacheFail    ; Check for cache error.

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        mov     al,bh                   ; Restore new L2 cache latency.
                                        ; Since we zeroed all but the cache
                                        ; latency bits of CTL3 [7:0] above,
                                        ; can safely assume bits 7-5 and 0
                                        ; are zero.
        wrmsr

;---------------------------------------------------------------------------
; Special handling for the BSRAM/CSRAM devices.
;---------------------------------------------------------------------------

CheckL2ControllerType:

;---------------------------------------------------------------------------
; Read L2 cache control register CR0.  This contains device/stepping
; information.
;---------------------------------------------------------------------------

        mov     ecx,L2_CR0              ; L2 controller device/stepping id
                                        ; register.
        call    L2RegRead               ; Read device/stepping id register.
        jc      ConfigureL2CacheFail    ; Check for cache error.
        test    al,20h                  ; Bit 5 of this register indicates
                                        ; if we have a BSRAM or CSRAM device
                                        ; (a 1 is for CSRAM, a 0 for BSRAM).
        jnz     SetupCSRAM              ; Handle each device differently.

SetupBSRAM:
        jmp     CheckECCSupport

;---------------------------------------------------------------------------
; Since it's a CSRAM, it supports CRTN parity and victim address parity.
; Enable these features in CTL3, bits 7:6.
;---------------------------------------------------------------------------

SetupCSRAM:
        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        or      eax,0000000c0h          ; Enable CRTN and Victim address
        wrmsr                           ; parity, CTL3 [7:6].

;---------------------------------------------------------------------------
; Check for ECC support.  Write the ECC bits and see if they stick.  Enable
; ECC in CTL3 [5] if ECC is present.
;---------------------------------------------------------------------------

CheckECCSupport:
        call    CheckAndEnableECC       ; Enable ECC if supported.
        jc      ConfigureL2CacheFail    ; Check for cache error.

;---------------------------------------------------------------------------
; Read L2 cache control register CR3 for physical cacheable address space.
; Program this into CTL3 [22:20].
;---------------------------------------------------------------------------

        call    SetPhysicalCacheableRange ; Set physical cacheable range.
        jc      ConfigureL2CacheFail    ; Check for cache error.

;---------------------------------------------------------------------------
; Size the L2 cache.
;---------------------------------------------------------------------------

        call    SizeL2Cache             ; Size L2 cache.
        jc      ConfigureL2CacheFail    ; Check for cache error.

;---------------------------------------------------------------------------
; Now invalidate L2.  This is necessary for CSER and ECC support.
;---------------------------------------------------------------------------

InvalidateL2:

;---------------------------------------------------------------------------
; With all caching disabled, invalidating the entire L2 cache can take
; upwards of 20 seconds.  To speed this up, we enable caching via CR0 here.
; This is safe since the L2 enable bit in CTL3 (bit 8) is not set at this
; point.  Hence, only the L1 cache will be used.  We must also ensure that
; the MTRR's are setup to allow at least WT caching in the region this code
; lives.  Otherwise we've just done nothing.
;---------------------------------------------------------------------------

        mov     eax,cr0                 ; EAX = Processor CR0.
        mov     ebx,eax                 ; Save in EBX for later restore.
        and     eax,9fffffffh           ; Enable caching (CD=0, NW=0).
        mov     cr0,eax                 ; Make it happen.

;---------------------------------------------------------------------------
; Determine L2 cache size from CTL3, bits 17:13.  Only 1 bank.
;---------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        mov     ecx, eax                ; Use ECX as the size counter.
        and     ecx,0003E000h           ; Cache size only.
        jnz     @f
        or      ecx,00001000h           ; Add the 1 in for the 128K case.
@@:
        shl     ecx,3h                  ; Convert to largest set address.
        mov     edx,0h                  ; Zero upper address.
        mov     edi,0h                  ; Zero upper data.
        mov     esi,0h                  ; Zero lower data.
        mov     al,L2_CMD_TWW           ; L2 write command.

InvalidateLoop:
        sub     ecx,20h                 ; Next L2 cache address.

        mov     ah,L2_WAY0              ; Way 0
        call    CommandL2               ; Write cache line.
        jc      ConfigureL2CacheFail    ; Check for cache error.

        mov     ah,L2_WAY1              ; Way 1
        call    CommandL2               ; Write cache line.
        jc      ConfigureL2CacheFail    ; Check for cache error.

        mov     ah,L2_WAY2              ; Way 2
        call    CommandL2               ; Write cache line.
        jc      ConfigureL2CacheFail    ; Check for cache error.

        mov     ah,L2_WAY3              ; Way 3
        call    CommandL2               ; Write cache line.
        jc      ConfigureL2CacheFail    ; Check for cache error.

        cmp     ecx,0h                  ; All of L2 written yet yet?
        jnz     InvalidateLoop          ; If not, continue.

;---------------------------------------------------------------------------
; Disable all caching now (i.e., L1).  It is very important to make sure
; all caching is disabled before enabling the L2 cache.
;---------------------------------------------------------------------------

        mov     eax,cr0                 ; Get CR0.
        or      eax,40000000h           ; Disable caching.
        wbinvd
        mov     cr0,eax                 ; Make it happen.

        wbinvd                          ; Flush L1.

;---------------------------------------------------------------------------
; Set L2 configured in CTL3 [0].  Do an INVD to clear the L2 tags.  Clear
; out any residual errors in all L2 controller error registers.  Finally,
; set L2 enabled in CTL3 [8].
;---------------------------------------------------------------------------

ConfigureL2:
        mov     ecx,BBL_CR_CTL3         ; Read L2 control register 3 (CTL3).
        rdmsr
        or      eax,000000001h          ; Set configured CTL3 [0].
        invd
        wrmsr

        invd                            ; Flush L2 tags.

        mov     ecx,L2_CR5              ; L2 controller error register.
        xor     al,al                   ; Zero's to clear.
        call    L2RegWriteAll           ; Write it to all controllers.
        jc      ConfigureL2CacheFail    ; Check for cache error.


;---------------------------------------------------------------------------
; Errata D46 workaround for the Pentium II Xeon Processor.
; Please see the Pentium II Xeon Processor Specification Update
; for a description of the errata.
;---------------------------------------------------------------------------

D46Workaround:
        mov     eax,1h                  ; CPUID version/feature parameter.
        push    ebx                     ; Preserve original CR0.
        cpuid                           ; Execute CPUID instruction.
        pop     ebx                     ; Preserve original CR0.
        and     ax,0fff0h               ; Mask off stepping.
        cmp     ax,650h                 ; Check for Deschutes processor.
        je      DoD46Workaround         ; If Deschutes, do D46 workaround.
        cmp     ax,670h                 ; Check for Katmai/Tanner processor.
        jne     EnableL2		; If Katmai/Tanner, do D46 workaround. 

DoD46Workaround:
        mov     ecx,BBL_CR_CTL3         ; Read L2 control register 3 (CTL3).
        rdmsr
        push    eax                     ; Save original value.
        push    edx
        and     al,0E1h                 ; Isolate L2 latency bits.
        or      al,0Ah                  ; Set to default L2 latency.
        wrmsr
        pop     edx                     ; Restore original value determined
        pop     eax                     ; above.
        wrmsr

EnableL2:
        mov     ecx,BBL_CR_CTL3         ; Read L2 control register 3 (CTL3).
        rdmsr
        or      eax,000000100h          ; Set enabled CTL3 [8].
        invd                            ; Flush L2 tags.
        wrmsr
        invd                            ; Flush L2 tags.
        jmp     short $+2
        wbinvd

;---------------------------------------------------------------------------
; Restore original caching state (i.e., CR0).
;---------------------------------------------------------------------------

        mov     cr0,ebx                 ; Original CR0 from above.

;---------------------------------------------------------------------------
; L2 initialization is either done or skipped.
;---------------------------------------------------------------------------

ConfigureL2CacheDone:
        clc                             ; Clear CF to indicate success.
        jmp     ConfigureL2CacheExit    ; All done.

ConfigureL2CacheFail:
        stc                             ; Set CF to indicate error.

ConfigureL2CacheExit:
        popad                           ; Restore registers.

        ret                             ; Go home.

ConfigureL2Cache        ENDP

;****************************************************************************
; CommandL2
;
; This procedure sends a Cache Interface Command to the L2 hardware.
;
; I/P = edx = Upper 32 bits of Address bits.
; I/P = ecx = Lower 32 bits of Address bits.
; I/P = edi = Upper 32 bits of Data pattern to be sent off.
; I/P = esi = Lower 32 bits of Data pattern to be sent off.
; I/P = al  = L2 transaction type (bits 4:0).
; I/P = ah  = Outbound way (bits 1:0).
; O/P       = Results will be in L2 cache MSRs.
; O/P = CY  = Set if L2 is permanently busy and is not accepting commands.
;
; Destroys no working register but for CY flag.
;
; Sends a Cache Interface command to L2 hardware and waits
; for the completion of the command. Returns completion status.
;****************************************************************************

CommandL2       PROC    NEAR

        pushad                          ; Save registers.
        mov     bp,sp                   ; Use register values off stack.

;----------------------------------------------------------------------------
; Step1: Set up 64 bit address.
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_ADDR         ; L2 Address register.      
        mov     eax,dword ptr [bp+18h]  ; Lower address.
        mov     edx,dword ptr [bp+14h]  ; Upper address.
        wrmsr

;----------------------------------------------------------------------------
; Step2: Set up Data pattern.
;----------------------------------------------------------------------------

        mov     eax,dword ptr [bp+4h]   ; Lower data pattern.
        mov     edx,dword ptr [bp]      ; Upper data pattern.
        mov     ecx,BBL_CR_D0           ; L2 Chunk 0 data register (D0).
        wrmsr
        inc     cx                      ; L2 Chunk 1 data register (D1).
        wrmsr
        inc     cx                      ; L2 Chunk 2 data register (D2).
        wrmsr
        inc     cx                      ; L2 Chunk 3 data register (D3).
        wrmsr

;----------------------------------------------------------------------------
; Step3: Set up Control Register0.  We must set/reset only command and
; outbound way bits of CTL register. We shall not disturb other bits.
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL          ; L2 Control register.
        rdmsr
        xor     edx,edx                 ; No upper 32 bits here.
        and     ax,0fce0h               ; Remove previous command and
                                        ; outbound way.
        mov     bx,word ptr[bp+1ch]     ; Get L2 command and outbound way.
        or      ax,bx                   ; Add in new command and outbound way.
        wrmsr

;----------------------------------------------------------------------------
; Step4: Pull the trigger.
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_TRIG         ; L2 Trigger register to trigger
                                        ; command execution.
        xor     eax,eax                 ; No data.
        xor     edx,edx                 ; No data.
        wrmsr

;----------------------------------------------------------------------------
; Step5: Wait for L2 to execute command.  Poll the busy register, but use
; a software counter to prevent hanging.  Also, since (1) the time to execute
; an L2 command is a function of the processor's core speed, and (2) the
; time spent in the counter loop is a function of the processor's core speed,
; the counter loop is not processor speed sensitive (i.e. it will not break
; with faster future processors).
;----------------------------------------------------------------------------

        mov     bx,BUSY_WAIT_COUNT      ; Watchdog timer.

BusyLoop:
        mov     ecx,BBL_CR_BUSY         ; L2 Busy register.
        rdmsr
        test    al,BUSY_BIT_SET         ; Is it still busy?
        jz      DoneL2Command           ; If not, then we're done.
        dec     bx                      ; Decrement watchdog timer.
        jnz     short BusyLoop          ; Continue polling if watchdog hasn't expired.
                                                
;----------------------------------------------------------------------------
; Watchdog expired.  Set CF flag to return error.
;----------------------------------------------------------------------------

CacheInterfaceHang:
        stc                             ; Set error flag.
	jmp	CommandL2Exit           ; Exit.

;----------------------------------------------------------------------------
; All done.
;----------------------------------------------------------------------------

DoneL2Command:
	clc                             ; Clear error flag.

CommandL2Exit:
        popad                           ; Restore registers.
        ret                             ; Go home.

CommandL2       ENDP

;****************************************************************************
; L2RegRead
;
; This procedure reads a control register in the L2 controller.  This
; procedure DOES NOT support multiple controllers (controller 0 is assumed).
;
; I/P = ECX = Address of the register being accessed.
; O/P = AL = 8 bit results.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Destroys no working registers but for the ones used as O/P.
;
; Sends a CR command to L2 controller and waits for the completion of the
; command. Returns the read value.
;****************************************************************************

L2RegRead       PROC    NEAR

        pushad                          ; Save registers.
        mov     bp,sp                   ; Use register values off stack.

        xor     edx,edx                 ; Zero upper address.
        xor     edi,edi                 ; Zero upper data pattern.
        xor     esi,esi                 ; Zero lower data pattern.
        xor     eax,eax                 ; Zero command.
        shl     ecx,5h                  ; Align address to ADDR [10:5].
        mov     al,L2_CMD_CR            ; Control register read command.
        mov     ah,L2_WAY0              ; Way 0.
        call    CommandL2               ; Read it.
        jc      L2RegReadExit           ; Exit if cache error.

;----------------------------------------------------------------------------
; The read value will be in BBL_CR_ADDR (bits 21 thru 28).
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_ADDR         ; L2 Address register.
        rdmsr
        shr     eax,21d                 ; Return value is in ADDR [28:21].
        mov     byte ptr [bp+1ch],al    ; Store return value in AL on stack.

L2RegReadDone:
        clc                             ; Clear CF to indicate success.

;----------------------------------------------------------------------------
; All done.
;----------------------------------------------------------------------------

L2RegReadExit:
        popad                           ; Restore registers (including
                                        ; new AL).
        ret                             ; Go home.

L2RegRead       ENDP

;****************************************************************************
; L2RegWrite
;
; This procedure writes a control register in the L2 controller.  This
; procedure DOES support multiple controllers.
;
; I/P = ECX = Address of the register being accessed.
; I/P = BL = Controller number.
; I/P = AL = 8 bit value to be written to the L2 controller config register.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Destroys no working registers but for the ones used as O/P.
;
; Sends a CW command to L2 controller and waits for the completion of command.
;****************************************************************************

L2RegWrite      PROC    NEAR

        pushad                          ; Save registers.

        xor     edx,edx                 ; Zero upper address.
        xor     edi,edi                 ; Zero upper data pattern.
        xor     esi,esi                 ; Zero lower data pattern.
        and     eax,000000ffh           ; EAX = ADDR value to write.  Start
                                        ; with data (from AL parameter).
        shl     eax,21d                 ; Align data to ADDR [28:21].
        shl     ebx,11d                 ; Align controller number to
                                        ; ADDR [12:11] for CSRAM devices
                                        ; (from BL parameter).
        and     ebx,CSRAM_CONTROLLER_MSK ; Mask out everything but CSRAM 
                                        ; controller number in EBX.
        or      eax,ebx                 ; Add CSRAM controller number into
                                        ; ADDR value.
        shl     ebx,6h                  ; Duplicate controller number in
                                        ; ADDR [17] for BSRAM devices.
        and     ebx,BSRAM_CONTROLLER_MSK ; Mask out everything but BSRAM 
                                        ; controller number in EBX.
        or      eax,ebx                 ; Add BSRAM controller number into
                                        ; ADDR value.
        shl     ecx,5h                  ; Align address to ADDR [10:5].
        or      ecx,eax                 ; Add address to ADDR value.
        xor     eax,eax                 ; Zero command.

        mov     al,L2_CMD_CW            ; Control register write command.
        mov     ah,L2_WAY0              ; Way 0.
        call    CommandL2               ; Write it.
        
        popad                           ; Restore registers.
        ret                             ; Go home.

L2RegWrite      ENDP

;****************************************************************************
; L2RegWriteAll
;
; This procedure writes a control register in ALL L2 controllers.
;
; I/P = ECX = Address of the register being accessed.
; I/P = AL = 8 bit value to be written to the L2 controller config register.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Destroys no working registers but for the ones used as O/P.
;
; Sends a CW command to multiple L2 controllers and waits for the completion
; of these commands.
;****************************************************************************

L2RegWriteAll   PROC    NEAR    PUBLIC

        pushad                          ; Save registers.

        mov     edx,ecx                 ; Save register address in EDX.
        mov     ah,al                   ; Save data in AH.

        mov     ecx,L2_CR0              ; L2 controller device/stepping id
                                        ; register.
        call    L2RegRead               ; Read device/stepping id register.
        jc      L2RegWriteAllFail       ; Check for cache error.
        test    al,20h                  ; Bit 5: BSRAM/CSRAM.  A 0 indicates
        jnz     CSRAMCountDevices       ; BSRAM, a 1 is for CSRAM.

BSRAMCountDevices:    
        mov     ecx,L2_CR2              ; L2 controller cache size register.
        call    L2RegRead               ; Read cache banks and size.
        jc      L2RegWriteAllFail       ; Check for cache error.
        and     al,3h                   ; Mask out all but number of banks.
        inc     al                      ; Make it 1-based.
        mov     bh,al                   ; BH will hold the controller count.
        jmp     WritePrep

CSRAMCountDevices:       
        mov     ecx,L2_CR2              ; L2 controller cache size register.
        call    L2RegRead               ; Read cache banks and size.
        jc      L2RegWriteAllFail       ; Check for cache error.
        and     al,7h                   ; Mask out all but number of banks.
        mov     bh,al                   ; BH will hold the controller count.

WritePrep:
        mov     ecx,edx                 ; Restore register address.
        mov     al,ah                   ; Restore data.
        xor     bl,bl                   ; Start with first controller.

WriteLoop:
        call    L2RegWrite              ; Write the data to the register.
        jc      L2RegWriteAllFail       ; Check for cache error.

        inc     bl                      ; Increment controller counter.
        cmp     bl,bh                   ; Check to see if we've exceeded
                                        ; the controller count.
        jl      WriteLoop               ; If not, continue looping.
        
L2RegWriteAllDone:
        clc                             ; Clear CF to indicate success.
        jmp     L2RegWriteAllExit       ; All done.

L2RegWriteAllFail:
        stc                             ; Set CF to indicate error.

L2RegWriteAllExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

L2RegWriteAll   ENDP

;****************************************************************************
; WriteAndCheckAlias
;
; Writes and check the data at an alias address.
;
; I/P = EDI = Start address of the 32 byte cache line to be written.
; I/P = ESI = Start address where aliasing of the pattern needs to be checked.
; I/P = ECX = low 32 bit data pattern used for writing.
; I/P = EDX = High 32 bit data pattern used for writing.
; O/P = ZF = True, if alias occured at the requested cache address.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Destroys no working registers but for the ones used as O/P.
;
; This procedure writes a 64 bit pattern to the entire cache line
; of 32 bytes, starting at address specified in the input.  It then checks
; if an alias occured at the I/P requested alias address.
;****************************************************************************

WriteAndCheckAlias      PROC    NEAR

        pushad                          ; Store registers.
        mov     bp,sp                   ; Use register values off stack.

;----------------------------------------------------------------------------
; Write data pattern to specified address.
;----------------------------------------------------------------------------

        mov     ecx,edi                 ; Lower address (from EDI parameter).
        xor     edx,edx                 ; Upper address.
        mov     edi,dword ptr[bp+14h]   ; Upper data (from EDX parameter).
        mov     esi,dword ptr[bp+18h]   ; Lower data (from ECX parameter).
        mov     al,L2_CMD_TWW           ; Tag write with data write command.
        mov     ah,L2_WAY0              ; Way 0.
        call    CommandL2               ; Write the cache line.
        jc      WriteAndCheckAliasExit  ; Check for cache error.

;----------------------------------------------------------------------------
; Read back data pattern at specified aliasing address.
;----------------------------------------------------------------------------

        xor     edx,edx                 ; Upper address.
        xor     edi,edi                 ; Upper data.
        xor     esi,esi                 ; Lower data.
        mov     ecx,dword ptr [bp+4h]   ; Lower address (from ESI parameter).
        mov     al,L2_CMD_TRR           ; Tag read with data read command.
        mov     ah,L2_WAY0              ; Way 0.
        call    CommandL2               ; Read the cache line.
        jc      WriteAndCheckAliasExit  ; Check for cache error.

;----------------------------------------------------------------------------
; Check to see if data write overwrote aliasing address.  If so, we've
; wrapped around and we now know the cache size.
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_D0           ; L2 chunk 0 data register.

Read8ByteChunk:
        rdmsr

        cmp     eax,dword ptr [bp+18h]  ; Check for correct low pattern.
        jnz     WriteAndCheckAliasDone  ; If not equal, then we have NOT        
                                        ; wrapped around, so go ahead and exit. 
CompareUpper32Data:
        cmp     edx,dword ptr [bp+14h]  ; Check for correct high pattern.
        jnz     WriteAndCheckAliasDone  ; If not equal, then we have NOT        
                                        ; wrapped around, so go ahead and exit. 
NextChunk:
        inc     ecx                     ; Next L2 chunk data register.
        cmp     ecx,BBL_CR_D3           ; Check for beyond D3 data chunk.
        jbe     Read8ByteChunk          ; If not beyond, continue to compare.

;----------------------------------------------------------------------------
; If control comes here it means all reads and compares worked.
;----------------------------------------------------------------------------

        xor     ax,ax                   ; Set ZF - Wrap around occurred. 

WriteAndCheckAliasDone:
        clc                             ; Clear CF to indicate success.

WriteAndCheckAliasExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

WriteAndCheckAlias      ENDP

;****************************************************************************
; SetL2CacheLatency
;
; This procedure determines and sets the L2 cache latency value in CTL3.
;
; I/P = None.
; O/P = Results will be in CTL3.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands or
;            if current core speed is not in our latency table.
;
; Destroys no working registers but for the ones used as O/P.
;
; Determines and sets processor L2 latency in CTL3.
;****************************************************************************

SetL2CacheLatency     PROC    NEAR

        pushad                          ; Store registers.

;---------------------------------------------------------------------------
; Check for latency override.
;---------------------------------------------------------------------------

        mov     ecx,BBL_CR_OVRD         ; L2 cache latency override register.
        rdmsr
        and     edx,1E00000h            ; We want latency override info only.
        jnz     UseLatencyOverride      ; If it's non-zero, use it.

;---------------------------------------------------------------------------
; No latency override, so use latency tables.  First we determine if this 
; is a BSRAM or CSRAM cache controller.
;---------------------------------------------------------------------------

UseLatencyTable:
        xor     si,si                   ; SI will hold BSRAM vs CSRAM. 
                                        ; Assume BSRAM.
        mov     ecx,L2_CR0              ; L2 controller device/stepping id
                                        ; register.
        call    L2RegRead               ; Read device/stepping id register.
        jc      SetL2CacheLatencyExit   ; Check for cache error.
        and     ax,0F0h                 ; Device id only.
        test    al,20h                  ; Bit 5: BSRAM/CSRAM.  A 0 indicates
        jz      CheckProcessor          ; BSRAM, a 1 is for CSRAM.
        add     si,2h                   ; It's CSRAM.  Default table is for
                                        ; C6C CSRAM.
        cmp     al,20h                  ; Check for C6C CSRAM.
        je      CheckProcessor          ; If so, we have the right table.
        add     si,2h                   ; It's not C6C.  Next table, CK1.
        cmp     al,30h                  ; Check for CK1.
        je      CheckProcessor          ; If so, we have the right table.
        jmp     UnknownProcessor        ; This is an unknown CSRAM controller,
                                        ; so abort.

;---------------------------------------------------------------------------
; Now we check what processor we have.  The latency tables are different for
; both different processors and different cache controllers types.
;---------------------------------------------------------------------------

CheckProcessor:
        mov     eax,1h                  ; Determine what processor we have.
        cpuid
        mov     bx,ax                   ; Save for use later.
        and     ax,0FFF0h               ; Mask off stepping.
        cmp     ax,0650h                ; Check for Deschutes.
        je      Deschutes
        cmp     ax,0670h                ; Check for Katmai.
        je      Katmai
        jmp     UnknownProcessor        ; None of the above, so return an
                                        ; error.
Deschutes:
        mov     ecx,EBL_CR_POWERON      ; Read power on configuration MSR.
        rdmsr
        and     eax,03C80000h           ; We're interested in SysBusFreq [0]
                                        ; (66/100) and the core ratio.
        shr     eax,18d                 ; AL = SysBusFreq [0] and core ratio 
                                        ; (to determine core speed).
        mov     si,DeschutesTables [si] ; Load correct Deschutes latency
                                        ; table in SI.
        or      si,si                   ; Check table offset.
        jz      UnknownProcessor        ; If SI is zero, then we don't have
                                        ; any table for Deschutes and this
                                        ; cache controller.  So abort.
        jmp     LookupLoop

DeschutesTables:
        dw      OFFSET DeschutesBsramTable
        dw      OFFSET DeschutesCsramTable
        dw      OFFSET DeschutesCsramTable

Katmai:
        mov     ax,bx                   ; For Katmai, we must look at the 
        cmp     ax,672h                 ; stepping id.  This BIOS does not
        jl      UnknownProcessor        ; support Katmai with a stepping ID
                                        ; less than 2.  Please contact your
                                        ; Intel representative if you have an
                                        ; earlier stepping of Katmai to
                                        ; obtain the correct code.

        mov     ecx,EBL_CR_POWERON      ; Read power on configuration MSR.
        rdmsr
        and     eax,03CC0000h           ; We're interested in SysBusFreq [1:0]
                                        ; (66/100) and the core ratio.
        shr     eax,18d                 ; AL = SysBusFreq [1:0] and core ratio 
                                        ; (to determine core speed).
        mov     si,KatmaiTables [si]    ; Load correct Katmai latency table
                                        ; table in SI.
        or      si,si                   ; Check table offset.
        jz      UnknownProcessor        ; If SI is zero, then we don't have
                                        ; any table for Katmai and this cache
                                        ; controller.  So abort.
        jmp     LookupLoop

KatmaiTables:
        dw      OFFSET KatmaiBsramTable
        dw      OFFSET KatmaiC6CTable
        dw      OFFSET KatmaiCK1Table

LookupLoop:
        mov     ah,BYTE PTR cs:[si]     ; AH = core speed from table entry.
        cmp     al,ah                   ; Compare against actual core speed.
        je      LookupDone              ; If same, then go write latency.
        cmp     ah,0FFh                 ; Check for table end marker (0FFh).
        je      UnknownSpeed            ; If end marker, then we don't have
                                        ; this speed in the table.
        add     si,2h                   ; Increment SI to next table entry.
        jmp     LookupLoop              ; Continue looking.

;---------------------------------------------------------------------------
; The following are L2 latency tables for the Deschutes processor and Katmai
; processor.  Intel will not necessarily offer every processor/frequency
; combination listed in these tables as a product.
;---------------------------------------------------------------------------

DeschutesBsramTable:
        ;       SPEED     CTL3 [4:1]
        ;       ----==--  ===----=
        db      00010000b,00000010b     ;  66/200MHz (1/3)
        db      01010000b,00000010b     ;  66/233MHz (2/7)
        db      00100000b,00000100b     ;  66/266MHz (1/4)
        db      01100000b,00000110b     ;  66/300MHz (2/9)
        db      00000000b,00001000b     ;  66/333MHz (1/5)
        db      01000000b,00001100b     ;  66/366MHz (2/11)
        db      00010010b,00000110b     ; 100/300MHz (1/3)
        db      01010010b,00001010b     ; 100/350MHz (2/7)
        db      00100010b,00001110b     ; 100/400MHz (1/4)
        db      01100010b,00010000b     ; 100/450MHz (2/9)
        db      00000010b,00010000b     ; 100/500MHz (1/5)
        db      11111111b,00000000b     ; End Marker.

DeschutesCsramTable:
        ;       SPEED     CTL3 [4:1]
        ;       ----==--  ===----=
        db      00010010b,00010100b     ; 100/300MHz (1/3)
        db      01010010b,00010110b     ; 100/350MHz (2/7)
        db      00100010b,00010110b     ; 100/400MHz (1/4)
        db      01100010b,00010110b     ; 100/450MHz (2/9)
        db      11111111b,00000000b     ; End Marker.

KatmaiBsramTable:
        ;       SPEED     CTL3 [4:1]
        ;       ----==--  ===----=
        db      01100000b,00000110b     ;  66/300MHz (2/9)
        db      00000000b,00001000b     ;  66/333MHz (1/5)
        db      00010010b,00000110b     ; 100/300MHz (1/3)
        db      01010010b,00001010b     ; 100/350MHz (2/7)
        db      00100010b,00001110b     ; 100/400MHz (1/4)
        db      01100010b,00010000b     ; 100/450MHz (2/9)
        db      00000010b,00010000b     ; 100/500MHz (1/5)
        db      01000010b,00000010b     ; 100/550MHz (2/11)
        db      00010001b,00001110b     ; 133/400MHz (3/1)
        db      01010001b,00001100b     ; 133/466MHz (7/2)
        db      00100001b,00000010b     ; 133/533MHz (4/1)
        db      11111111b,00000000b     ; End Marker.

KatmaiC6CTable:
        ;       SPEED     CTL3 [4:1]
        ;       ----==--  ===----=
        db      00100010b,00011000b     ; 100/400MHz (1/4)
        db      01100010b,00011000b     ; 100/450MHz (2/9)
        db      00000010b,00011010b     ; 100/500MHz (1/5)
        db      00010001b,00011000b     ; 133/400MHz (1/3)
        db      11111111b,00000000b     ; End Marker.

KatmaiCK1Table:
        ;       SPEED     CTL3 [4:1]
        ;       ----==--  ===----=
        db      00100010b,00010010b     ; 100/400MHz (1/4)
        db      01100010b,00010100b     ; 100/450MHz (2/9)
        db      00000010b,00010110b     ; 100/500MHz (1/5)
        db      01000010b,00011110b     ; 100/550MHz (2/11)
        db      00010001b,00010010b     ; 133/400MHz (3/1)
        db      01010001b,00010110b     ; 133/466MHz (7/2)
        db      00100001b,00011110b     ; 133/533MHz (4/1)
        db      11111111b,00000000b     ; End Marker.

LookupDone:
        mov     bl,BYTE PTR cs:[si+1]   ; Load L2 cache latency for this
                                        ; core speed.
        jmp     writeLatency            ; Go write L2 cache latency.

;---------------------------------------------------------------------------
; Use latency override from BBL latency register, bits 56:53.
;---------------------------------------------------------------------------

UseLatencyOverride:
        mov     ebx,edx                 ; Get override bits.
        shr     ebx,20d                 ; Align for CTL3.

WriteLatency:
        mov     ecx,BBL_CR_CTL3         ; Write L2 cache latency into
                                        ; CTL3 [4:1].
        rdmsr
        and     eax,0ffffffe1h          ; Replace L2 cache latency with value
        or      al,bl                   ; from either the table or override.
        wrmsr

SetL2CacheLatencyDone:
        clc                             ; Clear CF to indicate success.
        jmp     SetL2CacheLatencyExit   ; All done.

;---------------------------------------------------------------------------
; Control comes here if the cache latency override is not set and the 
; latency tables do not support this processor/cache controller.  We return
; the CF set to indicate error.
;---------------------------------------------------------------------------

UnknownProcessor:

;---------------------------------------------------------------------------
; Control comes here if the core speed of the processor is not supported
; in our latency table.  We return the CF set to indicate error.
;---------------------------------------------------------------------------

UnknownSpeed:
        stc                             ; Set CF to indicate error.

SetL2CacheLatencyExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

SetL2CacheLatency     ENDP

;****************************************************************************
; SetL2LatencyMode
;
; This procedure sets the latency in ALL L2 cache controllers.
;
; I/P = AL = Value to write into the cache latency registers.
; O/P = Results will be in L2 controllers latency mode registers.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Destroys no working registers but for the ones used as O/P.
;
; Sets latency mode in ALL L2 controller CR4 registers.
;****************************************************************************

SetL2LatencyMode        PROC    NEAR
                        
        pushad                          ; Save registers.
        mov     ah,al                   ; Store latency mode value.
        and     ah,3h                   ; Only two bits valid.
        mov     ecx,L2_CR4              ; L2 controller latency mode register.
        call    L2RegRead               ; Read from current controller.
        jc      SetL2LatencyModeExit    ; Check for cache error.
        and     al,0fch                 ; Mask out lower two bits.
        or      al,ah                   ; Add in latency mode value.
        call    L2RegWriteAll           ; Write it to all controllers. 
        jc      SetL2LatencyModeExit    ; Check for cache error.

SetL2LatencyModeDone:
        clc                             ; Clear CF to indicate success.

SetL2LatencyModeExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

SetL2LatencyMode        ENDP

;****************************************************************************
; SizeL2Cache routine follows.
; 
; This procedure determines the size of the L2 cache (for both CSRAM and
; BSRAM devices).
;
; I/P = None.
; O/P = Results will be in CTL3.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands or
;            cache sizing error occured.
;
; Determines the size of the L2 cache and sets it in CTL3.
;****************************************************************************

SizeL2Cache     PROC    NEAR

        pushad                          ; Save registers.

;----------------------------------------------------------------------------
; BSRAM and CSRAM cache size algorithms differ.  Determine which L2 cache
; controller we have.
;----------------------------------------------------------------------------

        mov     ecx,L2_CR0              ; L2 controller device/stepping id
                                        ; register.
        call    L2RegRead               ; Read device/stepping id register.
        jc      SizeL2CacheExit         ; Check for cache error.
        test    al,20h                  ; AL = L2 cache control register CR0
                                        ; left over from above.  Bit 5 of
                                        ; this registers indicates whether
                                        ; we have a BSRAM or CSRAM device
                                        ; (a 1 is for CSRAM, a 0 for BSRAM).
        jnz     CsramSize               ; If it's 1, then do CSRAM algorithm.

;----------------------------------------------------------------------------
; BSRAM L2 cache sizing is straight forward.  We don't need to worry about
; the number of banks.  We simply determine the total cache size (by writing
; cache lines every power of 2 size and looking for aliasing to 0h) assuming
; only 1 bank.  We then program 1 bank into CTL3 [12:11] and use the total
; size to program the size per bank CTL3 [17:13].  Just assume 1 bank!
;----------------------------------------------------------------------------

BsramSize:

;----------------------------------------------------------------------------
; We must set CTL3 [17:13] to the largest possible cache size.
;----------------------------------------------------------------------------

        mov     esi,2000h               ; Start at 256K.

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr

FindMaxCacheSize:
        and     eax,0fffc1fffh          ; Zero size per bank CTL3 [17:13].
        or      eax,esi                 ; Put in the next max cache size.
        mov     edi,eax                 ; Save in EDI for comparison below.
        wrmsr                           ; Write, then read back.
        rdmsr
        cmp     eax,edi                 ; Did this cache size stick?  If not,
        jne     DoneFindMaxCacheSize    ; the previous size was the last 
        shl     esi,1h                  ; supported.
        cmp     esi,20000h              ; Make sure we don't exceed bit 17.
        jle     FindMaxCacheSize

DoneFindMaxCacheSize:
        shr     esi,1h                  ; Previous cache size.
        and     esi,3E000h              ; Limit to bits 17:13.
        and     eax,0fffc1fffh          ; Zero size per bank CTL3 [17:13].
        or      eax,esi                 ; Put in the previous cache size -
        wrmsr                           ; it's the max.

;----------------------------------------------------------------------------
; First write and check at cache location 0.  Make sure cache is there.
;----------------------------------------------------------------------------

        xor     edi,edi                 ; Write address.
        xor     esi,esi                 ; Aliasing address.
        mov     edx,HIGH_32_PATTERN_0   ; Data high pattern.
        mov     ecx,LOW_32_PATTERN_0    ; Data low pattern.
        call    WriteAndCheckAlias      ; Write and check for aliasing.
        jc      SizeL2CacheExit         ; Check for cache error.
        jnz     SizeL2CacheFail         ; This better work, otherwise there's
                                        ; no cache here.  That's a critical
                                        ; error since BBL_CR_CTL3[23] was not
                                        ; set.
        xor     bx,bx                   ; BX = cache size.
        mov     bl,01h                  ; Initial cache size of 128k.

;----------------------------------------------------------------------------
; Now we find the top of the cache.
;----------------------------------------------------------------------------

        mov     edx,HIGH_32_PATTERN_ALIAS ; Data high pattern.
        mov     ecx,LOW_32_PATTERN_ALIAS ; Data low pattern.
        add     edi,32d*1024d           ; Next write address
                                        ; (32k, 4 ways).

FindCacheTop:
        call    WriteAndCheckAlias      ; Write and check for aliasing.
        jc      SizeL2CacheExit         ; Check for cache error.
        jz      CacheTopFound           ; If aliasing occured, we've found
                                        ; the top.
        shl     bl,1h                   ; Next Size indicator.
        add     edi,edi                 ; Double the write address (cache
                                        ; sizes only power of 2).
        cmp     edi,MAX_CACHE_SIZE/4    ; Check to make sure we haven't
                                        ; exceeded maximum possible size.
        ja      SizeL2CacheFail         ; If we have exceeded, we've got a
                                        ; critical failure.
        jmp short FindCacheTop          ; Continue looking for cache top.

;----------------------------------------------------------------------------
; We've found the top.  Now we load this into CTL3 [17:13].  We also 
; assume only 1 bank - hence size per bank is just size.
;----------------------------------------------------------------------------

CacheTopFound:
        and     ebx,0000003eh           ; Size only.  For CTL3 [17:13], 128K
                                        ; is defined as 0.  We started with
                                        ; BL=1 for 128K, so we must mask off
                                        ; the LSB.
        shl     ebx,12d                 ; Align to CTL3 [17:13].
        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        and     eax,0fffc1fffh          ; Zero size per bank CTL3 [17:13].
        or      eax,ebx                 ; Replace size per bank CTL3 [17:13].
        wrmsr

;----------------------------------------------------------------------------
; We now need to write the cache size into each possible L2 cache control
; register CR2's.
;----------------------------------------------------------------------------

        shr     ebx,11d                 ; Align to the L2 controller register 
                                        ; CR2 [7:2].
        mov     ecx,L2_CR2              ; L2 controller cache size register.
        call    L2RegRead               ; Read current L2 controller register
                                        ; CR2.  We need to get the number of
                                        ; banks out of CR2 [1:0] to determine
                                        ; size/bank to program into CR2 [7:2].
        jc      SizeL2CacheExit         ; Check for cache error.
        and     al,03h                  ; Mask out all except number of banks.
        mov     cl,al
        shr     ebx,cl                  ; Divide cache size by number of
                                        ; banks to get size/bank.
        or      al,bl                   ; Merge size/bank value into CR2
                                        ; value.
        mov     ecx,L2_CR2              ; L2 controller cache size register.
        call    L2RegWriteAll           ; Write it to all controllers.
        jc      SizeL2CacheExit         ; Check for cache error.
        jmp     SizeL2CacheDone         ; All done.

;----------------------------------------------------------------------------
; CSRAM L2 cache sizing is even more simple.  The CSRAM tells us the size per
; CSRAM and the total number of CSRAMs in the system.  The total cache size
; is size/CSRAM * Number of CSRAMs.  Also, just like in the BSRAM case, we
; assume only 1 bank.  We program 1 bank into CTL3 [12:11] and use the total
; size to program the size per bank CTL3 [17:13].  Just assume 1 bank!
;----------------------------------------------------------------------------

CsramSize:
        mov     ecx,L2_CR2              ; L2 controller cache size register.
        call    L2RegRead               ; Read cache size register.
        jc      SizeL2CacheExit         ; Check for cache error.

        mov     bl,al
        and     bl,7h                   ; BL = Number of CSRAM's only.

        mov     cl,al
        shr     cl,6h                   ; CL = Size/CSRAM.
        xor     eax,eax
        mov     ax,1h                   ; AX = 1 = 512KB value for
                                        ; CTL3 [17:14].  Minimum size of a
                                        ; CSRAM is 512KB.
        shl     al,cl                   ; Adjust CTL3 [17:14] value based on
                                        ; size/CSRAM.
        mul     bl                      ; Adjust CTL3 [17:14] value based on
                                        ; number of CSRAMs.
                                        ; Now we have total cache size.
        and     ax,0Fh                  ; Maximum of 4 bits in CTL3 [17:14].
        jz      SizeL2CacheFail         ; Cache size must be non-zero!

        shl     eax,14d                 ; Align to CTL3 [17:14].
        mov     ebx,eax

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        and     eax,0fffc1fffh          ; Zero Size per bank CTL3 [17:13].
        or      eax,ebx                 ; Replace size per bank CTL3 [17:13].
        wrmsr

SizeL2CacheDone:
        clc                             ; Clear CF to indicate success.
        jmp     SizeL2CacheExit         ; All done.

SizeL2CacheFail:
        stc                             ; Set CF to indicate error.

SizeL2CacheExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

SizeL2Cache     ENDP

;****************************************************************************
; SetPhysicalCacheableRange
;
; This procedure determines the physical cacheable range of memory based on
; the L2 controller.
;
; I/P = None.
; O/P = Results will be in CTL3.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Determines the maximum cacheable address based on the L2 controller and
; puts this in CTL3, bits 20-22.
;****************************************************************************

SetPhysicalCacheableRange       PROC    NEAR

        pushad                          ; Save registers.

;****************************************************************************
; IMPORTANT NOTE: IN AN MP SYSTEM, IT IS THE BIOS'S RESPONSIBILITY TO 
; PROGRAM THE PHYSICAL CACHEABLE ADDRESS SPACE (IN CTL3) TO THE SAME VALUE ON
; EVERY PROCESSOR IN THE SYSTEM.  IN ADDITION, THE PHYSICAL CACHEABLE ADDRESS
; SPACE MUST BE SET TO THE LOWEST RANGE SUPPORTED BY ALL THE PROCESSORS/CACHE
; CONTROLLERS IN THE SYSTEM.
;****************************************************************************

;****************************************************************************
; IMPORTANT NOTE: IF A SYSTEM HAS MORE MEMORY THAN THE SUPPORTED PHYSICAL
; ADDRESS SPACE, THEN IT IS NECESSARY TO PROGRAM MTRRs IN SUCH A WAY THAT ANY
; ADDRESS ABOVE THE SUPPORTED RANGE IS UNCACHEABLE. THIS MEANS THAT YOU HAVE
; TO COMMUNICATE THIS INFO FROM THIS MODULE TO THE MODULE THAT SETS MTRRs IN
; AN IMPLEMENTATION SPECIFIC WAY. THE CODE  THAT IS NECESSARY TO DO THIS IS
; IMPLEMENTATION DEPENDANT AND IS NOT INCLUDED HERE.
;****************************************************************************

;----------------------------------------------------------------------------
; Read physical cacheable address space register, L2 control register CR3.
;----------------------------------------------------------------------------

        xor     eax,eax
        mov     ecx,L2_CR3              ; L2 controller physical cacheable
                                        ; address space register.
        call    L2RegRead               ; Read physical cacheable address
                                        ; space.
        jc      SetPhysicalCacheableRangeExit ; Check for cache error.
        mov     ebx,eax                 ; EBX = Physical cacheable space.

;----------------------------------------------------------------------------
; Determine if it's BSRAM or CSRAM.  CSRAM physical cacheable address space
; values are inverted from BSRAM/CTL3.
;----------------------------------------------------------------------------

        mov     ecx,L2_CR0              ; L2 controller device/stepping id
                                        ; register.
        call    L2RegRead               ; Read device/stepping id.
        jc      SetPhysicalCacheableRangeExit ; Check for cache error.
        test    al,20h                  ; AL = L2 cache control register CR0
                                        ; left over from above.  Bit 5 of
                                        ; this registers indicates whether
                                        ; we have a BSRAM or CSRAM device
                                        ; (a 1 is for CSRAM, a 0 for BSRAM).
        jz      bypassCsram             ; If it's 0, skip Csram special case. 

;----------------------------------------------------------------------------
; CSRAM physical cacheable address space is 64GB for all CSRAM devices.
;----------------------------------------------------------------------------

        mov     ebx,7h                  ; Force to 64GB for CSRAM devices.

bypassCsram:
        and     ebx,00000007h           ; Mask out other bits.
        shl     ebx,20d                 ; Align to CTL3 [22:20].

        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        and     eax,0ff8fffffh          ; Zero physical address range,
                                        ; CTL3 [22:20].
        or      eax,ebx                 ; Replace physical address range,
                                        ; CTL3 [22:20].
        wrmsr

SetPhysicalCacheableRangeDone:
        clc                             ; Clear CF to indicate success.

SetPhysicalCacheableRangeExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

SetPhysicalCacheableRange       ENDP

;****************************************************************************
; CheckAndEnableECC
;
; This procedure determines if the L2 supports ECC and enables it in CTL3
; if so.
;
; I/P = None.
; O/P = Results will be in CTL3 and L2.
; O/P = CY = Set if L2 is permanently busy and is not accepting commands.
;
; Determines if ECC is supported and enables it if so.  Also invalidates
; all ECC bits in the L2
;****************************************************************************

CheckAndEnableECC       PROC    NEAR

        pushad                          ; Save registers.

;----------------------------------------------------------------------------
; Enable user supplied ECC CTL [18] so that we may write our own ECC pattern.
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_CTL          ; L2 control register (CTL).
        rdmsr
        or      eax,000040000h          ; Enable user supplied ECC CTL [18].
        wrmsr

;----------------------------------------------------------------------------
; Write our pattern of ECC.  We do this by putting our pattern in the DECC
; register, writing data and our ECC pattern to tag address 0h, and then
; reading back the data and ECC from tag address 0h.  We use the 
; WriteAndCheckAlias routine here simply to save code space - we don't need
; to check any aliasing.
;----------------------------------------------------------------------------

        mov     ecx,BBL_CR_DECC         ; L2 data ECC register.
        xor     edx,edx                 ; Upper ECC pattern.
        mov     eax,0aa55aa55h          ; Lower ECC pattern.
        wrmsr

        xor     edi,edi                 ; Write address.
        xor     esi,esi                 ; Alias address.
        mov     edx,HIGH_32_PATTERN_0   ; High data pattern.
        mov     ecx,LOW_32_PATTERN_0    ; Low data pattern.
        call    WriteAndCheckAlias      ; Write and read back.
        jc      CheckAndEnableECCExit   ; Check for cache error.

        mov     ecx,BBL_CR_DECC         ; L2 data ECC register.
        rdmsr                           ; Read the ECC bits back.
        cmp     eax,0aa55aa55h          ; Compare it to the original ECC
                                        ; pattern we put in DECC.
        jnz     ECCDone                 ; If it's not equal, then ECC is
                                        ; not supported.  Otherwise it is.

;----------------------------------------------------------------------------
; ECC is supported.  So we set CTL3 [5] to enable ECC.  Note: In future
; processors ECC may be hardwired on, in which case writing to CTL3 [5] will
; have no affect.  BIOS should always check CTL3 [5] to see whether or not
; ECC is enabled (do not assume that ECC is disabled even if your BIOS does
; not enable ECC).
;----------------------------------------------------------------------------

EnableECC:
        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
        rdmsr
        or      eax,000000020h          ; Enable ECC checking CTL3 [5].
        wrmsr

;----------------------------------------------------------------------------
; Disable user supplied ECC CTL [18] for normal operation.
;----------------------------------------------------------------------------

ECCDone:
        mov     ecx,BBL_CR_CTL          ; L2 control register (CTL).
        rdmsr
        and     eax,0fffbffffh          ; Disable user supplied ECC CTL [18].
        wrmsr

CheckAndEnableECCDone:
        clc                             ; Clear CF to indicate success.

CheckAndEnableECCExit:
        popad                           ; Restore registers.
        ret                             ; Go home.

CheckAndEnableECC       ENDP
;---------------------------------------------------------------------------
; Equate files needed.
;---------------------------------------------------------------------------


INCLUDE l2c_equ.inc

;----------------------------------------------------------------------------
_text ENDS
;----------------------------------------------------------------------------

END
