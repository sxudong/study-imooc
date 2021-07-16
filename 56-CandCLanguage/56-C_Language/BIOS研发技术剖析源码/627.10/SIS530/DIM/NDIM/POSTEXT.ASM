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


cgroup	group	_text
_text 	segment byte public 'CODE'
	assume	cs:cgroup
.386


ifndef ISA
	public	di_isa_entry_point
		di_isa_entry_point proc near
		di_isa_entry_point endp
endif


ifndef EISA
	public	di_eisa_entry_point
		di_eisa_entry_point proc near
		di_eisa_entry_point endp
endif


ifndef PNP
	public	di_pnp_entry_point
		di_pnp_entry_point proc near
		di_pnp_entry_point endp
endif


ifndef PCI
	public	di_pci_entry_point
		di_pci_entry_point proc near
		di_pci_entry_point endp
endif


ifndef PCMCIA
	public	di_pcmcia_entry_point
		di_pcmcia_entry_point proc near
		di_pcmcia_entry_point endp
endif


ifndef MCA
	public	di_mca_entry_point
		di_mca_entry_point proc near
		di_mca_entry_point endp
endif


di_dummy_ret proc near
	ret
di_dummy_ret endp


ifndef PCI
	public	dih_pci_check_ide
		dih_pci_check_ide proc near
			clc
			ret
		dih_pci_check_ide endp
endif


_text	ends
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




