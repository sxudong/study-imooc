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

#------------------------------------------------------------------------------#
# Maxium 7 extra languages can be supported
# Specify the language directory below
# The directoies should contain: All message files and .SSP files
#------------------------------------------------------------------------------#
ML_DIR   = ML
ML1_DIR  = #$(ML_DIR)\Chinese
ML2_DIR  = #$(ML_DIR)\Japanese
ML3_DIR  = #$(ML_DIR)\Germany
ML4_DIR  = #$(ML_DIR)\ManiLand
ML5_DIR  =
ML6_DIR  =
ML7_DIR  =
#---------------------------------------#
# Specify the directory                 #
# ET3_DIR pointed to your font directory#
#---------------------------------------#
FONT     = ..\..\..\exe\font
RP       = ..\..\..\exe\rp
!if $(ML_MODULE)
!ifndef ET3_DIR
!error ERROR: You did not specify the directory for font files!!!
!endif
!endif

#------------------------------------------------------------------------------#
# Multi language switches
#------------------------------------------------------------------------------#
!ifndef ML_MODULE
ML_MODULE       = 1             # 1 = Multi-language supported (Graphic mode)
NO_LANGUAGES    = 2             # number of languages supported (at least 1: English)
# FONT_TYPES: Parameters to FONT.EXE
# You have to put (NO_LANGUAGE-1) numbers in this line.
# For examples, NO_LANGUAGES = 4 you have to put 3 numbers like following:
# FONT_TYPES    = 1,0,2 (1st=BIG5, 2nd=ASCII, 3rd=GB)
# The values specify the type of language described below:
# 0 = ASCII (English/Europen)
# 1 = BIG5 encoding (Traditional Chinese / Japanese)
# 2 = New Chinese (China)
FONT_TYPES      = 1
!endif
ML_MODULE_FILENAME = $(BUILD_DIR)\ML.BIN        # Multi Language Module Filename.Ext    #
ML_MODULE_DESTSEG  = 7000       # Multi Language Module Dest Segment    #
ML_MODULE_DESTADDR = 0000       # Multi Language Module Dest Addr       #
#-------------------------------#
# Override setup module if ML supported
#-------------------------------#
!if $(ML_MODULE)
!if $(NO_LANGUAGES)==2
SUI_FILE        = $(CORE_DIR)\hf120c.bin
!endif
!if $(NO_LANGUAGES)==4
SUI_FILE        = $(CORE_DIR)\hf120-4.bin
!endif
!endif
#------------------------------------------------------------------------------#

ML_FONT:
!if $(ML_MODULE)
#!if $(FLASH_2MB)
#    $(FONT) $(BUILD_DIR)\128K.ROM $(BUILD_DIR)\128K.ROM /C$(ET3_DIR) /O$(BUILD_DIR) /$(FONT_TYPES) /MANUAL /S
#    debug < <<
#f 4000:0 ffff 0
#f 5000:0 ffff 0
#n $(BUILD_DIR)\ml.enc
#l4000:0000
#n $(BUILD_DIR)\font.bmp
#l4000:8000
#n $(BUILD_DIR)\128K.ROM
#l6000:0
#rcx
#0
#rbx
#4
#n $(BUILD_DIR)\$(BIOSFILE).ROM
#w4000:0
#q
#<<
#!else
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ML_MODULE_FILENAME) 21 /M $(ML_MODULE_DESTSEG) $(ML_MODULE_DESTADDR)
    $(FONT) $(BUILD_DIR)\$(BIOSFILE).ROM $(BUILD_DIR)\$(BIOSFILE).ROM /C$(ET3_DIR) /O$(BUILD_DIR) /$(FONT_TYPES)
#!endif
!endif

#------------------------------------------------------------------------------#
# This makefile generates ML.BIN
#------------------------------------------------------------------------------#
ML_OBJS =\
$(BUILD_DIR)\hdr.obj

