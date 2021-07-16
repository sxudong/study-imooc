	page	,132
	title	OEM HOOKS for Vpp Toggling, Flash R/W Enable
;-----------------------------------------------------------------------;
;  This file is derived from original FLASH.ASM file.			;
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
;*****************************************************************;
; $Header: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/OEMFLASH.ASM 1     9/15/97 5:56p Juand $
;
; $Revision: 1 $
;
; $Date: 9/15/97 5:56p $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/OEMFLASH.ASM $
; 
; 1     9/15/97 5:56p Juand
; 
; 1     9/11/97 6:41p Juand
; 
; 1     6/05/97 12:42p Debkumar
; 
; 2     3/05/97 2:47p Davidd
; Added Make Flag for ISA PnP Read Data Port
; 
; 1     1/31/97 1:15p Debkumar
; New files for 62700.
; 
; 1     1/13/97 2:22p Debkumar
; New file for 6.27.00.
; 
;*****************************************************************;
;-----------------------------------------------------------------------;
;  This file contains OEM specific code                                 ;
;  this file will be linked with both Boot Block Code and normal BIOS	;
;  runtime code.							;
;  this file needs to be self contained i.e. this file should not have	;
;  any external reference other than those declared below.		;
;-----------------------------------------------------------------------;
	include	makeflag.equ
;-----------------------------------------------------------------------;
	extrn	pgm_kbc:near
	extrn	delay_50ms:near
;-----------------------------------------------------------------------;
;		AMI KEYBOARD CONTROLLER COMMANDS			;
;-----------------------------------------------------------------------;
;  Port Pin	Command to make it HIGH		Command to make it LOW	;
;  --------	-----------------------		----------------------	;
;  P10		B8				B0			;
;  P11		B9				B1			;
;  P12		BA				B2			;
;  P13		BB				B3			;
;  P14 *	CC				C4			;
;  P15 *	CD				C5			;
;  P22		BC				B4			;
;  P23		BD				B5			;
;  --------------------------------------------------------------------	;
;  Note: Command for P14 and P15 are available only in MEGAKEY. All	;
;  other commands are available in all AMI Keyboard Controllers.	;
;-----------------------------------------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;-----------------------------------------------------------------------;
;			MAKE_VPP_HIGH		; Moved from FLASH.ASM
;-----------------------------------------------------------------------;
;  this routine raises Vpp, the programming voltage to 12V for flash	;
;  programming, waits for voltage to stabilize (50ms delay).		;
;  input :								;
;	CLI								;
;	stack available							;
;  output:								;
;	none								;
; register usage : DO NOT destroy any register				;
;  NOTE:								;
;	1. if KBC pin is used to toggle Vpp, call "PGM_KBC" routine,	;
;	   specification of which is as follows:			;
;		input : AL  command to be output to KBC			;
;		output: none						;
;		register destroyed : AX					;
;	2. for 50ms delay, call "DELAY_50MS" routine specification of	;
;	   which is as follows:						;
;		input : none						;
;		output: none						;
;		register destroyed..none				;
;	3. if the flash part is 5V part or Vpp is controlled by hardware;
;	   jumper, do nothing (just exit by RET).			;
;	4. CS should not be assumed to be F000.				;
;-----------------------------------------------------------------------;
	public	make_vpp_high
make_vpp_high	proc	near
	ret
make_vpp_high	endp
;-----------------------------------------------------------------------;
;			MAKE_VPP_LOW		; Moved from FLASH.ASM
;-----------------------------------------------------------------------;
;  this routine lowers Vpp, the programming voltage to 5V after flash	;
;  programming is done, waits for voltage to stabilize (50ms delay).	;
;  input :								;
;	CLI								;
;	stack available							;
;  output:								;
;	none								;
; register usage : DO NOT destroy any register				;
;  NOTE:								;
;	1. if KBC pin is used to toggle Vpp, call "PGM_KBC" routine,	;
;	   specification of which is as follows:			;
;		input : AL  command to be output to KBC			;
;		output: none						;
;		register destroyed : AX					;
;	2. for 50ms delay, call "DELAY_50MS" routine specification of	;
;	   which is as follows:						;
;		input : none						;
;		output: none						;
;		register destroyed..none				;
;	3. if the flash part is 5V part or Vpp is controlled by hardware;
;	   jumper, do nothing (just exit by RET).			;
;	4. CS should not be assumed to be F000.				;
;-----------------------------------------------------------------------;
	public	make_vpp_low
