#-----------------------------------------------------------------------#
# Build list of DIM OBJs needed for BIOS POST				#
#-----------------------------------------------------------------------#
!if $(DIM_SUPPORT)
DIM_OBJS =\
$(CORE_PATH)dimstart.obj\
!if $(SILENT_BOOT)
$(CORE_PATH)dim.obj\
!else
$(CORE_PATH)dimnslnt.obj\
!endif
$(CORE_PATH)resmgr.obj\
$(CORE_PATH)di-sys.obj\
$(BUILD_DIR)\setupequ.obj\
$(BUILD_DIR)\postdim.obj\
$(BUILD_DIR)\oempdim.obj\
$(BUILD_DIR)\npostdim.obj\
$(BUILD_DIR)\postext.obj

!if $(INC_ISA)
DIM_OBJS = $(DIM_OBJS)\
$(CORE_PATH)di-isa.obj
!endif

!if $(INC_EISA)
DIM_OBJS = $(DIM_OBJS)\
$(CORE_PATH)di-eisa.obj
!endif

!if $(INC_PNP)
DIM_OBJS = $(DIM_OBJS)\
$(CORE_PATH)di-pnp.obj
!endif

!if $(INC_PCI)
DIM_OBJS = $(DIM_OBJS)\
$(CORE_PATH)di-pci.obj\
!if $(I2O_SUPPORT)
$(CORE_PATH)di-i2o.obj\
!endif
!if $(PCI_BRIDGE)
$(CORE_PATH)pci-br.obj\
!if $(MULTI_HOST_BR)
$(BUILD_DIR)\pcimhbr.obj\
!endif
!else
$(CORE_PATH)pci-brdm.obj\
!endif
!if $(PCI_MANUAL)
$(BUILD_DIR)\pciman.obj\
$(CORE_PATH)pci-ncdm.obj
!else
$(CORE_PATH)pci-mndm.obj\
$(BUILD_DIR)\pcinc.obj
!endif
!endif

!if ($(INC_PCI) && ($(VUMA_SUPPORT) || $(SMBA_SUPPORT)))
DIM_OBJS = $(DIM_OBJS)\
$(BUILD_DIR)\pcifb.obj
!endif

DIM_OBJS = $(DIM_OBJS)\
!if $(WRITE_ESCD)
$(CORE_PATH)di-close.obj\
!endif
$(CORE_PATH)dimend.obj

!endif
#-----------------------------------------------------------------------#
# Build list of PNP OBJs needed for runtime BIOS			#
#-----------------------------------------------------------------------#
!if $(DIM_SUPPORT)
RTPNP_OBJS =\
$(CORE_PATH)rt.obj\
#(CORE0072+)>
!if $(GPNV_SUPPORT)
$(CORE_PATH)\rtgpnv.obj\
$(CORE_PATH)\gpnvr.obj\
!if $(GPNV_FLASH)
$(CORE_PATH)\gpnvm.obj\
!else
$(CORE_PATH)\gpnvio.obj\
!endif
!endif
#<(CORE0072+)
!if $(GPC_SUPPORT) && $(USB_SUPPORT)
$(BUILD_DIR)\runusb.obj\
!endif
# (CORE0071)>
!if $(FLASH_4GB)
!	if $(MXIC_P)
!		if $(BIOS_SIZE)==2
$(CORE_PATH)gmx8200p.obj\
!		else
$(CORE_PATH)gmx8100p.obj\
!		endif
!	endif
!	if $(MXIC_T) && $(BIOS_SIZE)==2
$(CORE_PATH)gmx8200t.obj\
!	endif
!	if $(INTEL)
!		if $(BIOS_SIZE)==2
$(CORE_PATH)gi8002.obj\
!		else
$(CORE_PATH)gi8001.obj\
!		endif
!	endif
!	if $(SST) || $(WINBOND) || $(ATMEL)
!		if $(BIOS_SIZE)==2
$(CORE_PATH)gs9020.obj\
!		else
$(CORE_PATH)gs9010.obj\
!		endif
!	endif
!	if $(ATMEL)
!		if $(BIOS_SIZE)==2
$(CORE_PATH)nat9020.obj\
!		else
$(CORE_PATH)nat9010.obj\
!		endif
!	endif
!	if $(AMD)
!		if $(BIOS_SIZE)==2
$(CORE_PATH)gam9002.obj\
!		else
$(CORE_PATH)nam9010.obj\
!		endif
!	endif
# (CORE0213)>
# (CORE0208+)>
# (CORE0216),(CORE0224)>
!	if ( $(BIOS_SIZE)==2 && ($(MXIC_29F002T) || $(AMD)) )\
	|| ( $(BIOS_SIZE)==2 && $(AT49F002T) )\
	|| ( $(BIOS_SIZE)==2 && $(PMC29F002T) )
