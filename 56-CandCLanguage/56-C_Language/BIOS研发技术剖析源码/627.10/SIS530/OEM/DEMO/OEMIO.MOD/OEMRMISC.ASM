	page	,132
	title	OEM Miscellaneous Device Node
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

;---------------------------------------;
	include devnode.equ
	include io.equ
	include	makeflag.equ
;---------------------------------------;
	public	SystemPciBus
;	public	OemMiscResources
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
SystemPciBus	label word
;OemMiscResources	label word

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

;         Size     Node Number   Device ID            Base Type        Sub Type         IF Type          Attributes
;         -----    -----------   --------------       --------------   --------------   --------------   ----------------------------------------------
sd_node < NODELEN, 0,            ID_PCI_BUS,      BT_BRIDGE,       ST_PCI_BR,       IF_STD_PCI_BR,   SDN_ATTR_CANT_DISABLE + SDN_ATTR_CANT_CONFIG >
;sd_node < NODELEN, 0,            ID_SYSTEM_RESOURCES, BT_SYS_PERI,     ST_OTHER_PERI,   0,               SDN_ATTR_CANT_DISABLE + SDN_ATTR_CANT_CONFIG >
	port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, MKF_PM_BASE_ADDRESS, MKF_PM_BASE_ADDRESS, 01, 40h > ;PM base address
	port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, MKF_SMB_BASE_ADDRESS, MKF_SMB_BASE_ADDRESS, 01, 10h > ;SMBus base address
	port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,0290h, 0290h,   01,  08h > ;LM78
	port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,0480h, 0480h,   01,  10h > ;!!Unknow I/O!!
	port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,04D0h, 04D0h,   01,  02h > ;IRQ Edge/level control ports
	port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16,0CF8h, 0CF8h,   01,  08h > ;PCI config access ports

;---------------------------------------;
; Miscellaneous I/O Ports               ;
;---------------------------------------;-------------------------------------;
; This table should contain any I/O port that is not used by a specific device;
; but does not return FFh when read.  Some examples of I/O ports that should  ;
; be reserved here are:                                                       ;
;   The I/O peripheral chip's index/data ports                                ;
;-----------------------------------------------------------------------------;
;                                                   Base               Base
;<--------- Leave these fields alone ------------>  Addr               Addr               Align  Size
;-------------------------------------------------  -----              -----              -----  ----
IF  (MKF_IO_INDEX_PORT ne 0FFFFh) AND (MKF_IO_INDEX_PORT ne 3F0h) AND (MKF_IO_INDEX_PORT ne 370h)
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, MKF_IO_INDEX_PORT, MKF_IO_INDEX_PORT, 01,    01h > ;IO Index Port
ENDIF
IF  (MKF_IO_DATA_PORT ne 0FFFFh) AND (MKF_IO_DATA_PORT ne 3F1h) AND (MKF_IO_DATA_PORT ne 371h)
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, MKF_IO_DATA_PORT,  MKF_IO_DATA_PORT,  01,    01h > ;IO Data Port
ENDIF
IF  (MKF_IO_ISA_PNP_DATA_PORT ne 0FFFFh) AND (MKF_IO_ISA_PNP_DATA_PORT ne 3F0h) AND (MKF_IO_ISA_PNP_DATA_PORT ne 370h)
port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, MKF_IO_ISA_PNP_DATA_PORT, MKF_IO_ISA_PNP_DATA_PORT, 01,    01h > ;ISA PnP Read Data Port
ENDIF

;---------------------------------------;
; Miscellaneous Memory Ranges           ;
;---------------------------------------;-------------------------------------;
; This table should contain any memory block that is not used by a specific   ;
; device but does not return FFh when read.                                   ;
;-----------------------------------------------------------------------------;
;                                                                         Base
;<------------------- Leave these fields alone ---------------------->    Addr       Size
;---------------------------------------------------------------------  --------   --------
;Example:
;fmem32_descriptor < FMEM32_DESC_TAG, FMEM32_DESC_LEN, MD_FLAG_WIDTH_32, 00000000h, 00000000h > ;Example
;------------------------------------------------------------------------------------------

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

