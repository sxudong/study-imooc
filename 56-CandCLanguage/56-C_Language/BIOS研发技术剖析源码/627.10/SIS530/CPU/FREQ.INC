;-----------------------------------------------------------------------------;
;
; CPU frequency tables
;
;-----------------------------------------------------------------------------;
;-----------------------------------------------------------------------------;
; The following tables determine the frequency to be displayed on the screen.
; 1. You must have at least one table which is intel_freq.
; 2. All other tables can be absent if not needed.  If absent, the intel_freq
;    will be refered.
; 3. Add new frequency if not present here.
; 4. All frequencies must in the low-to-high order.
;-----------------------------------------------------------------------------;

;-----------;
if (CORE_626)				; $$$CPU0021
;-----------;

; $$$CPU0015 >>>
;---------------------------------------;
if (CPU_UMC)
;	public	umc_freq
;umc_freq	label	word
;	public	umc_freq_end
;umc_freq_end	label	word
endif;	if (CPU_UMC)
;---------------------------------------;
if (CPU_IDT)
;	public	idt_freq
;idt_freq	label	word
;	public	idt_freq_end
;idt_freq_end	label	word
endif;	if (CPU_IDT)
;---------------------------------------;
if (CPU_RISE)
;	public	rise_freq
;rise_freq	label	word
;	public	rise_freq_end
;rise_freq_end	label	word
endif;	if (CPU_RISE)
;---------------------------------------;
if (CPU_IBM)
;	public	ibm_freq
;ibm_freq	label	word
;	public	ibm_freq_end
;ibm_freq_end	label	word
endif;	if (CPU_IBM)
;---------------------------------------;
if (CPU_SGS)
;	public	sgs_freq
;sgs_freq	label	word
;	public	sgs_freq_end
;sgs_freq_end	label	wordc
endif;	if (CPU_SGS)
;---------------------------------------;

	public	intel_freq
	public	intel_freq_end
intel_freq	label	word
if (CPU_486)
	dw	1800,		16
	dw	2250,		20
	dw	2750,		25
	dw	3630,		33
	dw	4400,		40
	dw	5600,		50
	dw	6250,		60
endif;	if (CPU_486)
if (CPU_486) or (CPU_586)
	dw	7100,		66
	dw	7750,		75
	dw	8650,		83
	dw	9600,		90
	dw	10400,		100
	dw	12400,		120
	dw	12750,		125
endif;	if (CPU_486) or (CPU_586) or (CPU_686)
if (CPU_586) or (CPU_686)
	dw	14000,		133
	dw	15500,		150
	dw	17300,		166
	dw	17750,		175
	dw	18500,		180
	dw	19500,		190
	dw	20500,		200
	dw	20900,		208		; 83*2.5
	dw	21500,		210
	dw	22250,		220
	dw	22800,		225
	dw	23950,		233
	dw	24500,		240
	dw	25500,		250
	dw	26800,		266
	dw	27250,		270
	dw	27750,		275
	dw	28500,		280
	dw	29500,		290
	dw	30500,		300
endif;	if (CPU_586) or (CPU_686)
if (CPU_686)
	dw	34000,		333
	dw	35500,		350
	dw	37000,		366
	dw	38500,		380
	dw	41000,		400
	dw	46000,		450
endif;	if (CPU_686)
intel_freq_end	label	word


;---------------------------------------;
if (CPU_CYRIX)
	public	cyrix_freq
	public	cyrix_freq_end
cyrix_freq	label	word
if (CPU_486)
	dw	1800,		16
	dw	2250,		20
	dw	2750,		25
	dw	3630,		33
	dw	4400,		40
	dw	5600,		50
	dw	6250,		60
endif;	if (CPU_486)
if (CPU_486) or (CPU_586) or (CPU_686)
;	dw	7100,		66
;	dw	7750,		75
;	dw	8100,		80
;	dw	9600,		90
	dw	10500,		100
	dw	11800,		110
	dw	12300,		120
	dw	12750,		125
	dw	13700,		133
	dw	14000,		138		; 55*2.5
	dw	15800,		150
	dw	16500,		165
	dw	17300,		166
endif;	if (CPU_486) or (CPU_586) or (CPU_686)
if (CPU_586) or (CPU_686)
	dw	17750,		175
	dw	18500,		180
	dw	19000,		188
	dw	19500,		193
	dw	20500,		200
	dw	20900,		208		; 83*2.5
	dw	21050,		210
	dw	22250,		220
	dw	22800,		225
	dw	23500,		233
	dw	23900,		237		; (CPU0038+)
	dw	24500,		240
	dw	25500,		250
	dw	26400,		263
	dw	26800,		266
	dw	27300,		270		; (CPU0038+)
	dw	28700,		285		; (CPU0038+)
	dw	29500,		292
	dw	30500,		300
	dw	32000,		315		; (CPU0038+)
	dw	34000,		333		; (CPU0038+)
	dw	35500,		350		; (CPU0038+)
	dw	36500,		360		; (CPU0038+)
	dw	38500,		380		; (CPU0038+)
	dw	45000,		400		; (CPU0038+)
endif;	if (CPU_586) or (CPU_686)
cyrix_freq_end	label	word
endif;	if (CPU_CYRIX)
;---------------------------------------;

if (CPU_AMD)
; For AMD-K6, add at least 300 to first item.
	public	amd_freq
	public	amd_freq_end
amd_freq	label	word
if (CPU_486)
	dw	1800,		16
	dw	2250,		20
	dw	2750,		25
	dw	3630,		33
	dw	4400,		40
	dw	5600,		50
	dw	6250,		60
endif;	if (CPU_486)
if (CPU_486) or (CPU_586)
	dw	7100,		66
	dw	7800,		75
	dw	8500,		80
	dw	9600,		90
	dw	10400,		100
	dw	10800,		105	; AMD-K5 105Mhz (60*1.75)
	dw	11900,		117	; 120696: AMD-K5 116.7Mhz (66*1.75)
	dw	12400,		120
	dw	13000,		125
	dw	14000,		133
	dw	15800,		150
	dw	17300,		166
endif;	if (CPU_486) or (CPU_586)
if (CPU_586)
	dw	17800,		175
	dw	18500,		180
	dw	19500,		190
	dw	20500,		200
	dw	21500,		210
	dw	22250,		220
;	dw	22900,		225
	dw	22600,		225
	dw	23700,		233
	dw	24500,		240
;	dw	26000,		250
	dw	25700,		250
	dw	26900,		266
	dw	27400,		270
	dw	27800,		275
	dw	28500,		280
	dw	29500,		290
	dw	30500,		300
	dw	33700,		333
	dw	34300,		338
	dw	35500,		350	; 100*3.5
	dw	37100,		366
	dw	37900,		375
	dw	38800,		380	; 95*4
	dw	40700,		400	; 100*4
	dw	41600,		413	; 75*5.5
	dw	42300,		417	; 83.3*5
	dw	44000,		428	; 95*4.5
	dw	45500,		450	; 100*4.5
	dw	46500,		458	; 83.3*5.5
	dw	48000,		475	; 95*5
	dw	51000,		500	; 100*5
	dw	53000,		523	; 95*5.5
	dw	56000,		550	; 100*5.5
	dw	61000,		600	; 100*6.0
endif;	if (CPU_586)
amd_freq_end	label	word
endif;	if (CPU_AMD)

; $$$CPU0015 <<<
;-------------------;
endif;	if (CORE_626)
;-------------------;