# <(CORE0216),(CORE0224)
$(CORE_PATH)gammx.obj\
!	endif
!	if $(BIOS_SIZE)==2 && $(MXIC_29F002T)
$(CORE_PATH)gmx9002t.obj\
!	endif
!	if $(BIOS_SIZE)==1 && $(MXIC_29F001T)
$(CORE_PATH)gmx9001t.obj\
!	endif
# <(CORE0208+)
# <(CORE0213)
!	if $(WINBOND)
!		if $(BIOS_SIZE)==2
$(CORE_PATH)nw9020.obj\
!		else
$(CORE_PATH)nw9011.obj\
!		endif
!	endif
# (CORE0215+)>
!      if $(BIOS_SIZE)==2 && $(MOSEL_V29C51002T)
$(CORE_PATH)gmo002t.obj\
!      endif
# <(CORE0215+)
# (CORE0216+)>
!      if $(BIOS_SIZE)==2 && $(AT49F002T)
$(CORE_PATH)gat9002t.obj\
!      endif
# <(CORE0216+)
# (CORE0224+)>
!	if $(BIOS_SIZE)==2 && $(PMC29F002T)
$(CORE_PATH)gpm9002t.obj\
!	endif
# <(CORE0224+)
!else
!	if $(INDEX_DATA)
!		if $(AMD)
$(CORE_PATH)oam9010.obj\
!		endif
!		if $(MXIC) || $(MXIC_P)
$(CORE_PATH)omx8100.obj\
!		endif
!		if $(MXIC_P)
$(CORE_PATH)nmx8100p.obj\
!		endif
!		if $(INTEL)
$(CORE_PATH)oi8001.obj\
!		endif
!		if $(SST) || $(WINBOND) || $(ATMEL)
$(CORE_PATH)os9010.obj\
!		endif
!		if $(ATMEL)
$(CORE_PATH)nat9010.obj\
!		endif
!		if $(WINBOND)
$(CORE_PATH)nw9011.obj\
!		endif
!	else
!		if $(AMD)
$(CORE_PATH)nam9010.obj\
!		endif
!		if $(MXIC) || $(MXIC_P)
$(CORE_PATH)nmx8100.obj\
!		endif
!		if $(MXIC_P)
$(CORE_PATH)nmx8100p.obj\
!		endif
!		if $(INTEL)
$(CORE_PATH)ni8001.obj\
!		endif
!		if $(SST) || $(WINBOND) || $(ATMEL)
$(CORE_PATH)ns9010.obj\
!		endif
!		if $(ATMEL)
$(CORE_PATH)nat9010.obj\
!		endif
!		if $(WINBOND)
$(CORE_PATH)nw9011.obj\
!		endif
!	endif
!endif
!if !$(INC_EISA)
!	if $(INC_PNP) && $(NONEISA_NVRAM)
!		if $(NVRAM_FLASH)
$(BUILD_DIR)\flsinfo.obj\
!			if $(FLASH_4GB)
$(BUILD_DIR)\flsnvrg.obj\
!			else
!				if $(INDEX_DATA)
$(BUILD_DIR)\flsnvrid.obj\
!				else
$(BUILD_DIR)\flsnvrd.obj\
!				endif
!			endif
!		else
$(BUILD_DIR)\dflsinfo.obj\
!			if $(NVRAM_DALLAS)
$(BUILD_DIR)\dalasnvr.obj\
!			else
$(BUILD_DIR)\dummynvr.obj\
!			endif
!		endif
!	else
!		if $(INTEL) || $(AMD) || $(SST) || $(MXIC) || $(MXIC_P) || $(MXIC_T) || $(WINBOND) || $(ATMEL)
$(BUILD_DIR)\flsinfo.obj\
!		else
$(BUILD_DIR)\dflsinfo.obj\
!		endif
$(BUILD_DIR)\dummynvr.obj\
!	endif
!else
!	if $(INTEL) || $(AMD) || $(SST) || $(MXIC) || $(MXIC_P) || $(MXIC_T) || $(WINBOND) || $(ATMEL)
$(BUILD_DIR)\flsinfo.obj\
!	else
$(BUILD_DIR)\dflsinfo.obj\
!	endif
!endif
# <(CORE0071)
$(CORE_PATH)rt-nvr.obj\
$(BUILD_DIR)\rth.obj\
$(BUILD_DIR)\io.obj\
#(CORE0072-)>
#!if $(DMI_SUPPORT)
#$(CORE_PATH)rt-dmi.obj\
#$(BUILD_DIR)\nrundmi.obj\
#!else
#$(BUILD_DIR)\dmirdm.obj\
#!endif
#<(CORE0072-)
$(BUILD_DIR)\runext.obj

