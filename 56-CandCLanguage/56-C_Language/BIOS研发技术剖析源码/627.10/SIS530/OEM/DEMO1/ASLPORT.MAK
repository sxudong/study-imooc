#********************************************************************** #
#     ***************************************************************** #
#     ***************************************************************** #
#     **                                                             ** #
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      ** #
#     **                                                             ** #
#     **                     All Rights Reserved.                    ** #
#     **                                                             ** #
#     **           6145-F Northbelt Pkwy, Norcross, GA 30071         ** #
#     **                                                             ** #
#     **                     Phone (770)-246-8600                    ** #
#     **                                                             ** #
#     ***************************************************************** #
#     ***************************************************************** #
#********************************************************************** #
#-----------------------------------------------------------------------#
# These flags should be set in order to create the ASL project files    #
#-----------------------------------------------------------------------#
#                     AML DEFINITION BLOCK                              #
#-----------------------------------------------------------------------#
A_OEM_ID                = SiS           # up to 6 characters            #
A_OEM_TABLE_ID          = 530           # up to 8 characters            #
A_OEM_REV               = 1000          # up to 4 hex digits            #
#-----------------------------------------------------------------------#
#                       SYSTEM FUNCTIONALITY                            #
#-----------------------------------------------------------------------#
A_CPU_PBLK              = 40c   # CPU Control register address          #
                                # 4 hex digits only (ef10, 410, ..)     #
                                # ""- No CPU C2 & C3 state will be available#
#-----------------------------------------------------------------------#
# Provide values to be written to PM1a_CNT.SLP_TYP register to enter    #
# corresponding sleep state                                             #
# Note. Default values for PIIX4 are S0-5, S1-4, S2-3, S3-1, S4-0, S5-0 #
# Values for S0,S5 are mandatory. Do not keep them empty.               #
A_S0                    = 0     # two hex digits                        #
A_S1                    = 1     # two hex digits, "" - not present      #
A_S2                    =       # two hex digits, "" - not present      #
A_S3                    =       # two hex digits, "" - not present      #
A_S4                    =       # two hex digits, "" - not present      #
A_S5                    = 5     # two hex digits                        #
#-----------------------------------------------------------------------#
#                       PCI BUS                                         #
#-----------------------------------------------------------------------#
# PCI North Bridge device name                                          #
# Note. The only one should be selected                                 #
#-----------------------------------------------------------------------#
A_N_I430TX              = 0     # 1 - exist, 0 - not exist              #
A_N_I440BX              = 0
A_N_I440LX              = 0
A_N_I440EX              = 0
A_N_I440GX              = 0
A_N_CAMINO              = 0
A_N_ALI1541             = 0
A_N_ALI1621             = 0
A_N_CYRIX30             = 0
A_N_FIRESTAR            = 0
A_N_SIS5598             = 0
A_N_SIS5600             = 0
A_N_SIS530              = 1     
A_N_SIS620              = 0     
A_N_VIA82588            = 0
A_N_VIA82595            = 0
A_N_VIA82691            = 0
#-----------------------------------------------------------------------#
# PCI-ISA South Bridge device name                                      #
# Note. The only one should be selected                                 #
#-----------------------------------------------------------------------#
A_S_PIIX4               = 0     # 1 - exist, 0 - not exist              #
A_S_ICH                 = 0
A_S_ALI1543             = 0
A_S_FIRESTAR            = 0
A_S_VIA82586            = 0
A_S_VIA82595            = 0
A_S_CYRIX30             = 0
A_S_SIS5595             = 1     
#-----------------------------------------------------------------------#
# PCI-ISA South bridge device number (The function number assumed as 0) #
#-----------------------------------------------------------------------#
A_S_DEV_Nbr             = 01    # 2 hex digits only                     #
#-----------------------------------------------------------------------#
#                       PCI IRQ ROUTING TABLE                           #
# Select proper routing model by providing Slot with PCI device number  #
#-----------------------------------------------------------------------#
# Provide following macro with list of IRQs available for PCI devices   #
# use "," as a separator                                                #
A_PCI_IRQ_LIST          = 3,4,5,6,7,9,10,11,12,14,15                    #
#-----------------------------------------------------------------------#
# "Standard" PCI IRQ round-robin routing method                         #
#-----------------------------------------------------------------------#
A_PCI_IRQ_ROUTE_STANDARD= 1     # 1 - present, 0 - not present          #
                                # If set = 0 the CUST_IRQ.OEM file      #
                                # will require the proper editing       #