!if $(NO_LANGUAGES)>1
ML_OBJS = $(ML_OBJS)\
$(ML1_DIR)\me4.obj\
$(ML1_DIR)\me0.obj\
$(ML1_DIR)\me5.obj\
$(ML1_DIR)\me6.obj\
$(ML1_DIR)\me7.obj\
$(ML1_DIR)\me8dm.obj\
$(ML1_DIR)\me9.obj
!endif

!if $(NO_LANGUAGES)>2
ML_OBJS = $(ML_OBJS)\
$(ML2_DIR)\me4.obj\
$(ML2_DIR)\me0.obj\
$(ML2_DIR)\me5.obj\
$(ML2_DIR)\me6.obj\
$(ML2_DIR)\me7.obj\
$(ML2_DIR)\me8dm.obj\
$(ML2_DIR)\me9.obj
!endif

!if $(NO_LANGUAGES)>3
ML_OBJS = $(ML_OBJS)\
$(ML3_DIR)\me4.obj\
$(ML3_DIR)\me0.obj\
$(ML3_DIR)\me5.obj\
$(ML3_DIR)\me6.obj\
$(ML3_DIR)\me7.obj\
$(ML3_DIR)\me8dm.obj\
$(ML3_DIR)\me9.obj
!endif

!if $(NO_LANGUAGES)>4
ML_OBJS = $(ML_OBJS)\
$(ML4_DIR)\me4.obj\
$(ML4_DIR)\me0.obj\
$(ML4_DIR)\me5.obj\
$(ML4_DIR)\me6.obj\
$(ML4_DIR)\me7.obj\
$(ML4_DIR)\me8dm.obj\
$(ML4_DIR)\me9.obj
!endif

!if $(NO_LANGUAGES)>5
ML_OBJS = $(ML_OBJS)\
$(ML5_DIR)\me4.obj\
$(ML5_DIR)\me0.obj\
$(ML5_DIR)\me5.obj\
$(ML5_DIR)\me6.obj\
$(ML5_DIR)\me7.obj\
$(ML5_DIR)\me8dm.obj\
$(ML5_DIR)\me9.obj
!endif

!if $(NO_LANGUAGES)>6
ML_OBJS = $(ML_OBJS)\
$(ML6_DIR)\me4.obj\
$(ML6_DIR)\me0.obj\
$(ML6_DIR)\me5.obj\
$(ML6_DIR)\me6.obj\
$(ML6_DIR)\me7.obj\
$(ML6_DIR)\me8dm.obj\
$(ML6_DIR)\me9.obj
!endif

!if $(NO_LANGUAGES)>7
ML_OBJS = $(ML_OBJS)\
$(ML7_DIR)\me4.obj\
$(ML7_DIR)\me0.obj\
$(ML7_DIR)\me5.obj\
$(ML7_DIR)\me6.obj\
$(ML7_DIR)\me7.obj\
$(ML7_DIR)\me8dm.obj\
$(ML7_DIR)\me9.obj
!endif

#------------------------------------------------------------------------------#
# Change the OBJ name of setupmsg in each language
#------------------------------------------------------------------------------#
!if $(NO_LANGUAGES)>1
$(ML1_DIR)\me4.obj:             $(ML1_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML1_DIR)\me4.obj $(ML1_DIR)\setupmsg.asm
$(ML1_DIR)\me0.obj:             $(ML1_DIR)\me0.asm $(MKF)
$(ML1_DIR)\me5.obj:             $(ML1_DIR)\me5.asm $(MKF)
$(ML1_DIR)\me6.obj:             $(ML1_DIR)\me6.asm $(MKF)
$(ML1_DIR)\me7.obj:             $(ML1_DIR)\me7.asm $(MKF)
$(ML1_DIR)\me8dm.obj:           $(ML1_DIR)\me8dm.asm $(MKF)
$(ML1_DIR)\me9.obj:             $(ML1_DIR)\me9.asm $(MKF)
!endif