!if $(INC_EISA)
RTPNP_OBJS = $(RTPNP_OBJS)\
$(CORE_PATH)rt-eisa.obj\
$(BUILD_DIR)\runeisa.obj\
$(BUILD_DIR)\eisanvr.obj
!endif

!if $(INC_PCI)
RTPNP_OBJS = $(RTPNP_OBJS)\
$(CORE_PATH)rt-pci.obj\
$(BUILD_DIR)\runpci.obj\
$(BUILD_DIR)\oemrpci.obj\
$(BUILD_DIR)\nrunpci.obj

!if $(VUMA_SUPPORT) || $(SMBA_SUPPORT)
RTPNP_OBJS = $(RTPNP_OBJS)\
!if $(VUMA_SUPPORT)
$(BUILD_DIR)\runvuma.obj\
!endif
!if $(SMBA_SUPPORT)
$(BUILD_DIR)\runsmba.obj\
!endif
$(BUILD_DIR)\runfb.obj
!endif

!endif

!else
RTPNP_OBJS =\
$(CORE_PATH)rtdm.obj\
$(BUILD_DIR)\dflsinfo.obj\
$(BUILD_DIR)\dummynvr.obj
!endif


!if $(DIM_SUPPORT)
RT32_OBJS =\
$(BUILD_DIR)\rt32strt.obj

!if $(INC_EISA) && $(INC_EISA_32)
RT32_0_OBJS =\
$(CORE_PATH)prt-eisa.obj\
$(BUILD_DIR)\pruneisa.obj\
$(CORE_PATH)prt-nvr.obj\
$(BUILD_DIR)\peisanvr.obj
!endif

!if $(INC_PCI)
RT32_0_OBJS = $(RT32_0_OBJS)\
$(CORE_PATH)prt-pci.obj\
$(BUILD_DIR)\prunpci.obj\
$(BUILD_DIR)\poemrpci.obj\
$(BUILD_DIR)\pnrunpci.obj\
$(BUILD_DIR)\prunext.obj
!endif

RT32_1_OBJS = \
$(CORE_PATH)rt32end.obj

