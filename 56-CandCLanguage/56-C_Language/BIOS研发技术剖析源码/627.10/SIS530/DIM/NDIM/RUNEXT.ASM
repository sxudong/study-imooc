	page	,132
	title .			Device Initialization External Fixups
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
;****************************************************************************;

	include rt.equ
	include mac32.mac


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


;------------------------------------------------------------------------------;
;                                                                              ;
;                             16 Bit Code Only                                 ;
;                                                                              ;
;------------------------------------------------------------------------------;
ifndef RT32 	;{

ifndef EISA

	public	int_15_eisa
				extrn	int_15:near
		int_15_eisa:	jmp	int_15
	public	int_02_eisa
				extrn	int_02:near
		int_02_eisa:	jmp	int_02

	public	rteisa_new_escd
		rteisa_new_escd proc near
		rteisa_new_escd endp

	public	rteisa_readable_id
		rteisa_readable_id proc near
		rteisa_readable_id endp

	public	rteisa_check_ready
		rteisa_check_ready proc near
		rteisa_check_ready endp

	public	rteisa_generate_zc80
		rteisa_generate_zc80 proc near
		rteisa_generate_zc80 endp

endif

ifndef ISA
endif



ifndef PNP
endif


ifndef PCI

	public 	rth_pci_device_limit
		rth_pci_device_limit label byte

	public	rtpci_get_bus_count
		rtpci_get_bus_count proc near
		rtpci_get_bus_count endp

	public	rtpci_bios_present
		rtpci_bios_present proc near
		rtpci_bios_present endp

	public	rtpci_find_device
		rtpci_find_device proc near
		rtpci_find_device endp

	public	rtpci_find_class
		rtpci_find_class proc near
		rtpci_find_class endp

	public	rtpci_special_cycle
		rtpci_special_cycle proc near
		rtpci_special_cycle endp

	public	rtpci_read_cfg_byte
		rtpci_read_cfg_byte proc near
		rtpci_read_cfg_byte endp

	public	rtpci_read_cfg_word
		rtpci_read_cfg_word proc near
		rtpci_read_cfg_word endp

	public	rtpci_read_cfg_dword
		rtpci_read_cfg_dword proc near
		rtpci_read_cfg_dword endp

	public	rtpci_write_cfg_byte
		rtpci_write_cfg_byte proc near
		rtpci_write_cfg_byte endp

	public	rtpci_write_cfg_word
		rtpci_write_cfg_word proc near
		rtpci_write_cfg_word endp

	public	rtpci_write_cfg_dword
		rtpci_write_cfg_dword proc near
		rtpci_write_cfg_dword endp

	public	rtpci_get_irq_options
		rtpci_get_irq_options proc near
		rtpci_get_irq_options endp

	public	rtpci_last_onboard_bus
		rtpci_last_onboard_bus proc near
		rtpci_last_onboard_bus endp

	public	rtpci_search_xlat
		rtpci_search_xlat proc near
		rtpci_search_xlat endp

	public  rtpci_get_irq_priority_map
		rtpci_get_irq_priority_map proc near
		rtpci_get_irq_priority_map endp

	public	rtpci_get_irq_reg
		rtpci_get_irq_reg proc near
		rtpci_get_irq_reg endp

	public	rtpci_slot_to_dev
		rtpci_slot_to_dev proc near
		rtpci_slot_to_dev endp

	public	rtpci_set_pci_irq
		rtpci_set_pci_irq proc near
		rtpci_set_pci_irq endp

	public	rtpci_route_irq
		rtpci_route_irq proc near
		rtpci_route_irq endp

endif


ifndef PCMCIA
endif


ifndef MCA
endif


endif 	; }  End of 16 bit only code


;------------------------------------------------------------------------------;
;                                                                              ;
;                              16/32 Bit Code                                  ;
;                                                                              ;
;------------------------------------------------------------------------------;

ifndef EISA

	pubproc rteisa_new_escd
	defproc rteisa_new_escd
	endproc rteisa_new_escd

endif


rt_dummy_ret proc near
	mov	ah, RT_INVALID_FUNC	;Return code for invalid func
	stc				;Set carry to indicate error
	ret
rt_dummy_ret endp


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




