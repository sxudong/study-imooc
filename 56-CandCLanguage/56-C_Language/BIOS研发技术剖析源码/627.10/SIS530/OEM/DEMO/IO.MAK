#     *****************************************************************;
#     *****************************************************************;
#     **                                                             **;
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
#     **                                                             **;
#     **                     All Rights Reserved.                    **;
#     **                                                             **;
#     **           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
#     **                                                             **;
#     **                     Phone (770)-246-8600                    **;
#     **                                                             **;
#     *****************************************************************;
#     *****************************************************************;
#-----------------------------------------------------------------------#
#			SELECT IO MODULE				#
#-----------------------------------------------------------------------#
# NOTE TO ENGINEERS							#
# 1. Select the IO chipset present in the motherboard by setting the	#
#    corresponding switch to 1.						#
#    For example, if SMC665 is present in motherboard, set SMC665 = 1.	#
# 2. If onboard PCI IDE controller is present, please ADD the proper	#
#    routine in IO_PERIPHERALS in BIOS.MAK file. The corresponding	#
#    IOC.ASM and IOC.SSP file for PCI IDE is in CHIPSET\IO directory.	#
# 3. Generally you do not need to do anything else.			#
# 4. But there are execptions. This make file is generated based on	#
#    following ASSUMPTIONs						#
#    a) IDE support is NOT USED from any of these IO Chipsets.		#
#	Nowadays IDE support is generally provided by onboard PCI IDE	#
#	chipset e.g. Intel Triton IDE (PIIX, PIIX3, etc.), SiS PCI IDE,	#
#	CMD PCI IDE, etc.						#
#    b) All other devices (e.g. COM1, COM2, LPT, KBC, RTC, FDC) present	#
#	in the IO chipset are used in the motherboard.			#
# 5. If any one of the above assumptions is NOT valid, you may need to	#
#    change/modify different switches according to the requirement.	#
#    For example:							#
#    a) If system is an EISA system					#
#	   AND {(chipset does not have any PCI-EISA Bridge)		#
#		OR (PCI-EISA Bridge does not have proper class code)}	#
#	please add "SystemEisaBus" to IO_PERIPHERALS.			#
#    b) If system is an ISA system					#
#	   AND {(chipset does not have any PCI-ISA Bridge)		#
#		OR (PCI-ISA Bridge does not have proper class code)}	#
#	please add "SystemIsaBus" to IO_PERIPHERALS.			#
#    c) If SMC932 is used but KBC is not used from SMC932, please TAKE	#
#	OUT the "Smc932BBlkKeyboardControllerAuto" from SMC932 block in	#
#	BOOT_KBC_RTC.							#
#    d) If SMC932 is used but RTC is not used from SMC932, please TAKE	#
#	OUT the "Smc932BBlkRTCControllerAuto" from SMC932 block in	#
#	BOOT_KBC_RTC.							#
#    e) If NAT306 is used and also IDE support is used from NAT306,	#
#	please ADD the "Nat306IdeController" in the NAT306 block in	#
#	IO_PERIPHERALS.							#
# 6. The above examples are only a few of the many possible exceptions.	#
#    If your requirement is different from the above execptions, please	#
#    do it accordingly OR contact AMI.					#
# 7. If BIOS does not build with the selected IO support, please contact#
#    AMI for proper/latest IO library (IO.LIB, IO.PUB, IO*.SSP files).	#
#-----------------------------------------------------------------------#
#	Select Index Port, Data Port, Unlock Value (if any)		#
#-----------------------------------------------------------------------#
# I/O Chipset     Possible Index     Possible Data     Possible Unlock Value
# -----------	  --------------     -------------     ---------------------
# AIP             22/24/26E/398      23/25/26F/399
# ALI5105	  Not used	     Not used
# ALI5113	  Not used	     3F1/398
# ALI5119	  Not used	     Not used		19/29
# ALI5123	  3F0/370	     3F1/371
# CT711           3F0                3F1
# CT712           3F0                3F1
# CT735           3F0                3F1
# DS83CH20	  2E		     2F
# GM803B	  398		     399
# GM803C	  398		     399
# ITE8661         3F0/3BD/370        3F1/3BE/371
# ITE8680         3F0/3BD/370        3F1/3BE/371
# Nat303          398/26E/15C/2E     399/26F/15D/2F
# Nat306          398/26E/15C/2E     399/26F/15D/2F
# Nat307          15C/2E             15D/2F
# Nat308          15C/2E             15D/2F
# Nat312          398/26E     	     399/26F
# Nat322          398/26E	     399/26F
# Nat332          398/26E/15C/2E     399/26F/15D/2F
# Nat336          398/15C/2E/Any     399/15D/2F/(Any+1)
# Nat338          398/15C/2E/Any     399/15D/2F/(Any+1)
# SMC651          3F0                3F1
# SMC661          3F0                3F1
# SMC665          3F0                3F1
# SMC665IR        3F0                3F1
# SMC669          3F0/370            3F1/371
# SMC669FR        3F0/370            3F1/371
# SMC67X          3F0/370            3F1/371
# SMC68X          3F0/370            3F1/371
# SMC922          3F0/370            3F1/371
# SMC932          3F0/370            3F1/371
# SMC932FR        3F0/370            3F1/371
# SMC957          3F0/370            3F1/371
# UMC8663	  108		     109
# UMC8663B	  108		     109
# UMC8669 (Note2) 108		     109
# Win787          251                252               88/89
# Win787IF        251                252               88/89
# Win877          3F0                3F1               86/87
#		  251                252               88/89
# NOTE1 : For Winbond 787(IF)/877, if the unlock data is 88h/89h then the
# port used to enable the access to the configuration registers is 250h,
# the index port is 251h, the data port is 252h.
#
# NOTE2 : Also specify an I/O port for the ISA PnP RD_DATA port - In the
#	  range of 203h - 3FFh
#-----------------------------------------------------------------------#
IO_INDEX_PORT	= 3f0h	#index port should be 3f0h 		# Index Port e.g. 3F0h			#
IO_DATA_PORT	= 3f1h	#index port should be 3f1h 		# Data Port e.g. 3F1h			#
IO_UNLOCK_DATA	= 087h      	# e.g. 87h for Winbond877		#
IO_ISA_PNP_DATA_PORT = 		# RD_DATA Port e.g. 203h for UMC8669	#
#-----------------------------------------------------------------------#
#		ONLY ONE IO SHOULD BE SELECTED				#
#-----------------------------------------------------------------------#
AIP			= 0	# 1 = Include Intel AIP			#
ALI5105			= 0	# 1 = Include ALI 5105			#
ALI5113			= 0	# 1 = Include ALI 5113			#
ALI5119			= 0	# 1 = Include ALI 5119			#
ALI5123			= 0	# 1 = Include ALI 5123			#
CT735			= 0	# 1 = Include CT735			#
DSCH20			= 0	# 1 = Include Dallas DS83CH20		#
GM803B			= 0	# 1 = Include LG Semicon GM82C803B	#
GM803C			= 0	# 1 = Include LG Semicon GM82C803C	#
ITE8661			= 1	# 1 = Include ITE 8661			#
ITE8680			= 0	# 1 = Include ITE 8680			#
NAT303			= 0	# 1 = Include National 303		#
NAT306			= 0	# 1 = Include National 306		#
NAT307			= 0	# 1 = Include National 307		#
NAT308			= 0	# 1 = Include National 308		#
NAT312			= 0	# 1 = Include National 312		#
NAT322			= 0	# 1 = Include National 322		#
NAT332			= 0	# 1 = Include National 332		#
NAT336			= 0	# 1 = Include National 336		#
NAT338			= 0	# 1 = Include National 338		#
SMC651_SMC661_CT711_CT721 = 0	# 1 = Include SMC651/SMC661/CT711/CT721	#
SMC665			= 0	# 1 = Include SMC665			#
SMC665IR		= 0	# 1 = Include SMC665IR			#
SMC669			= 0	# 1 = Include SMC669			#
SMC669FR		= 0	# 1 = Include SMC669FR			#
SMC67X                  = 0     # 1 = Include SMC67X                    #
SMC68X			= 0	# 1 = Include SMC68X			#
SMC922                  = 0     # 1 = Include SMC922                    #
SMC932_SMC935		= 0	# 1 = Include SMC932/SMC935		#
SMC932FR                = 0     # 1 = Include SMC932FR                  #
SMC957			= 0	# 1 = Include SMC957			#
UMC8663                 = 0     # 1 = Include UMC 8663                  #
UMC8663B		= 0	# 1 = Include UMC 8663B			#
UMC8669			= 0	# 1 = Include UMC 8669			#
WIN787_WIN777		= 0	# 1 = Include Winbond 83787F/83777F	#
WIN787IF		= 0	# 1 = Include Winbond 83787IF		#
WIN877			= 0	# 1 = Include Winbond 83877		#
WIN977			= 0	# 1 = Include Winbond 83977		#
#-----------------------------------------------------------------------#
#		I/O CHIPSET SUPPORT IN BOOT BLOCK			#
#-----------------------------------------------------------------------#
# select the I/O peripheral for Boot Block code.			#
# BOOT_KBC_RTC	selects KBC and RTC routines controlled by I/O chipset.	#