!endif
#-----------------------------------------------------------------------#
# Build list of core OBJs needed for BIOS POST				#
#-----------------------------------------------------------------------#
POST_OBJS =\
$(CORE_PATH)dp.obj\
$(CORE_PATH)ramdata.obj\
##(CORE0228),(CORE0072)>
#!if $(DMI_SUPPORT)
$(CORE_PATH)\pi.obj\
#$(BUILD_DIR)\npostdmi.obj\
#!endif
##<(CORE0228),(CORE0072)
!if $(ML_MODULE)
$(CORE_PATH)snml.obj\
!else
$(CORE_PATH)sn.obj\
!endif
# $$$CORE0018- >>>
#$(CORE_PATH)snlogo.obj\
# $$$CORE0018- <<<
!if $(SILENT_BOOT)
!if $(ML_MODULE)
$(CORE_PATH)silentml.obj\
!else
$(CORE_PATH)silent.obj\
!endif
!else
!if $(ML_MODULE)
$(CORE_PATH)slntnml.obj\
!else
$(CORE_PATH)silentn.obj\
!endif
!endif
!if $(ADDR_LINE_TEST)
$(CORE_PATH)vm.obj\
!else
$(CORE_PATH)vmna.obj\
!endif
!if $(BUP6)
$(CORE_PATH)rmp6.obj\
!else
$(CORE_PATH)rm.obj\
!endif
!if $(KB_PS2_CONNECTOR_SWAP)
$(BUILD_DIR)\portswap.obj\
!endif
$(CORE_PATH)gpcui.obj\
!if $(MEGAKEY)
$(CORE_PATH)mkey.obj\
!else
$(CORE_PATH)mkeydm.obj\
!endif
$(CORE_PATH)di.obj\
!if $(DIM_SUPPORT)
$(CORE_PATH)bus.obj\
$(CORE_PATH)busmsg.obj\
!if $(GPC_SUPPORT) && $(USB_SUPPORT)
$(BUILD_DIR)\postusb.obj\
!endif
!else
$(CORE_PATH)busdm.obj\
!endif
!if $(BUP6)
$(BUILD_DIR)\p6clk.obj\
!else
$(CORE_PATH)clk.obj\
!endif
# (CORE0205)
#$(CORE_PATH)dc.obj\	# (CORE0228-)
$(BUILD_DIR)\npost.obj\
$(BUILD_DIR)\post.obj\
$(BUILD_DIR)\oempost.obj\
!if $(ACPI_SUPPORT)
$(BUILD_DIR)\postacpi.obj\
!endif
$(CORE_PATH)gs1.obj\
$(BUILD_DIR)\dbug.obj\
$(CORE_PATH)bsp.obj\
$(CORE_PATH)cpu1.obj\
!if ("$(NCPU)" == "1")
$(CORE_PATH)scpu1.obj\
!else
$(CORE_PATH)mcpu1.obj\
!endif
$(BUILD_DIR)\postcpu.obj\
#(CORE0072+)>
!if $(GPNV_SUPPORT)
!if $(GPNV_FLASH)
$(CORE_PATH)\gpnvim.obj\
!else
$(CORE_PATH)\gpnvi.obj\
!endif
$(CORE_PATH)\me0g.obj\
!else
$(CORE_PATH)\me0.obj\
!endif
#<(CORE0072+)
!if $(BUP6)
$(BUILD_DIR)\l2cache.obj\
!endif
# (CORE0205)
### (CORE0228-)>
##!if $(DISP_PCIPNP)
##$(BUILD_DIR)\devinfo.obj\
##!endif
###(CORE0072-)>
###$(CORE_PATH)me0.obj\
###<(CORE0072-)
### (CORE0205)
!if $(DISP_PCIPNP)
$(CORE_PATH)me5pci.obj\
!else
$(CORE_PATH)me5.obj\
!endif
### <(CORE0228-)
!if $(INC_EISA)
$(CORE_PATH)me7eisa.obj\
!else
$(CORE_PATH)me7.obj\
!endif
$(BUILD_DIR)\message.obj\
$(CORE_PATH)pse.obj
#-----------------------------------------------------------------------#
# Build list of OBJs needed for BIOS SETUP				#
#-----------------------------------------------------------------------#
SETUP_OBJS =\
$(CORE_PATH)ds.obj\
$(CORE_PATH)ramdata.obj\
$(BUILD_DIR)\setupdat.obj\
# $$$CORE0020- >>>
#$(BUILD_DIR)\setupmsg.obj\
# $$$CORE0020- <<<
$(BUILD_DIR)\nextfunc.obj\
$(BUILD_DIR)\extfunc.obj\
$(CORE_PATH)bootext.obj\
!ifdef SETUP_IO_OBJS
$(CORE_PATH)$(SETUP_IO_OBJS)\
!endif
!if $(BIOS_FLOPPY_SWAP)
$(CORE_PATH)cmos.obj\
!else
$(CORE_PATH)n-cmos.obj\
!endif
$(CORE_PATH)hs.obj\
$(BUILD_DIR)\setup.obj\
$(BUILD_DIR)\oemsetup.obj\
$(BUILD_DIR)\nsetup.obj\
$(CORE_PATH)launch.obj\
$(CORE_PATH)lang.obj\
$(CORE_PATH)sdmisc.obj\
# $$$CORE0020 >>>
$(BUILD_DIR)\setupmsg.obj\
# $$$CORE0020 <<<
$(CORE_PATH)pse.obj
#-----------------------------------------------------------------------#
# Build lists of core OBJs needed for runtime BIOS			#
#-----------------------------------------------------------------------#
RT0_OBJS=\
$(BUILD_DIR)\dr.obj

