
;---------------------------------------------------------------------------
; Processor ID(s).
;---------------------------------------------------------------------------

PENTIUM_II_PROCESSOR    EQU     0630h   ; Pentium(r) II Family/Model/Stepping.

;---------------------------------------------------------------------------
; Pentium(r) Pro/II Processor Power-on Configuration MSR.
;---------------------------------------------------------------------------

EBL_CR_POWERON          EQU     2Ah     ; Power-on configuration register.
                                                
;---------------------------------------------------------------------------
; L2 Controller Registers.
;---------------------------------------------------------------------------

L2_CR0                  EQU     00h     ; L2 controller device/stepping id.
L2_CR1                  EQU     01h     ; L2 controller manufacturer id.
L2_CR2                  EQU     02h     ; L2 controller cache size.
L2_CR3                  EQU     03h     ; L2 controler physical cacheable
                                        ; address space.
L2_CR4                  EQU     04h     ; L2 controller latency mode.
L2_CR5                  EQU     05h     ; L2 controller error type.
L2_CR6                  EQU     06h     ; L2 controller associativity.
L2_CR7                  EQU     07h     ; Reserved.
L2_CR8                  EQU     08h     ; L2 controller timing.

;---------------------------------------------------------------------------
; Pentium(r) Pro/II Processor L2 Cache Interface MSR's.
;---------------------------------------------------------------------------

BBL_CR_D0               EQU     88h     ; L2 chunk 0 data low.
BBL_CR_D1               EQU     89h     ; L2 chunk 1 data low.
BBL_CR_D2               EQU     8Ah     ; L2 chunk 2 data low.
BBL_CR_D3               EQU     8Bh     ; L2 chunk 3 data low.
BBL_CR_DECC             EQU     118h    ; L2 data ECC.
BBL_CR_ADDR             EQU     116h    ; L2 address.
BBL_CR_TRIG             EQU     11Ah    ; L2 trigger.
BBL_CR_BUSY             EQU     11Bh    ; L2 busy.
BBL_CR_CTL              EQU     119h    ; L2 control.
BBL_CR_CTL3             EQU     11Eh    ; L2 control 3.
BBL_CR_OVRD             EQU     17h     ; L2 cache latency override.

;---------------------------------------------------------------------------
; L2 Commands - Used in CTL0 [4:1].
;---------------------------------------------------------------------------

L2_CMD_RLU              EQU     00001100b ; Data read with LRU update.
L2_CMD_TRR              EQU     00001110b ; Tag read with data read.
L2_CMD_TWR              EQU     00001000b ; Tag write with data read.
L2_CMD_TWW              EQU     00011100b ; Tag write with data write.
L2_CMD_TW               EQU     00010000b ; Tag write.
L2_CMD_TR               EQU     00001111b ; Tag read.
L2_CMD_CR               EQU     00000010b ; L2 controller read.
L2_CMD_CW               EQU     00000011b ; L2 controller write.

;---------------------------------------------------------------------------
; L2 Outbound Way Bits, CTL0 [9:8].
;---------------------------------------------------------------------------

L2_WAY0                 EQU     00b     ; Way 0
L2_WAY1                 EQU     01b     ; Way 1
L2_WAY2                 EQU     10b     ; Way 2
L2_WAY3                 EQU     11b     ; Way 3

;---------------------------------------------------------------------------
; Control Parameters for the Cache Configure Code.
;---------------------------------------------------------------------------

BUSY_WAIT_COUNT         EQU     100h           ; Watchdog for cache bus.
BUSY_BIT_SET            EQU     1h             ; Still busy value.
HIGH_32_PATTERN_0       EQU     0aaaaaaaah     ; A data pattern.
LOW_32_PATTERN_0        EQU     0aaaaaaaah     ; A data pattern.
HIGH_32_PATTERN_ALIAS   EQU     055555555h     ; A data pattern.
LOW_32_PATTERN_ALIAS    EQU     055555555h     ; A data pattern.
MAX_CACHE_SIZE          EQU     8d*1024d*1024d ; Max cache size to look for.
CSRAM_CONTROLLER_MSK    EQU     1800h          ; Mask for CSRAM L2 cache
                                               ; controllers (maximum of 4
                                               ; CSRAM controllers).
BSRAM_CONTROLLER_MSK    EQU     20000h         ; Mask for BSRAM L2 cache
                                               ; controllers (maximum of 2
                                               ; BSRAM controllers).