#-----------------------------------------------------------------------#
# PCI_SLOTs 1-6 have all 4 Int pins routed onto IRQA-D of IRQ router    #
# The routing table for each slot would be :                            #
# Slot1,5,6 - ABCD, Slot2 - BCDA, Slot3 - CDAB, Slot4 - DABC            #
#-----------------------------------------------------------------------#
A_PCI_SLOT1             = 09    # 2 hex digits only, " " - no slot      #
A_PCI_SLOT2             = 
A_PCI_SLOT3             = 0b
A_PCI_SLOT4             = 0a
A_PCI_SLOT5             = 
A_PCI_SLOT6             =
#-----------------------------------------------------------------------#
# PCI_DEVices 1-4 are used to describe up to 4 onboard Device/Slots with#
# non-standard (see above) Irq routing                                  #
# IRQA-D have ONE PCI Int line(0-1) routed onto IRQA-D of the IRQ router#
#-----------------------------------------------------------------------#
# Onboard PCI device 1                                                  #
# DDDD  - PCI device number,4 hex digits                                #
# FFFF  - Device function, 4 hex digits, set ffff to describing the Slot#
# Int   - Device's Int output pin (0 to 3)                              #
# Example: 07.0001,3                                                    #
# IntA pin of PCI Device 07 Function 1 is routed to IRQA of interrupt router#
A_PCI_DEV1_IRQA         = 02.ffff, 0    # Format DDDD.FFFF, Int         #
A_PCI_DEV1_IRQB         = 02.ffff, 1 # look at comments for DEV1_IRQA   #
A_PCI_DEV1_IRQC         =
A_PCI_DEV1_IRQD         =
# Onboard PCI device 2
A_PCI_DEV2_IRQA         = 
A_PCI_DEV2_IRQB         = 
A_PCI_DEV2_IRQC         = 
A_PCI_DEV2_IRQD         = 0c.ffff, 0    # Rounting for Sound chip
# Onboard PCI device 3
A_PCI_DEV3_IRQA         =       
A_PCI_DEV3_IRQB         = 
A_PCI_DEV3_IRQC         = 
A_PCI_DEV3_IRQD         = 
# Onboard PCI device 4
A_PCI_DEV4_IRQA         =                     # look at comments for DEV1_IRQA        #
A_PCI_DEV4_IRQB         =
A_PCI_DEV4_IRQC         =
A_PCI_DEV4_IRQD         =
#-----------------------------------------------------------------------#
# APIC mode Routing table. Applies for multi CPU systems only           #
# Provide Irq number(in hex) the Device(Slot) Int line is routed to     #
#-----------------------------------------------------------------------#
A_PCI_INTA_APIC         = 10    # 2 hex digits only                     #
A_PCI_INTB_APIC         = 11    # 2 hex digits only                     #
A_PCI_INTC_APIC         = 12    # 2 hex digits only                     #
A_PCI_INTD_APIC         = 13    # 2 hex digits only                     #
#-----------------------------------------------------------------------#
#               SYSTEM MANAGEMENT                                       #
#-----------------------------------------------------------------------#
# Positive/Subtractive IO decode mode on ISA/EIO Bus                    #
A_POS_DECODE            = 0     # 1 - Positive, 0 - Subtractive(Default)#
# SMBus controller support.                                             #
A_SMBUS                 = 0     # 1 - present, 0 - not present          #
#-----------------------------------------------------------------------#
#               THERMAL MANAGEMENT                                      #
#-----------------------------------------------------------------------#
A_THERMAL               = 0     # 1 - present, 0 - not present          #
# procced Thermal settings if THERMAL = 1                               #
# Thermal Data location.                                                #
A_GET_THRM_DATA         = 0     # 1 - get the Thermal settings from CMOS#
                                # 0 - provide the Thermal settings in   #
                                # this file                             #
                                # If 1 the data appearence order is -   #
                                # TRP1, TRP2, TCRT, TSP, TC1, TC2, T_Adr#