BOOT_KBC_RTC	=
!if $(ALI5123)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Ali5123BBlkRTCControllerAuto\
Ali5123BBlkKeyboardControllerAuto
!endif
!if $(DSCH20)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Dsch20BBlkRTCControllerAuto\
Dsch20BBlkKeyboardControllerAuto
!endif
!if $(ITE8680)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
IT8680BBlkRTCControllerAuto\
IT8680BBlkKeyboardControllerAuto
!endif
!if $(NAT303)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Nat303BBlkRTCControllerAuto\
Nat303BBlkKeyboardControllerAuto
!endif
!if $(NAT306)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Nat306BBlkRTCControllerAuto\
Nat306BBlkKeyboardControllerAuto
!endif
!if $(NAT307)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Nat307BBlkRTCControllerAuto\
Nat307BBlkKeyboardControllerAuto
!endif
!if $(NAT308)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Nat308BBlkRTCControllerAuto\
Nat308BBlkKeyboardControllerAuto
!endif
!if $(SMC67X)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Smc67xBBlkKeyboardControllerAuto
!endif
!if $(SMC68X)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Smc68xBBlkKeyboardControllerAuto
!endif
!if $(SMC922)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Smc922BBlkKeyboardControllerAuto\
Smc922BBlkRTCControllerAuto
!endif
!if $(SMC932_SMC935) || $(SMC932FR)
BOOT_KBC_RTC    = $(BOOT_KBC_RTC)\
Smc932BBlkKeyboardControllerAuto\
Smc932BBlkRTCControllerOff
!endif
!if $(SMC957)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Smc957BBlkKeyboardControllerAuto\
Smc957BBlkRTCControllerAuto
!endif
!if $(WIN977)
BOOT_KBC_RTC	= $(BOOT_KBC_RTC)\
Win977BBlkKeyboardControllerAuto\
Win977BBlkRTCControllerOff
!endif