!if $(NO_LANGUAGES)>2
$(ML2_DIR)\me4.obj:             $(ML2_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML2_DIR)\me4.obj $(ML2_DIR)\setupmsg.asm
$(ML2_DIR)\me0.obj:             $(ML2_DIR)\me0.asm $(MKF)
$(ML2_DIR)\me5.obj:             $(ML2_DIR)\me5.asm $(MKF)
$(ML2_DIR)\me6.obj:             $(ML2_DIR)\me6.asm $(MKF)
$(ML2_DIR)\me7.obj:             $(ML2_DIR)\me7.asm $(MKF)
$(ML2_DIR)\me8dm.obj:           $(ML2_DIR)\me8dm.asm $(MKF)
$(ML2_DIR)\me9.obj:             $(ML2_DIR)\me9.asm $(MKF)
!endif

!if $(NO_LANGUAGES)>3
$(ML3_DIR)\me4.obj:             $(ML3_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML3_DIR)\me4.obj $(ML3_DIR)\setupmsg.asm
$(ML3_DIR)\me0.obj:             $(ML3_DIR)\me0.asm $(MKF)
$(ML3_DIR)\me5.obj:             $(ML3_DIR)\me5.asm $(MKF)
$(ML3_DIR)\me6.obj:             $(ML3_DIR)\me6.asm $(MKF)
$(ML3_DIR)\me7.obj:             $(ML3_DIR)\me7.asm $(MKF)
$(ML3_DIR)\me8dm.obj:           $(ML3_DIR)\me8dm.asm $(MKF)
$(ML3_DIR)\me9.obj:             $(ML3_DIR)\me9.asm $(MKF)
!endif

!if $(NO_LANGUAGES)>4
$(ML4_DIR)\me4.obj:             $(ML4_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML4_DIR)\me4.obj $(ML4_DIR)\setupmsg.asm
$(ML4_DIR)\me0.obj:             $(ML4_DIR)\me0.asm $(MKF)
$(ML4_DIR)\me5.obj:             $(ML4_DIR)\me5.asm $(MKF)
$(ML4_DIR)\me6.obj:             $(ML4_DIR)\me6.asm $(MKF)
$(ML4_DIR)\me7.obj:             $(ML4_DIR)\me7.asm $(MKF)
$(ML4_DIR)\me8dm.obj:           $(ML4_DIR)\me8dm.asm $(MKF)
$(ML4_DIR)\me9.obj:             $(ML4_DIR)\me9.asm $(MKF)
!endif

!if $(NO_LANGUAGES)>5
$(ML5_DIR)\me4.obj:             $(ML5_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML5_DIR)\me4.obj $(ML5_DIR)\setupmsg.asm
$(ML5_DIR)\me0.obj:             $(ML5_DIR)\me0.asm $(MKF)
$(ML5_DIR)\me5.obj:             $(ML5_DIR)\me5.asm $(MKF)
$(ML5_DIR)\me6.obj:             $(ML5_DIR)\me6.asm $(MKF)
$(ML5_DIR)\me7.obj:             $(ML5_DIR)\me7.asm $(MKF)
$(ML5_DIR)\me8dm.obj:           $(ML5_DIR)\me8dm.asm $(MKF)
$(ML5_DIR)\me9.obj:             $(ML5_DIR)\me9.asm $(MKF)
!endif

!if $(NO_LANGUAGES)>6
$(ML6_DIR)\me4.obj:             $(ML6_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML6_DIR)\me4.obj $(ML6_DIR)\setupmsg.asm
$(ML6_DIR)\me0.obj:             $(ML6_DIR)\me0.asm $(MKF)
$(ML6_DIR)\me5.obj:             $(ML6_DIR)\me5.asm $(MKF)
$(ML6_DIR)\me6.obj:             $(ML6_DIR)\me6.asm $(MKF)
$(ML6_DIR)\me7.obj:             $(ML6_DIR)\me7.asm $(MKF)
$(ML6_DIR)\me8dm.obj:           $(ML6_DIR)\me8dm.asm $(MKF)
$(ML6_DIR)\me9.obj:             $(ML6_DIR)\me9.asm $(MKF)
!endif