A_THRM_INDEX_DATA_IO_Adr= 72    # Access over Index/Data mechanism(CMOS)#
                                # 4 hex digits only (ef10, 410, ..)     #
                                # " " - not present                     #
A_THRM_INDEX_DATA_IO_Ofs= 90    # 2 hex digits only (10, 90, ..)        #
# Proceed if A_GET_BIOS_DATA set as 0                                   #
A_TRP1                  = 32    # 1st thermal limit. Temperature in C   #
A_TRP2                  = 43    # 2nd thermal limit. Temperature in C   #
A_TCRT                  = 65    # Critical temperature. Temperature in C#
A_TSP                   = 10    # Sampling period. In seconds           #
A_TC1                   = 02    # 1st thermal constant                  #
A_TC2                   = 04    # 2nd thermal constant                  #
#-----------------------------------------------------------------------#
# Thermal sensor module                                                 #
#-----------------------------------------------------------------------#
# Note. The only one Thermal sensor can be selected                     #
#       There also A_SMBUS flag has to be set to provide thermal sensor #
#       with ASL interface to SMBUS                                     #
#-----------------------------------------------------------------------#
A_LM75                  = 0     # 1 - present, 0 - not present          #
A_MAX1617L              = 0     # 1 - present, 0 - not present          #
A_MAX1617R              = 0     # 1 - present, 0 - not present          #
A_LM78_9                = 0     # 0/1 Switch.One of T.sensors must be selected#
#-----------------------------------------------------------------------#
# Thermal sensor full SMBus address                                     #
A_THRM_Adr              = 30    # 2 hex digits only                     #
A_THERMAL_GPE           = 00    # GPE bit Offset                        #
                                # ""- no thermal event wired to GPE     #
                                # 2 hex digits only (..09, 0a, 0b,..)   #
                                # Example 0b -> GPE.11                  #
                                # PIIX4 PM uses GPE.0 for THRM pin      #
#-----------------------------------------------------------------------#
#               FAN COOLING DEVICE                                      #
#-----------------------------------------------------------------------#
# Note. The only one FAN model can be selected                          #
#-----------------------------------------------------------------------#
A_FAN_OEM               = 0     # Switch 0/1. Set to 1 if current fan   #
                                # control no match non of standard models#
                                # If set = 1 the CUST_FAN.OEM file      #
                                # will require the proper editing       #
#-----------------------------------------------------------------------#
# FAN IO port access method                                             #
#-----------------------------------------------------------------------#
# Note. The only one address should be provided                         #
#-----------------------------------------------------------------------#
# FAN control port inside ISA IO space                                  #
A_FAN_ISA_IO_Adr        = 434   # 4 hex digits only (ef10, 410, ..)     #
                                # " " - not present                     #
                                # Note. for PIIX4 GPO port provide      #
                                # PM_BASE + 0x34 offset                 #
# FAN controlled over Index/Data access                                 #
A_FAN_INDEX_DATA_IO_Adr =       # 4 hex digits only (ef10, 410, ..)     #
                                # " " - not present                     #
#-----------------------------------------------------------------------#
# Model 1: 1 or 2 fans controled by 1 GPO pin per each FAN. On/Off state#
#-----------------------------------------------------------------------#
A_FAN_MODEL_1           = 0     # 1 - present, 0 - not present          #
A_FAN_1_GPO_Offset      = 00    # Decimal offset within register space  #
A_FAN_2_GPO_Offset      =       # Decimal offset within register space  #
                                # "" - no 2nd FAN on board              #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_FAN_1_1_ON            = 1     # Value 0 or 1 to turn FAN ON           #