RT1_OBJS=\
$(CORE_PATH)disr.obj\

RT10_OBJS=\
$(BUILD_DIR)\setupequ.obj\
$(BUILD_DIR)\setuprd.obj\
#(CORE0072+)>
!if $(DMI_SUPPORT)
$(CORE_PATH)\ri.obj\
!endif
#<(CORE0072+)
$(BUILD_DIR)\flash.obj\
$(BUILD_DIR)\oemflash.obj\
$(BUILD_DIR)\oemiotbl.obj\
$(CORE_PATH)bios.obj\
$(CORE_PATH)pmode.obj\
$(CORE_PATH)int15.obj\
$(CORE_PATH)int19.obj\
!if $(I2O_SUPPORT)
$(CORE_PATH)int19i2o.obj\
!endif
$(CORE_PATH)int9.obj\
$(CORE_PATH)int10dm.obj\
$(CORE_PATH)ps.obj

RT2_OBJS =\
!if $(BIOS_FLOPPY_SWAP)
$(CORE_PATH)bsr.obj\
!else
$(CORE_PATH)n-bsr.obj\
!endif
!if $(FLOPTICAL)
$(CORE_PATH)auto.obj\
!else
$(CORE_PATH)autonafd.obj\
!endif
$(CORE_PATH)relocate.obj\
$(CORE_PATH)int16.obj\
$(CORE_PATH)int2.obj\
$(CORE_PATH)int1a.obj\
$(CORE_PATH)si.obj\
$(BUILD_DIR)\cpudata.obj\
$(CORE_PATH)cpu2.obj\
!if ("$(NCPU)" == "1")
$(CORE_PATH)scpu2.obj\
!else
$(CORE_PATH)mcpu2.obj\
!endif
$(BUILD_DIR)\runcpu.obj\
!if $(EXTRA_INT16)
$(BUILD_DIR)\i16.obj\
!else
$(BUILD_DIR)\i16dm.obj\
!endif
$(CORE_PATH)fpu2.obj\
!if ($(BUP6) && $(FLASH_4GB))
$(BUILD_DIR)\bup6.obj\
!endif
$(BUILD_DIR)\runtime.obj\
!if $(ACPI_SUPPORT)
$(BUILD_DIR)\runacpi.obj\
!endif
$(BUILD_DIR)\nruntime.obj\
$(BUILD_DIR)\oemrun.obj\
!if $(TURBO_SWITCH)
$(BUILD_DIR)\turbo.obj\
!endif
$(BUILD_DIR)\mpfpstr.obj\
!if $(GPC_SUPPORT)
$(BUILD_DIR)\gapmnsmi.obj\
!else
$(BUILD_DIR)\gapmnsdm.obj\
!endif
!if $(SPLIT_ROM)			# (CORE0073)>
$(CORE_PATH)ui0.obj\
!else
$(CORE_PATH)ui.obj\
!endif					# <(CORE0073)
$(CORE_PATH)in.obj\
!if $(SILENT_BOOT)
!if $(ML_MODULE)
$(CORE_PATH)outml.obj\
!else
$(CORE_PATH)out.obj\
!endif
!else
!if $(ML_MODULE)
$(CORE_PATH)outnml.obj\
!else
$(CORE_PATH)outn.obj\
!endif
!endif
$(CORE_PATH)remnhdm.obj\
$(CORE_PATH)me6.obj\
!if $(INC_EISA)
$(CORE_PATH)me8.obj
!else
$(CORE_PATH)me8dm.obj
!endif