# BOOT_FDC	selects the FDC routines controlled by I/O chipset.	#

BOOT_FDC	=
!if $(AIP)
BOOT_FDC	= $(BOOT_FDC)\
AIPBBlkFloppyControllerAuto
!endif
!if $(ALI5105)
BOOT_FDC	= $(BOOT_FDC)\
Ali5105BBlkFloppyControllerAuto
!endif
!if $(ALI5113)
BOOT_FDC	= $(BOOT_FDC)\
Ali5113BBlkFloppyControllerAuto
!endif
!if $(ALI5119)
BOOT_FDC	= $(BOOT_FDC)\
Ali5119BBlkFloppyControllerAuto
!endif
!if $(ALI5123)
BOOT_FDC	= $(BOOT_FDC)\
Ali5123BBlkFloppyControllerAuto
!endif
!if $(CT735)
BOOT_FDC	= $(BOOT_FDC)\
Ct735BBlkFloppyControllerAuto
!endif
!if $(DSCH20)
BOOT_FDC	= $(BOOT_FDC)\
Dsch20BBlkFloppyControllerAuto
!endif
!if $(GM803B)
BOOT_FDC	= $(BOOT_FDC)\
Gm803BBBlkFloppyControllerAuto
!endif
!if $(GM803C)
BOOT_FDC	= $(BOOT_FDC)\
Gm803CBBlkFloppyControllerAuto
!endif
!if $(ITE8661)  
BOOT_FDC	= $(BOOT_FDC)\
IT8661FBBlkFloppyControllerAuto
!endif
!if $(ITE8680)
BOOT_FDC	= $(BOOT_FDC)\
IT8680BBlkFloppyControllerAuto
!endif
!if $(NAT303)
BOOT_FDC	= $(BOOT_FDC)\
Nat303BBlkFloppyControllerAuto
!endif
!if $(NAT306)
BOOT_FDC	= $(BOOT_FDC)\
Nat306BBlkFloppyControllerAuto
!endif
!if $(NAT307)
BOOT_FDC	= $(BOOT_FDC)\
Nat307BBlkFloppyControllerAuto
!endif
!if $(NAT308)
BOOT_FDC	= $(BOOT_FDC)\
Nat308BBlkFloppyControllerAuto
!endif
!if $(NAT312)
BOOT_FDC	= $(BOOT_FDC)\
Nat312BBlkFloppyControllerAuto
!endif
!if $(NAT322)
BOOT_FDC	= $(BOOT_FDC)\
Nat322BBlkFloppyControllerAuto
!endif
!if $(NAT332)
BOOT_FDC	= $(BOOT_FDC)\
Nat332BBlkFloppyControllerAuto
!endif
!if $(NAT336)
BOOT_FDC	= $(BOOT_FDC)\
Nat336BBlkFloppyControllerAuto
!endif
!if $(NAT338)
BOOT_FDC	= $(BOOT_FDC)\
Nat338BBlkFloppyControllerAuto
!endif
!if $(SMC651_SMC661_CT711_CT721)
BOOT_FDC	= $(BOOT_FDC)\
Smc651BBlkFloppyControllerAuto
!endif
!if $(SMC665)
BOOT_FDC	= $(BOOT_FDC)\
Smc665BBlkFloppyControllerAuto
!endif
!if $(SMC665IR)
BOOT_FDC	= $(BOOT_FDC)\
Smc665IrBBlkFloppyControllerAuto
!endif
!if $(SMC669)
BOOT_FDC	= $(BOOT_FDC)\
Smc669BBlkFloppyControllerAuto
!endif
!if $(SMC669FR)
BOOT_FDC	= $(BOOT_FDC)\
Smc669FrBBlkFloppyControllerAuto
!endif
!if $(SMC67X)
BOOT_FDC	= $(BOOT_FDC)\
Smc67xBBlkFloppyControllerAuto
!endif
!if $(SMC68X)
BOOT_FDC	= $(BOOT_FDC)\
Smc68xBBlkFloppyControllerAuto
!endif
!if $(SMC922)
BOOT_FDC	= $(BOOT_FDC)\
Smc922BBlkFloppyControllerAuto
!endif
!if $(SMC932_SMC935) || $(SMC932FR)
BOOT_FDC        = $(BOOT_FDC)\
Smc932BBlkFloppyControllerAuto
!endif
!if $(SMC957)
BOOT_FDC	= $(BOOT_FDC)\
Smc957BBlkFloppyControllerAuto
!endif
!if $(UMC8663)
BOOT_FDC	= $(BOOT_FDC)\
Umc8663BBlkFloppyControllerAuto
!endif
!if $(UMC8663B)
BOOT_FDC	= $(BOOT_FDC)\
Umc8663BBBlkFloppyControllerAuto
!endif
!if $(UMC8669)
BOOT_FDC	= $(BOOT_FDC)\
Umc8669BBlkFloppyControllerAuto
!endif
!if $(WIN787_WIN777)
BOOT_FDC	= $(BOOT_FDC)\
Win787BBlkFloppyControllerAuto
!endif
!if $(WIN787IF)
BOOT_FDC	= $(BOOT_FDC)\
Win787IFBBlkFloppyControllerAuto
!endif
!if $(WIN877)
BOOT_FDC	= $(BOOT_FDC)\
Win877BBlkFloppyControllerAuto
!endif
!if $(WIN977)
BOOT_FDC	= $(BOOT_FDC)\
Win977BBlkFloppyControllerAuto
!endif
#-----------------------------------------------------------------------#
#		ONBOARD I/O PERIPHERALS SUPPORT FOR MAIN BIOS		#
#-----------------------------------------------------------------------#
IO_PERIPHERALS	=\
SystemMemory\
SystemInterruptController\
SystemDmaController\
SystemTimer\
SystemRealTimeClock\
SystemKeyboardController\
SystemSpeaker\
SystemMathCoprocessor