A_FAN_1_2_ON            = 1     # Value 0 or 1 to turn FAN ON           #
#-----------------------------------------------------------------------#
# Model 2: 2 fans with different speed control. 2 GPO pins per each FAN #
# The combination of 2 bits will define the FAN's speed:Off,Low,Mid,Full#
#-----------------------------------------------------------------------#
A_FAN_MODEL_2           = 0     # 1 - present, 0 - not present          #
A_FAN_1_0_GPO_Offset    = 11    # Decimal offset within register space  #
A_FAN_1_1_GPO_Offset    = 26    # Decimal offset within register space  #
A_FAN_2_0_GPO_Offset    = 24    # Decimal offset within register space  #
A_FAN_2_1_GPO_Offset    = 25    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
#-----------------------------------------------------------------------#
# Model 3: 2 fans with different speed control. 3 GPO pins per each FAN #
# The combination of 3 bits will define the FAN's speed:Off,Low,Mid,Full#
#-----------------------------------------------------------------------#
A_FAN_MODEL_3           = 0     # 1 - present, 0 - not present          #
A_FAN_1_ON_GPO_Offset   = 13    # Decimal offset within register space  #
A_FAN_1_LOW_GPO_Offset  = 11    # Decimal offset within register space  #
A_FAN_1_MID_GPO_Offset  = 14    # Decimal offset within register space  #
A_FAN_2_ON_GPO_Offset   = 26    # Decimal offset within register space  #
A_FAN_2_LOW_GPO_Offset  = 24    # Decimal offset within register space  #
A_FAN_2_MID_GPO_Offset  = 25    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_FAN_3_1_ON            = 0     # Value 0 or 1 to turn FAN ON           #
A_FAN_3_2_ON            = 0     # Value 0 or 1 to turn FAN ON           #
#-----------------------------------------------------------------------#
#               SYSTEM INDICATION (SI)                                  #
#-----------------------------------------------------------------------#
# Note. The only one SI model can be selected                           #
#-----------------------------------------------------------------------#
A_SI_OEM                = 0     # Switch 0/1. Set to 1 if current SI    #
                                # control no match non of standard models#
                                # If set = 1 the CUST_SI.OEM file       #
                                # will require the proper editing       #
#-----------------------------------------------------------------------#
# SI IO port access method                                              #
#-----------------------------------------------------------------------#
# Note. The only one address should be provided                         #
#-----------------------------------------------------------------------#
# LED control port inside ISA IO space                                  #
A_SI_ISA_IO_Adr         =       # 4 hex digits only (ef10, 410, ..)     #
                                # " " - not present                     #
                                # Note. for PIIX4 GPO port provide      #
                                # PM_BASE + 0x34 offset                 #
# LED controlled over Index/Data access                                 #
A_SI_INDEX_DATA_IO_Adr  = 370   # 4 hex digits only (ef10, 410, ..)     #
                                # " " - not present                     #
#-----------------------------------------------------------------------#
# Model 1: 1 LED controled by 1 GPO pin to display 2 states : Work/Sleep#
#-----------------------------------------------------------------------#
A_SI_MODEL_1            = 1     # 1 - present, 0 - not present          #
A_SI_LED_1_GPO_Offset   = 25    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_SI_LED_1_ON           = 1     # Value 0 or 1 to turn LED ON(Green)    #
#-----------------------------------------------------------------------#
# Model 2: 2 LEDs controled by 1 GPO pin per each LED.                  #
# One LED per each system state: Work / Sleep / Hibernate (both are On) #
#-----------------------------------------------------------------------#
A_SI_MODEL_2            = 0     # 1 - present, 0 - not present          #
A_SI_WORK_GPO_Offset    = 00    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_SI_SLEEP_GPO_Offset   = 01    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_SI_WORK_2_ON          = 1     # Value 0 or 1 to turn LED ON(Green)    #
A_SI_SLEEP_2_ON         = 1     # Value 0 or 1 to turn LED ON(Yellow)   #
#-----------------------------------------------------------------------#
# Model 3: 1 LED controled by 2 GPO pins.                               #
# 3 possible combinations: LED On(Work), Off(Sleep), Blinking On/Off    #
#-----------------------------------------------------------------------#
A_SI_MODEL_3            = 0     # 1 - present, 0 - not present          #
A_SI_LED_3_GPO_Offset   = 27    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_SI_BLINK_GPO_Offset   = 12    # Decimal offset within register space  #
                                # PIIX4 PMbase + 0x34                   #
                                # Example 09 -> GPO.09, PM+0x35.2       #
A_SI_LED_3_ON           = 0     # Value 0 or 1 to turn LED ON(Green)    #
A_SI_LED_STEADY         = 1     # Value 0 or 1 for steady light         #
#-----------------------------------------------------------------------#
# Generic Power Button device                                           #
#-----------------------------------------------------------------------#
A_POWER_BUTTON_GENERIC  = 0     # 1 - present, 0 - not present          #
A_PB_GPE                = 09    # 2 hex digits only (00, 02,..0f)       #
                                # bit offset within GPE                 #
