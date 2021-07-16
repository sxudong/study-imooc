	page	,132
	title .		Miscellaneous Device Node
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-263-8181                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;

;---------------------------------------;
	include devnode.equ
	include io.equ
	include	makeflag.equ
;---------------------------------------;
	public	MiscResources
	public	ShadowMemoryResources
	public	ShadowMemoryResourcesEnd
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
.386
cgroup	group	_text
_text segment word public USE16 'CODE'
	 assume	cs:CGROUP

;---------------------------------------;
; Peripheral Table Structure            ;
;---------------------------------------;-------------------------------------;
; This table should be the only public label defined in this file.  It        ;
; contains pointers to the peripheral module's data and functions.            ;
;-----------------------------------------------------------------------------;
MiscResources	label word

	dw PTFLAG_STATIC		;Flags = Static device (short table follows)
	dw DevNodeData			;Pointer to device node data

	;Remaining Peripheral Table entries are not present for a static device

;---------------------------------------;
; Device Node Data                      ;
;---------------------------------------;-------------------------------------;
; This block of data forms the device node that describes the configuration   ;
; options available to this peripheral device.                                ;
;-----------------------------------------------------------------------------;
DevNodeData 	label byte

;	  Size	   Node Number	 Device ID	  Base Type	   Sub Type	    IF Type	     Attributes
;	  -----    -----------	 --------------   --------------   --------------   --------------   ----------------------------------------------
sd_node < NODELEN, 0,		 ID_SYSTEM_RESOURCES, BT_SYS_PERI, ST_OTHER_PERI,   0,		     SDN_ATTR_CANT_DISABLE + SDN_ATTR_CANT_CONFIG >

;---------------------------------------;
; Miscellaneous Fixed I/O Ports		;
;---------------------------------------;-------------------------------------;
; This table should contain any I/O port that is not used by a specific device;
; but does not return FFh when read.  Some examples of I/O ports that should  ;
; be reserved here are: 						      ;
;   The I/O peripheral chip's index/data ports                                ;
;   Any I/O port in the range 00 - FF that is not used by any other dev node  ;
;   The IRQ edge/level control ports (4D0/4D1)				      ;
;-----------------------------------------------------------------------------;
MiscFixedIOResources	label word
;						    Base   Base
;<--------- Leave these fields alone ------------>  Addr   Addr   Align  Size
;-------------------------------------------------  -----  -----  -----  ----
IF	MKF_INC_PCI OR MKF_INC_EISA
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,04D0h, 04D0h,   01,  02h > ;IRQ Edge/level control ports
ENDIF
IF	MKF_INC_PCI
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,0CF8h, 0CF8h,   01,  08h > ;PCI config access ports
ENDIF
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,22h, 22h,   01,  01h > ;ACPI Control Register
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,72h, 72h,   01,  02h > ;Upper CMOS Page
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,MKF_SMB_BASE_ADDRESS, MKF_SMB_BASE_ADDRESS,   01,  0Eh > ;SMBus Base Address
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,MKF_PM_BASE_ADDRESS, MKF_PM_BASE_ADDRESS,   01,  38h > ;PM Base Address

; Uncomment any of the I/O ports if those are used.
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0010h, 0010h,   01,  10h > ;0-FF I/O range
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0044h, 0044h,   01,  1ch >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0062h, 0062h,   01,  02h >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0065h, 0065h,   01,  0bh >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0084h, 0084h,   01,  03h >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0088h, 0088h,   01,  01h >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 008Ch, 008Ch,   01,  03h >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0091h, 0091h,   01,  0fh >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 00A2h, 00A2h,   01,  1eh >
;port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 00E0h, 00E0h,   01,  10h >

;---------------------------------------;
; Shadow Memory Resources		;
;---------------------------------------;-------------------------------------;
; This table will be filled in with Shadow RAM resources used, but not filled ;
; in with adaptor ROM resources.  (For example, if there is a 40K VGA BIOS)   ;
; The Shadow memory resources are done in hook 'PROGRAM_WS_SHADOW_CACHEABLE'  ;
; int POST.ASM files.							      ;
;-----------------------------------------------------------------------------;
ShadowMemoryResources	label word
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_SHADOWABLE + MD_FLAG_CACHEABLE + MD_FLAG_WIDTH_8_16, 000000000h, 00000000h > ;
ShadowMemoryResourcesEnd	label word

	END_OF_ALLOCATED_RESOURCES
	END_OF_ALTERNATE_RESOURCES
	END_OF_COMPATIBLE_DEV_IDS

NODELEN = DevNodeDataEnd - DevNodeData
DevNodeDataEnd	label byte

;-----------------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-263-8181                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
_text	 ends
	 end