!if $(AIP)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
AIPSerialPortA\
AIPSerialPortB\
AIPParallelPortExt\
AIPFloppyController
!endif
!if $(ALI5105)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Ali5105SerialPortA\
Ali5105SerialPortB\
Ali5105ParallelPort\
Ali5105FloppyController
!endif
!if $(ALI5113)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Ali5113SerialPortA\
Ali5113SerialPortB\
Ali5113ParallelPortExt\
Ali5113FloppyController
!endif
!if $(ALI5119)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Ali5119SerialPortA\
Ali5119SerialPortB\
Ali5119ParallelPortExt\
Ali5119FloppyController
!endif
!if $(ALI5123)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Ali5123SerialPortA\
Ali5123SerialPortB\
Ali5123ParallelPortExt\
Ali5123FloppyController
!endif
!if $(CT735)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Ct735SerialPortA\
Ct735SerialPortB\
Ct735ParallelPortExt\
Ct735FloppyController
!endif
!if $(DSCH20)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Dsch20SerialPortA\
Dsch20SerialPortB\
Dsch20ParallelPortExt\
Dsch20FloppyController
!endif
!if $(GM803B)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Gm803BSerialPortA\
Gm803BSerialPortB\
Gm803BParallelPortExt\
Gm803BFloppyController
!endif
!if $(GM803C)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Gm803CSerialPortA\
Gm803CSerialPortB\
Gm803CParallelPortExt\
Gm803CFloppyController
!endif
!if $(ITE8661)  
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
IT8661FSerialPortA\
IT8661FSerialPortB\
IT8661FIrPort\
IT8661FParallelPortExt\
IT8661FFloppyController
!endif
!if $(ITE8680)   
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
IT8680SerialPortA\
IT8680SerialPortB\
IT8680ParallelPortExt\
IT8680FloppyController
!endif
!if $(NAT303)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat303SerialPortA\
Nat303SerialPortB\
Nat303ParallelPortExt\
Nat303FloppyController
!endif
!if $(NAT306)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat306SerialPortA\
Nat306SerialPortB\
Nat306ParallelPortExt\
Nat306FloppyController
!endif
!if $(NAT308)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat308SerialPortA\
Nat308SerialPortB\
Nat308ParallelPortExt\
Nat308FloppyController
!endif
!if $(NAT307)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat307SerialPortA\
Nat307SerialPortB\
Nat307ParallelPortExt\
Nat307FloppyController
!endif
!if $(NAT312)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat312SerialPortA\
Nat312SerialPortB\
Nat312ParallelPort\
Nat312FloppyController
!endif
!if $(NAT322)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat322SerialPortA\
Nat322SerialPortB\
Nat322ParallelPortExt\
Nat322FloppyController
!endif
!if $(NAT332)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat332SerialPortA\
Nat332SerialPortB\
Nat332ParallelPortExt\
Nat332FloppyController
!endif
!if $(NAT336)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat336SerialPortA\
Nat336SerialPortB\
Nat336ParallelPortExt\
Nat336FloppyController
!endif
!if $(NAT338)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Nat338SerialPortA\
Nat338SerialPortB\
Nat338ParallelPortExt\
Nat338FloppyController
!endif
!if $(SMC651_SMC661_CT711_CT721)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc651SerialPortA\
Smc651SerialPortB\
Smc651ParallelPort\
Smc651FloppyController
!endif
!if $(SMC665)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc665SerialPortA\
Smc665SerialPortB\
Smc665ParallelPortExt\
Smc665FloppyController
!endif
!if $(SMC665IR)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc665IrSerialPortA\
Smc665IrSerialPortB\
Smc665IrParallelPortExt\
Smc665IrFloppyController
!endif
!if $(SMC669)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc669SerialPortA\
Smc669SerialPortB\
Smc669ParallelPortExt\
Smc669FloppyController
!endif
!if $(SMC669FR)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc669FrSerialPortA\
Smc669FrSerialPortB\
Smc669FrParallelPortExt\
Smc669FrFloppyController
!endif
!if $(SMC67X)
SERIAL_IRQ	= 1
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc67xSerialPortA\
Smc67xSerialPortB\
Smc67xParallelPortExt\
Smc67xFloppyController
!endif
!if $(SMC68X)
SERIAL_IRQ	= 1
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc68xSerialPortA\
Smc68xSerialPortB\
Smc68xParallelPortExt\
Smc68xFloppyController
!endif
!if $(SMC922)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc922SerialPortA\
Smc922SerialPortB\
Smc922ParallelPortExt\
Smc922FloppyController
!endif
!if $(SMC932_SMC935)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc932SerialPortA\
Smc932SerialPortB\
Smc932ParallelPortExt\
Smc932FloppyController
!endif
!if $(SMC932FR)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc932SerialPortA\
Smc932FrSerialPortB\
Smc932ParallelPortExt\
Smc932FloppyController
!endif
!if $(SMC957)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Smc957SerialPortA\
Smc957SerialPortB\
Smc957ParallelPortExt\
Smc957FloppyController
!endif
!if $(UMC8663)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Umc8663SerialPortA\
Umc8663SerialPortB\
Umc8663ParallelPortExt\
Umc8663FloppyController
!endif
!if $(UMC8663B)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Umc8663BSerialPortA\
Umc8663BSerialPortB\
Umc8663BParallelPortExt\
Umc8663BFloppyController
!endif
!if $(UMC8669)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Umc8669SerialPortA\
Umc8669SerialPortB\
Umc8669ParallelPortExt\
Umc8669FloppyController
!endif
!if $(WIN787_WIN777)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Win787SerialPortA\
Win787SerialPortB\
Win787ParallelPortExt\
Win787FloppyController
!endif
!if $(WIN787IF)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Win787IFSerialPortA\
Win787IFSerialPortB\
Win787IFParallelPortExt\
Win787IFFloppyController
!endif
!if $(WIN877)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Win877SerialPortA\
Win877SerialPortB\
Win877ParallelPortExt\
Win877FloppyController
!endif
!if $(WIN977)
SERIAL_IRQ	= 0
IO_PERIPHERALS	= $(IO_PERIPHERALS)\
Win977SerialPortA\
Win977SerialPortB\
Win977IrPort\
Win977ParallelPortExt\
Win977FloppyController
!endif
#-----------------------------------------------------------------------#
!if $(AIP)
SETUP_IO_OBJS	= AIPFN.OBJ
!endif
!if $(ALI5105)
SETUP_IO_OBJS	= ALI105FN.OBJ
!endif
!if $(ALI5113)
SETUP_IO_OBJS	= ALI113FN.OBJ
!endif
!if $(ALI5119)
SETUP_IO_OBJS	= ALI119FN.OBJ
!endif
!if $(ALI5123)
SETUP_IO_OBJS	= ALI123FN.OBJ
!endif
!if $(CT735)
SETUP_IO_OBJS	= CT735FN.OBJ
!endif
!if $(DSCH20)
SETUP_IO_OBJS	= DSCH20FN.OBJ
!endif
!if $(GM803B)
SETUP_IO_OBJS	= GM803BFN.OBJ
!endif
!if $(GM803C)
SETUP_IO_OBJS	= GM803CFN.OBJ
!endif
!if $(ITE8661)  
SETUP_IO_OBJS	= IT61FFN.OBJ
!endif
!if $(ITE8680)   
SETUP_IO_OBJS	= IT8680FN.OBJ
!endif
!if $(NAT303)
SETUP_IO_OBJS	= NAT303FN.OBJ
!endif
!if $(NAT306)
SETUP_IO_OBJS	= NAT306FN.OBJ
!endif
!if $(NAT307)
SETUP_IO_OBJS	= NAT307FN.OBJ
!endif
!if $(NAT308)
SETUP_IO_OBJS	= NAT308FN.OBJ
!endif
!if $(NAT312)
SETUP_IO_OBJS	= NAT312FN.OBJ
!endif
!if $(NAT322)
SETUP_IO_OBJS	= NAT322FN.OBJ
!endif
!if $(NAT332)
SETUP_IO_OBJS	= NAT332FN.OBJ
!endif
!if $(NAT336)
SETUP_IO_OBJS	= NAT336FN.OBJ
!endif
!if $(NAT338)
SETUP_IO_OBJS	= NAT338FN.OBJ
!endif
!if $(SMC651_SMC661_CT711_CT721)
SETUP_IO_OBJS	= SMC651FN.OBJ
!endif
!if $(SMC665)
SETUP_IO_OBJS	= SMC665FN.OBJ
!endif
!if $(SMC665IR)
SETUP_IO_OBJS	= SMC65IFN.OBJ
!endif
!if $(SMC669)
SETUP_IO_OBJS	= SMC669FN.OBJ
!endif
!if $(SMC669FR)
SETUP_IO_OBJS	= SMC69FFN.OBJ
!endif
!if $(SMC67X)
SETUP_IO_OBJS	= SMC67XFN.OBJ
!endif
!if $(SMC68X)
SETUP_IO_OBJS	= SMC68XFN.OBJ
!endif
!if $(SMC922)
SETUP_IO_OBJS	= SMC922FN.OBJ
!endif
!if $(SMC932_SMC935) || $(SMC932FR)
SETUP_IO_OBJS   = SMC932FN.OBJ
!endif
!if $(SMC957)
SETUP_IO_OBJS	= SMC957FN.OBJ
!endif
!if $(UMC8663)
SETUP_IO_OBJS	= UMC663FN.OBJ
!endif
!if $(UMC8663B)
SETUP_IO_OBJS	= UMC63BFN.OBJ
!endif
!if $(UMC8669)
SETUP_IO_OBJS	= UMC669FN.OBJ
!endif
!if $(WIN787_WIN777)
SETUP_IO_OBJS	= WIN787FN.OBJ
!endif
!if $(WIN787IF)
SETUP_IO_OBJS	= WIN87IFN.OBJ
!endif
!if $(WIN877)
SETUP_IO_OBJS	= WIN877FN.OBJ
!endif
!if $(WIN977)
SETUP_IO_OBJS	= WIN977FN.OBJ
!endif
#-----------------------------------------------------------------------#
#     *****************************************************************;
#     *****************************************************************;
#     **                                                             **;
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
#     **                                                             **;
#     **                     All Rights Reserved.                    **;
#     **                                                             **;
#     **           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
#     **                                                             **;
#     **                     Phone (770)-246-8600                    **;
#     **                                                             **;
#     *****************************************************************;
#     *****************************************************************;