RTDUMMY_OBJS=\
$(CORE_PATH)cfdummy.obj\
$(CORE_PATH)jmpdummy.obj\
$(CORE_PATH)ramdata.obj
#-----------------------------------------------------------------------#
# Build list of OBJs needed for INT13 Module				#
#-----------------------------------------------------------------------#
INT13_RUNTIME_OBJS =\
$(CORE_PATH)int13.obj\
$(CORE_PATH)hd.obj\
#$$$CORE0066>
!if $(FLOPTICAL)
$(CORE_PATH)mo.obj\
!else
$(CORE_PATH)modm.obj\
!endif
#<$$$CORE0066
$(CORE_PATH)relocate.obj\
$(CORE_PATH)buside.obj\
!if $(I2O_SUPPORT)
$(CORE_PATH)i2o.obj\
!endif
!if $(VIRUS)
$(CORE_PATH)vp.obj\
!else
$(CORE_PATH)vpdm.obj\
!endif
!if $(FLOPPY_3MODE)
!	if $(BIOS_FLOPPY_SWAP)
$(CORE_PATH)fd3.obj\
!	else
$(CORE_PATH)n-fd3.obj\
!	endif
!else
!	if $(BIOS_FLOPPY_SWAP)
$(CORE_PATH)fd.obj\
!	else
$(CORE_PATH)n-fd.obj\
!	endif
!endif
$(CORE_PATH)cdr.obj\
!if $(FLOPTICAL)
$(CORE_PATH)afd.obj\
!else
$(CORE_PATH)afdm.obj\
!endif
!if $(FLOPTICAL)
$(CORE_PATH)auto.obj\
!else
$(CORE_PATH)autonafd.obj\
!endif
$(CORE_PATH)ibcom.obj\
$(CORE_PATH)int13re.obj

INT13_POST_OBJS =\
$(CORE_PATH)hi.obj\
!if $(SMART_IDE)
$(CORE_PATH)smart.obj\
!endif
!if $(I2O_SUPPORT)
$(CORE_PATH)i2oi.obj\
!endif
!if $(BIOS_FLOPPY_SWAP)
$(CORE_PATH)fi.obj\
!else
$(CORE_PATH)n-fi.obj\
!endif
$(CORE_PATH)cdi.obj\
!if $(FLOPTICAL)
$(CORE_PATH)afdi.obj\
!endif
!if $(I2O_SUPPORT)
$(CORE_PATH)me6i2o.obj\
!else
$(CORE_PATH)me6.obj\
!endif
$(BUILD_DIR)\setupequ.obj\
$(CORE_PATH)int13pe.obj
# (CORE0071)>
#-----------------------------------------------------------------------#
#			Flash OBJ Group for Init			#
#-----------------------------------------------------------------------#
# (CORE0212+)
INIFLASH_OBJS = $(CORE_PATH)b-c.obj

