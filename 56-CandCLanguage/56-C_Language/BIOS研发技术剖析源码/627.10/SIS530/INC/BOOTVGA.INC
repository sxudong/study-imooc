light_on_vga:
;; enable share memory
	mov	ah,63h
	call	read_pci_byte
	or	al,70h			; enabled share memory size of 8M 
	call	write_pci_byte
	

	ret