!if $(NO_LANGUAGES)>7
$(ML7_DIR)\me4.obj:             $(ML7_DIR)\setupmsg.asm $(MKF)
        @$(ASM) /c /Fo$(ML7_DIR)\me4.obj $(ML7_DIR)\setupmsg.asm
$(ML7_DIR)\me0.obj:             $(ML7_DIR)\me0.asm $(MKF)
$(ML7_DIR)\me5.obj:             $(ML7_DIR)\me5.asm $(MKF)
$(ML7_DIR)\me6.obj:             $(ML7_DIR)\me6.asm $(MKF)
$(ML7_DIR)\me7.obj:             $(ML7_DIR)\me7.asm $(MKF)
$(ML7_DIR)\me8dm.obj:           $(ML7_DIR)\me8dm.asm $(MKF)
$(ML7_DIR)\me9.obj:             $(ML7_DIR)\me9.asm $(MKF)
!endif
#------------------------------------------------------------------------------#

$(ML_MODULE_FILENAME):\
!if $(NO_LANGUAGES)>1
$(ML1_DIR)\setupequ.ext \
!endif
!if $(NO_LANGUAGES)>2
$(ML2_DIR)\setupequ.ext \
!endif
!if $(NO_LANGUAGES)>3
$(ML3_DIR)\setupequ.ext \
!endif
!if $(NO_LANGUAGES)>4
$(ML4_DIR)\setupequ.ext \
!endif
!if $(NO_LANGUAGES)>5
$(ML5_DIR)\setupequ.ext \
!endif
!if $(NO_LANGUAGES)>6
$(ML6_DIR)\setupequ.ext \
!endif
!if $(NO_LANGUAGES)>7
$(ML7_DIR)\setupequ.ext \
!endif
$(BUILD_DIR)\ml.exe
   $(EXE2BIN) $(BUILD_DIR)\ml.exe $(ML_MODULE_FILENAME)

