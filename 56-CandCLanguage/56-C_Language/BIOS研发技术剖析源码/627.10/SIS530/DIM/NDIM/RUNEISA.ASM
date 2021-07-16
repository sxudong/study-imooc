	page	,132
	title .			Hooks into Run Time EISA Functions
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;

	public	physical_logical_slot_map
	public	bus_master_latch_map	;

;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;

ifndef RT32
	cgroup	group	_text
	_text segment byte public 'CODE'
		 assume	cs:CGROUP
	.386
else
	.386
	cgroup	group	_runtime32
	_runtime32 segment byte public USE32 'CODE'
		 assume	cs:cgroup
endif


;---------------------------------------;
;  FOLLOWING TABLES SHOULD BE AVAILABLE	;
;  WITH EACH INDIVIDUAL EISA BOARD	;
;  DESIGN, ALTHOUGH THESE INFORMATIONS	;
;  SHOULD BE AVAILABLE FROM EXTENDED	;
;  CMOS. IF NMI IS GENERATED DUE TO BUS	;
;  TIMEOUT, INT 15H CAN'T BE CALLED TO	;
;  FIND THE SLOT MAPPING AS ENOUGH DATA	;
;  STORAGE IS NOT AVAILABLE WHILE IN	;
;  NMI SERVICE ROUTINE.			;
;---------------------------------------;
;	PHYSICAL_LOGICAL_SLOT_MAP	;
;    USED IN EISA.ASM			;
;  Logical Slot no. corressponding to	;
;  Physical slot no. 0 thru 15		;
;---------------------------------------;
;    THIS TABLE MIGHT NEED CHANGE	;
;    FROM ONE EISA BOARD TO OTHER	;
;---------------------------------------;

physical_logical_slot_map	label	byte

	db	0,1,2,3,4,5,6,7		;
	db	8,9,10,11,12,13,14,15	;

;---------------------------------------;
;	BUS_MASTER_LATCH_MAP		;
;    USED IN EISA.ASM			;
;  Physical Slot no. corressponding to	;
;  PORT 464H..bits 0 thru 7		;
;  PORT 465H..bits 0 thru 6		;
;---------------------------------------;
;    THIS TABLE MIGHT NEED CHANGE	;
;    FROM ONE EISA BOARD TO OTHER	;
;---------------------------------------;

bus_master_latch_map	label	byte

	db	1,2,3,4,5,6,0,0		;
	db	0,0,0,0,0,0,0		;

ifndef RT32
	_text ends
else
	_runtime32 ends
endif
	end
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;