make_vpp_low	proc	near
	ret
make_vpp_low	endp
;-----------------------------------------------------------------------;
;		OEM_FLASH_WRITE_ENABLE		; Called from FLASH.ASM
;-----------------------------------------------------------------------;
;  this oem hook is called from FLASH_WRITE_ENABLE routine after the	;
;  FLASH_WRITE_ENABLE routine enables the Flash write to E000,64K and	;
;  F000,64K region using chipset feature. this routine should enables	;
;  write to Flash EPROM in E000,64K and F000,64K region if it is	;
;  controlled by any OEM specific hardware feature e.g. KBC pin, etc.	;
;  input :								;
;	CLI								;
;	stack available							;
;  output:								;
;	none								;
; register usage : DO NOT destroy any register				;
;  NOTE:								;
;	1. if KBC pin is used to enable flash write, call "PGM_KBC"	;
;	   routine, specification of which is as follows:		;
;		input : AL  command to be output to KBC			;
;		output: none						;
;		register destroyed : AX					;
;	2. for 50ms delay, call "DELAY_50MS" routine specification of	;
;	   which is as follows:						;
;		input : none						;
;		output: none						;
;		register destroyed..none				;
;	3. CS should not be assumed to be F000.				;
;-----------------------------------------------------------------------;
	public	oem_flash_write_enable
oem_flash_write_enable	proc	near
	ret
oem_flash_write_enable	endp
;-----------------------------------------------------------------------;
;		OEM_FLASH_WRITE_DISABLE		; Called from FLASH.ASM
;-----------------------------------------------------------------------;
;  this oem hook is called from FLASH_WRITE_DISABLE routine after the	;
;  FLASH_WRITE_DISABLE routine disables the Flash write to E000,64K and	;
;  F000,64K region using chipset feature. this routine should disables	;
;  write to Flash EPROM in E000,64K and F000,64K region if it is	;
;  controlled by any OEM specific hardware feature e.g. KBC pin, etc.	;
;  input :								;
;	CLI								;
;	stack available							;
;  output:								;
;	none								;
; register usage : DO NOT destroy any register				;
;  NOTE:								;
;	1. if KBC pin is used to disable flash write, call "PGM_KBC"	;
;	   routine, specification of which is as follows:		;
;		input : AL  command to be output to KBC			;
;		output: none						;
;		register destroyed : AX					;
;	2. for 50ms delay, call "DELAY_50MS" routine specification of	;
;	   which is as follows:						;
;		input : none						;
;		output: none						;
;		register destroyed..none				;
;	3. CS should not be assumed to be F000.				;
;-----------------------------------------------------------------------;
	public	oem_flash_write_disable
oem_flash_write_disable	proc	near
	ret
oem_flash_write_disable	endp
;-----------------------------------------------------------------------;
;		IO INDEX/DATA Port, UNLOCK DATA				;
;---------------------------------------;-------------------------------;
; These variables are generated using the value defined in IO.MAK file	;
; and used in both bootblock code and system bios code.			;
;-----------------------------------------------------------------------;
	public	IoIndexPort
	public	IoDataPort
	public	IoUnlockValue
	public	IoIsaPnPDataPort
IoIndexPort	dw	MKF_IO_INDEX_PORT
IoDataPort	dw	MKF_IO_DATA_PORT
IoUnlockValue	db	MKF_IO_UNLOCK_DATA
IoIsaPnPDataPort	dw	MKF_IO_ISA_PNP_DATA_PORT
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
;-----------------------------------------------------------------------;
_text	ends
	end
