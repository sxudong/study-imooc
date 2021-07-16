	page	60,132
	title	MESSAGE MODULE..STRING SET 9..SPECIAL CONFIG DISPLAY MESSAGES
;---------------------------------------;
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
; $Header: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/message.asm 1     9/15/97 5:56p Juand $
;
; $Revision: 1 $
;
; $Date: 9/15/97 5:56p $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/message.asm $
; 
; 1     9/15/97 5:56p Juand
; 
; 1     9/11/97 6:41p Juand
; 
; 1     6/05/97 12:42p Debkumar
; 
; 1     1/31/97 1:15p Debkumar
; New files for 62700.
; 
; 1     1/13/97 2:22p Debkumar
; New file for 6.27.00.
; 
; 1     1/02/97 11:41a Debkumar
; 
; 5     12/30/96 2:37p Debkumar
; Version 6.26.02
; 
; 4     9/03/96 5:15p Mandal
; 6.26 for USA
; 
; 1     6/17/96 2:34p Mandal
; 
; 3     3/21/96 5:24p Mandal
; (c)1996 and phone no changed.
; 
; 2     1/12/96 5:39p Dickh
; Added SourceSafe keywords to track revision history.
;  
;*****************************************************************;
;---------------------------------------;
	include	makeflag.equ
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
;---------------------------------------;
	public	_MESSAGE_STARTS
_MESSAGE_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;				STRING SET 9				;
;-----------------------------------------------------------------------;
;  this string set contains the messages to be displayed from the	;
;  SPECIAL_CONFIG_DISPLAY routine e.g. cache size, cpu frequency, etc.	;
;  each message can be of more than one line but the maximum number of	;
;  characters in a line can be 76. each message must end with a 0 (NULL);
;  character. please note that NULL character is not included in the	;
;  length of message.							;
;-----------------------------------------------------------------------;
	public	_StrSet9
_StrSet9	equ	9
	public	string_set_9
string_set_9	label	word
start_string_def	label	byte		; (CORE0228+)
	public agp_display
agp_display		equ	0
	db	"AGP ",0
	public	edo_memory_msg
edo_memory_msg		equ	agp_display+1
	db	'EDO DRAM at DIMM # : ',0
	public	sdram_memory_msg
sdram_memory_msg	equ	edo_memory_msg+1
	db	'SDRAM at DIMM  #   : ',0
	public	fpm_memory_msg
fpm_memory_msg		equ	sdram_memory_msg+1
	db	'FP DRAM at DIMM  # : ',0
	public	rsdram_memory_msg
rsdram_memory_msg	equ	fpm_memory_msg+1
	db	'RSDRAM at DIMM #   : ',0
	public	ecc_disabled_msg
ecc_disabled_msg	equ	rsdram_memory_msg+1
	db	'Turning off EC-Only/ECC mode because x72''s not detected',0dh,0ah
	db	'Press any key to continue',0dh,0ah,0
end_string_def	label	byte		; (CORE0228+)
;-----------------------------------------------------------------------;
;  all strings must come after STRING_SET_9 label.			;
;***********************************************************************;
;***********************************************************************;
;********							********;
;********			EXAMPLE				********;
;********							********;
;********	string_1st	equ	0			********;
;********			db	'String-1',0		********;
;********	string_2nd	equ	string_1st+1		********;
;********			db	'String-2',0		********;
;********							********;
;***********************************************************************;
;***********************************************************************;
;-----------------------------------------------------------------------;
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
;---------------------------------------;
	public	_MESSAGE_ENDS
_MESSAGE_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
