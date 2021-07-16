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
; 
;*****************************************************************;
;
;	MPTABLE.INC
;
;	This file contains structure declarations for 
;	MultiProcessing table entries.
;
;*****************************************************************;
;
;	Table header structure
;
MP_Header       	STRUCT
        Signature               db      PCMP_SIGNATURE
        Table_Length            dw      ?
        Spec_Revision           db      1
        Checksum                db      ?
        OEM_ID                  db      8 dup (0)
        PRODUCT_ID              db      12 dup (0)
        OEM_Table_Pointer       dd      0
        OEM_Table_Size          dw      0
        Entry_Count             dw      ?
        Local_APIC_Address      dd      DEFAULT_LOCAL_APIC_ADDRESS
        reserved		db	4 dup (0)
MP_Header       	ENDS


;
;	Processor entry structure
;
Processor_entry 	STRUCT
        Entry_type              db      PROCESSOR_ENTRY_TYPE
        Local_APIC_ID           db      ?
        Local_APIC_Version      db      INTEGRATED_APIC_VERSION
        CPU_Flags               db      ?
        CPU_Family_Model_Step   dd      (Family_586 OR Model_P54C OR B1_CPU)
	Feature_Flags           dd      (LOCAL_APIC_ON_CPU OR CX8 OR FPU)
        reserved          	db      8 dup (0)
Processor_entry 	ENDS

;
;	Bus entry structure
;
Bus_entry       	STRUCT
        Entry_type              db      BUS_ENTRY_TYPE
        Bus_number              db      ?
        Bus_type                db      ISA_BUS
Bus_entry       	ENDS

;
;	I/O APIC entry structure
;
IO_Apic_entry   	STRUCT
        Entry_type              db      IO_APIC_ENTRY_TYPE
        IO_Apic_ID              db      DEFAULT_IO_APIC_ID
        IO_Apic_Version         db      INTEGRATED_APIC_VERSION
        IO_Apic_Flags           db      IO_APIC_ENBLD
        IO_Apic_Address         dd      DEFAULT_IO_APIC_BASE_ADDRESS
IO_Apic_entry   	ENDS

;
;	Interrupt description entry structure
;
IO_Int_entry    	STRUCT
        Entry_type              db      INTERRUPT_ENTRY_TYPE
        Interrupt_type          db      INTR_TYPE
        Polarity_Trigger        dw      BUS_DEFAULT_POLARITY OR BUS_DEFAULT_TRIGGER
        Source_bus_number       db      0
        Source_bus_IRQ          db      ?
        Destination_IO_APIC_ID  db      DEFAULT_IO_APIC_ID
        Destination_INTIN       db      ?
IO_Int_entry    	ENDS

;
;	Local APIC entry structure
;
Local_Int_entry 	STRUCT
        Entry_type              db      LOCAL_INTR_ENTRY_TYPE
        Interrupt_type          db      INTR_TYPE
        Polarity_Trigger        dw      BUS_DEFAULT_POLARITY OR BUS_DEFAULT_TRIGGER
        Source_bus_number       db      0
        Source_bus_IRQ          db      ?
        Dest_Local_APIC_ID      db      0
        Destination_LINTIN      db      ?
Local_Int_entry 	ENDS

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