!if $(INTEL)
!	if $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bi8002.obj
!	else
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bi8001.obj
!	endif
!endif
!if $(AMD)
!	if $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bam9002.obj
!	else
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bam9010.obj
!	endif
!endif
!if $(SST) || $(WINBOND) || $(ATMEL)
!	if $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bs9020.obj
!	else
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bs9010.obj
!	endif
!endif
!if $(ATMEL)
!	if $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bat9020.obj
!	else
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bat9010.obj
!	endif
!endif
!if $(WINBOND)
!	if $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bw9020.obj
!	else
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bw9011.obj
!	endif
!endif
!if $(MXIC) || $(MXIC_P) || $(MXIC_T)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx81-c.obj
!endif
!if $(MXIC)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx8100.obj
!endif
!if $(MXIC_P)
!	if $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx8200p.obj
!	else
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx8100p.obj
!	endif
!endif
!if $(MXIC_T) && $(BIOS_SIZE)==2
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx8200t.obj
!endif
					# (CORE0212)>
					# (CORE0208+)>
					# (CORE0216),(CORE0224)>
!if ( $(BIOS_SIZE)==2 && ($(AMD) || $(MXIC_29F002T)) )\
|| ( $(BIOS_SIZE)==2 && $(AT49F002T) )\
|| ( $(BIOS_SIZE)==2 && $(PMC29F002T) )
					# <(CORE0216),(CORE0224)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bammx.obj
!endif
!if $(BIOS_SIZE)==2 && $(MXIC_29F002T)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx9002t.obj
!endif
					# <(CORE0208+)
					# (CORE0215)
!if $(BIOS_SIZE)==2 && ($(AMD) || $(MXIC_29F002T) || $(MOSEL_V29C51002T))
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bammxinf.obj
!endif
					# <(CORE0212)
					# (CORE0213+)>
!if $(BIOS_SIZE)==1 && $(MXIC_29F001T)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmx9001t.obj
!endif
					# <(CORE0213+)
					# (CORE0215+)>
!if $(BIOS_SIZE)==2 && $(MOSEL_V29C51002T)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bmo002t.obj
!endif
					# <(CORE0215+)
					# (CORE0216+)>
!if $(BIOS_SIZE)==2 && $(AT49F002T)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bat9002t.obj
!endif
					# <(CORE0216+)
					# (CORE0224+)>
!if $(BIOS_SIZE)==2 && $(PMC29F002T)
INIFLASH_OBJS =$(INIFLASH_OBJS)\
$(CORE_PATH)bpm9002t.obj
!endif
					# <(CORE0224+)

#-----------------------------------------------------------------------#
# Build list OBJs needed for .INI file					#
#-----------------------------------------------------------------------#
!if ("$(BIOS_SIZE)" == "2")		# Init code size is 16k		#
INI_OBJS =\
$(CORE_PATH)bcf.obj\
!if $(NO_BOOTBLOCK)			# (CORE0073)>
$(CORE_PATH)ub0.obj\
!else
$(CORE_PATH)ub.obj\
!endif					# <(CORE0073)
$(CORE_PATH)pmode.obj\
!if $(NO_BOOTBLOCK)			# (CORE0073)>
$(CORE_PATH)up0.obj\
!else
$(CORE_PATH)up.obj\
!endif					# <(CORE0073)
!if $(NO_BOOTBLOCK)==0			# (CORE0073)
$(CORE_PATH)b_floppy.obj\
# (CORE0211+)>
!if $(BOOTBLOCK_LS120)
$(CORE_PATH)b_atapi.obj\
!endif
# <(CORE0211+)
$(CORE_PATH)b_flash.obj\
!endif					# (CORE0073)
$(BUILD_DIR)\flsinfo.obj