#------------------------------------------------------------------------------#
# Rules for eache languages
#------------------------------------------------------------------------------#
{$(ML_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

!if $(NO_LANGUAGES)>1
{$(ML1_DIR)\}.asm{$(ML1_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif

!if $(NO_LANGUAGES)>2
{$(ML2_DIR)\}.asm{$(ML2_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif

!if $(NO_LANGUAGES)>3
{$(ML3_DIR)\}.asm{$(ML3_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif

!if $(NO_LANGUAGES)>4
{$(ML4_DIR)\}.asm{$(ML4_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif

!if $(NO_LANGUAGES)>5
{$(ML5_DIR)\}.asm{$(ML5_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif

!if $(NO_LANGUAGES)>6
{$(ML6_DIR)\}.asm{$(ML6_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif

!if $(NO_LANGUAGES)>7
{$(ML7_DIR)\}.asm{$(ML7_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif
#------------------------------------------------------------------------------#

$(BUILD_DIR)\ml.exe: $(MKF) $(ML_OBJS)
    $(LINK) $(LFLAGS) @<<
$(ML_OBJS: = +^
),
$(BUILD_DIR)\ml.exe,
$(BUILD_DIR)\ml.map;
<<


#------------------------------------------------------------------------------#
# SSP files for each languages
#------------------------------------------------------------------------------#
SSM_FILES = $(**:\=\\)
!if $(NO_LANGUAGES)>1
$(ML1_DIR)\setupequ.ext : $(ML1_DIR)\core.ssp $(ML1_DIR)\advanced.ssp $(ML1_DIR)\chipset.ssp $(ML1_DIR)\power.ssp $(ML1_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML1_DIR)\io.ssp $(ML1_DIR)\ioc.ssp
   @$(SSP) $(ML1_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   @$(COPY) $(ML1_DIR)\setupequ.ext $(BUILD_DIR)
   @$(COPY) $(ML1_DIR)\set*.asm $(BUILD_DIR)
   $(RP) $(ML1_DIR)\setupmsg.asm string_set language1_string_set
   $(RP) $(ML1_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE1_ME_STARTS
   $(RP) $(ML1_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE1_ME_ENDS
!endif

!if $(NO_LANGUAGES)>2
$(ML2_DIR)\setupequ.ext : $(ML2_DIR)\core.ssp $(ML2_DIR)\advanced.ssp $(ML2_DIR)\chipset.ssp $(ML2_DIR)\power.ssp $(ML2_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML2_DIR)\io.ssp $(ML2_DIR)\ioc.ssp
   @$(SSP) $(ML2_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   $(RP) $(ML2_DIR)\setupmsg.asm string_set language2_string_set
   $(RP) $(ML2_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE2_ME_STARTS
   $(RP) $(ML2_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE2_ME_ENDS
!endif

!if $(NO_LANGUAGES)>3
$(ML3_DIR)\setupequ.ext : $(ML3_DIR)\core.ssp $(ML3_DIR)\advanced.ssp $(ML3_DIR)\chipset.ssp $(ML3_DIR)\power.ssp $(ML3_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML3_DIR)\io.ssp $(ML3_DIR)\ioc.ssp
   @$(SSP) $(ML3_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   $(RP) $(ML3_DIR)\setupmsg.asm string_set language3_string_set
   $(RP) $(ML3_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE3_ME_STARTS
   $(RP) $(ML3_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE3_ME_ENDS
!endif

!if $(NO_LANGUAGES)>4
$(ML4_DIR)\setupequ.ext : $(ML4_DIR)\core.ssp $(ML4_DIR)\advanced.ssp $(ML4_DIR)\chipset.ssp $(ML4_DIR)\power.ssp $(ML4_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML4_DIR)\io.ssp $(ML4_DIR)\ioc.ssp
   @$(SSP) $(ML4_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   $(RP) $(ML4_DIR)\setupmsg.asm string_set germany_string_set
   $(RP) $(ML4_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE4_ME_STARTS
   $(RP) $(ML4_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE4_ME_ENDS
!endif

!if $(NO_LANGUAGES)>5
$(ML5_DIR)\setupequ.ext : $(ML5_DIR)\core.ssp $(ML5_DIR)\advanced.ssp $(ML5_DIR)\chipset.ssp $(ML5_DIR)\power.ssp $(ML5_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML5_DIR)\io.ssp $(ML5_DIR)\ioc.ssp
   @$(SSP) $(ML5_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   $(RP) $(ML5_DIR)\setupmsg.asm string_set germany_string_set
   $(RP) $(ML5_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE5_ME_STARTS
   $(RP) $(ML5_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE5_ME_ENDS
!endif

!if $(NO_LANGUAGES)>6
$(ML6_DIR)\setupequ.ext : $(ML6_DIR)\core.ssp $(ML6_DIR)\advanced.ssp $(ML6_DIR)\chipset.ssp $(ML6_DIR)\power.ssp $(ML6_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML6_DIR)\io.ssp $(ML6_DIR)\ioc.ssp
   @$(SSP) $(ML6_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   $(RP) $(ML6_DIR)\setupmsg.asm string_set germany_string_set
   $(RP) $(ML6_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE6_ME_STARTS
   $(RP) $(ML6_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE6_ME_ENDS
!endif

!if $(NO_LANGUAGES)>7
$(ML7_DIR)\setupequ.ext : $(ML7_DIR)\core.ssp $(ML7_DIR)\advanced.ssp $(ML7_DIR)\chipset.ssp $(ML7_DIR)\power.ssp $(ML7_DIR)\pcipnp.ssp $(BUILD_DIR)\io.inc $(ML7_DIR)\io.ssp $(ML7_DIR)\ioc.ssp
   @$(SSP) $(ML7_DIR)\ <<
include "$(SSM_FILES: ="^
include ")"
<<
   $(RP) $(ML7_DIR)\setupmsg.asm string_set germany_string_set
   $(RP) $(ML7_DIR)\setupmsg.asm _ME_STARTS _LANGUAGE7_ME_STARTS
   $(RP) $(ML7_DIR)\setupmsg.asm _ME_ENDS _LANGUAGE7_ME_ENDS
!endif


#------------------------------------------------------------------------------#
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