# PB control bits inside IO space (not part of GPE block)               #
A_PB_IO_Adr             =       # 2 hex digits only (00, 01, ff..)      #
                                # "" - no PB control bits               #
# Power Button Enable bit                                               #
A_PB_ENBL_Offset        =       # Dec bit offset within IO_Adr space    #
                                # "" - no PB Enable bit                 #
# Power Button State (Sleep/Work) bit                                   #
A_PB_STA_Offset         =       # Dec bit offset within IO_Adr space    #
                                # "" - no PB state bit                  #
#-----------------------------------------------------------------------#
# Generic Sleep Button device                                           #
#-----------------------------------------------------------------------#
A_SLEEP_BUTTON_GENERIC  = 0     # 1 - present, 0 - not present          #
A_SB_GPE                =       # 2 hex digits only (00, 02,..0f)       #
                                # bit offset within GPE                 #
A_SB_WAK_SYST           = 01    # 2 dec digits only. (01, 02, 03, 04)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
# SB control bits inside IO space (not part of GPE block)               #
A_SB_IO_Adr             = 418   # 2 hex digits only (00, 01, ff..)      #
                                # "" - no SB control bits               #
# Sleep Button Enable bit                                               #
A_SB_ENBL_Offset        = 74    # Dec bit offset within IO_Adr space    #
                                # "" - no SB Enable bit                 #
# Sleep Button State (Sleep/Work) bit                                   #
A_SB_STA_Offset         = 10    # Dec bit offset within IO_Adr space    #
                                # "" - no SB state bit                  #
#-----------------------------------------------------------------------#
#               CUSTOM DEVICE POWER MANAGEMENT                          #
#-----------------------------------------------------------------------#
A_IDE_PM                = 0     # 1 - present, 0 - not present          #
# Note. PCI Dev/Fun number provide for standalone controller only       #
A_IDE_DEV_Nbr           = 00    # 2 hex digits only (..09, 0a, 0b,..)   #
A_IDE_FUN_Nbr           = 01    # 2 hex digits only (..09, 0a, 0b,..)   #
#-----------------------------------------------------------------------#
A_SUPER_IO_PM           = 0     # 1 - present, 0 - not present          #
#-----------------------------------------------------------------------#
# Wake-up on PCI PME event connected to GPE                             #
#-----------------------------------------------------------------------#
A_PME_WAKE_UP           = 0     # 1 - present, 0 - not present          #
A_PME_GPE               = 09    # 2 hex digits only (..09, 0a, 0b,..)   #
                                # bit offset within GPE                 #
                                # Example 0a -> GPE.10                  #
                                # PIIX4 PM uses GPE.10 for PME wake pin #
A_PME_WAK_SYST          = 01    # 2 hex digits only (..02, 03, 04,..)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
#-----------------------------------------------------------------------#
# Non PME wake-up on PCI plug-in card with event connected to GPE (LAN) #
#-----------------------------------------------------------------------#
A_LAN_WAKE_UP           = 0     # 1 - present, 0 - not present          #
A_LAN_GPE               = 09    # 2 hex digits only (..09, 0a, 0b,..)   #
                                # bit offset within GPE                 #
                                # Example 0a -> GPE.10                  #
                                # PIIX4 PM uses GPE.10 for LAN wake pin #
A_LAN_WAK_SYST          = 01    # 2 hex digits only (..02, 03, 04,..)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
#-----------------------------------------------------------------------#
# Wake-up on USB event connected to GPE                                 #
#-----------------------------------------------------------------------#
A_USB_WAKE_UP           = 0     # 1 - present, 0 - not present          #
# Note. PCI Dev/Fun/GPE number provide for standalone controller only   #
A_USB_DEV_Nbr           = 01    # 2 hex digits only (..09, 0a, 0b,..)   #
A_USB_FUN_Nbr           = 02    # 2 hex digits only (..09, 0a, 0b,..)   #
A_USB_GPE               = 08    # 2 hex digits only (..09, 0a, 0b,..)   #
                                # bit offset within GPE                 #
                                # Example 0a -> GPE.10                  #