!if $(NO_BOOTBLOCK)==0			# (CORE0073)
INI_OBJS =$(INI_OBJS)\
$(INIFLASH_OBJS)
!endif					# (CORE0073)

INI_OBJS =$(INI_OBJS)\
$(CORE_PATH)bcfe.obj

INI_OBJS =$(INI_OBJS)\
$(CORE_PATH)ucf.obj\
$(BUILD_DIR)\flash.obj\
$(BUILD_DIR)\oemflash.obj\
$(BUILD_DIR)\oemiotbb.obj\
$(BUILD_DIR)\flashio.obj\
$(BUILD_DIR)\memory.obj\
$(BUILD_DIR)\oemmemry.obj

!else					# Init code size is 8k		#
INI_OBJS =\
$(CORE_PATH)ucf.obj\
!if $(NO_BOOTBLOCK)			# (CORE0073)>
$(CORE_PATH)ub0.obj\
!else
$(CORE_PATH)ub.obj\
!endif					# <(CORE0073)
$(CORE_PATH)pmode.obj\
!if $(NO_BOOTBLOCK)			# (CORE0073)>
$(CORE_PATH)up0.obj\
!else
$(CORE_PATH)up.obj\
!endif					# <(CORE0073)
!if $(NO_BOOTBLOCK)==0			# (CORE0073)
$(CORE_PATH)b_floppy.obj\
$(CORE_PATH)b_flash.obj\
!endif					# (CORE0073)
$(BUILD_DIR)\flsinfo.obj

!if $(NO_BOOTBLOCK)==0			# (CORE0073)
INI_OBJS =$(INI_OBJS)\
$(INIFLASH_OBJS)
!endif					# (CORE0073)

INI_OBJS =$(INI_OBJS)\
$(BUILD_DIR)\flash.obj\
$(BUILD_DIR)\oemflash.obj\
$(BUILD_DIR)\oemiotbb.obj\
$(BUILD_DIR)\flashio.obj\
$(BUILD_DIR)\memory.obj\
$(BUILD_DIR)\oemmemry.obj

!endif
# <(CORE0071)
#-----------------------------------------------------------------------#
# Build list OBJs needed for .MPS file					#
#-----------------------------------------------------------------------#
!if $(MPS_SUPPORT)
MPS_OBJS =\
$(BUILD_DIR)\mptable.obj\
$(BUILD_DIR)\mppost.obj
!endif
#-----------------------------------------------------------------------#
# Build list OBJs needed for .ACP file					#
#-----------------------------------------------------------------------#
!if $(ACPI_SUPPORT)
ACPI_TABLE_OBJS =\
$(BUILD_DIR)\acpitbl.obj
!endif
#-----------------------------------------------------------------------#
# Build list OBJs needed for .GPC file					#
#-----------------------------------------------------------------------#
!if $(GPC_SUPPORT)
GPC_OBJS =\
$(BUILD_DIR)\gpm.obj\
!if $(USB_SUPPORT)
$(BUILD_DIR)\usb.obj\
!if $(USB_UHCI_OHCI)
$(BUILD_DIR)\ohci.obj\
!else
$(BUILD_DIR)\uhci.obj\
!endif
$(BUILD_DIR)\usbkbd.obj\
$(BUILD_DIR)\smipci.obj\
$(BUILD_DIR)\gpcusb.obj\
!endif
$(BUILD_DIR)\setupequ.obj
!endif
#-----------------------------------------------------------------------#
# Build list OBJs needed for .BBC file					#
#-----------------------------------------------------------------------#
BBC_OBJS =\
$(CORE_PATH)uui.obj\
$(CORE_PATH)uzdat.obj\
$(CORE_PATH)uz.obj
#-----------------------------------------------------------------------#