A_USB_WAK_SYST          = 01    # 2 hex digits only (..02, 03, 04,..)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
#-----------------------------------------------------------------------#
# Wake-up on modem RI                                                   #
#-----------------------------------------------------------------------#
A_RI_WAKE_UP_UART1      = 1     # 1 - present, 0 - not present          #
A_RI_WAKE_UP_UART2      = 0     # 1 - present, 0 - not present          #
A_RI_GPE                = 01    # 2 hex digits only (..09, 0a, 0b,..)   #
                                # bit offset within GPE                 #
                                # Example 0a -> GPE.10                  #
                                # PIIX4 PM uses GPE.10 for RI wake pin  #
A_RI_WAK_SYST           = 01    # 2 hex digits only (..02, 03, 04,..)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
#-----------------------------------------------------------------------#
# Wake-up on keyboard (event should be connected to GPE )               #
#-----------------------------------------------------------------------#
A_KEY_WAKE_UP           = 1     # 1 - present, 0 - not present          #
A_KEY_GPE               = 07    # 2 hex digits only (..09, 0a, 0b,..)   #
                                # bit offset within GPE                 #
                                # Example 0a -> GPE.10                  #
A_KEY_WAK_SYST          = 01    # 2 hex digits only (..02, 03, 04,..)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
#-----------------------------------------------------------------------#
# Wake-up on mouse (event should be connected to GPE )                  #
#-----------------------------------------------------------------------#
A_MOUSE_WAKE_UP         = 1     # 1 - present, 0 - not present          #
A_MOUSE_GPE             = 07    # 2 hex digits only (..09, 0a, 0b,..)   #
                                # bit offset within GPE                 #
                                # Example 0a -> GPE.10                  #
A_MOUSE_WAK_SYST        = 01    # 2 hex digits only (..02, 03, 04,..)   #
                                # Max system sleep state device         #
                                # can generate a resume event           #
#-----------------------------------------------------------------------#
#               CUSTOM START UP ASL CODE                                #
#-----------------------------------------------------------------------#
# Note. OEM start-up code will be called once during OS boot-up process #
#-----------------------------------------------------------------------#
A_START_UP_OEM          = 0     # 1 - present, 0 - not present          #
                                # If set = 1 the CUST_OEM.OEM file      #
                                # will require the proper editing       #
#-----------------------------------------------------------------------#
#               PREPARE TO SLEEP & WAKE UP OEM CODE                     #
#-----------------------------------------------------------------------#
A_PTS_WAK_OEM           = 0     # 1 - present, 0 - not present          #
                                # If set = 1 the CUST_PTS.OEM file      #
                                # will require the proper editing       #
#-----------------------------------------------------------------------#
# IO Trap on access to PM1a_Cnt register. Include code to _PTS & _WAK   #
#-----------------------------------------------------------------------#
A_PM1a_Cnt_IO_TRAP      = 0     # 1 - present, 0 - not present          #
                                # If set = 1 the ASL code to trap access#
                                # to PM1a_CNT register will be enabled  #
                                # in _PTS and disabled in _WAK generic  #
                                # ASL code                              #
                                # The code will be generated in only if #
                                # A_PIIX4 and A_POS_DECODE macros set'1'#
#-----------------------------------------------------------------------#
#               Additional PCI devices                                  #
#-----------------------------------------------------------------------#
A_OEM_PCI_DEV           = 0     # The CUST_PCI.OEM will be included into#
                                # the PCI bus 0 device scope            #
#-----------------------------------------------------------------------#
#               Additinal OEM ISA devices                               #
#-----------------------------------------------------------------------#
A_OEM_ISA_DEV           = 0     # The CUST_ISA.OEM will be included into#
                                # the ISA/EIO device scope              #
#-----------------------------------------------------------------------#
#               ISA Audio cards support                                 #
# Note. The only one Audio module may be selected                       #
#-----------------------------------------------------------------------#
A_ESS1888               = 0     # 1 - present, 0 - not present          #
A_ESS1887               = 0
A_ESS1878               = 0
A_ESS1869               = 0
A_YMF715x               = 0
#-----------------------------------------------------------------------#
# !!!!!!!!!!!!!!!! ALL OEM FLAG CHANGES END HERE !!!!!!!!!!!!!!!!!!!!!! #
#-----------------------------------------------------------------------#
