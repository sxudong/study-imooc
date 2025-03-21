OBJ_DIR		=	..\obj

CPU_OBJS=\
$(OBJ_DIR)\CLK.OBJ\
$(OBJ_DIR)\CPU1.OBJ\
$(OBJ_DIR)\CPU2.OBJ\
$(OBJ_DIR)\FPU2.OBJ\
$(OBJ_DIR)\MCPU1.OBJ\
$(OBJ_DIR)\MCPU2.OBJ\
$(OBJ_DIR)\SCPU1.OBJ\
$(OBJ_DIR)\SCPU2.OBJ

all:    $(CPU_OBJS)

.asm{$(OBJ_DIR)\}.obj:
   @ml /nologo /c /I..\include /Fo$*.obj $<

$(OBJ_DIR)\CLK.OBJ	:	CLK.ASM
$(OBJ_DIR)\CPU1.OBJ	:	CPU1.ASM
$(OBJ_DIR)\CPU2.OBJ	:	CPU2.ASM
$(OBJ_DIR)\FPU2.OBJ	:	FPU2.ASM
$(OBJ_DIR)\MCPU1.OBJ	:	MCPU1.ASM
$(OBJ_DIR)\MCPU2.OBJ	:	MCPU2.ASM
$(OBJ_DIR)\SCPU1.OBJ	:	SCPU1.ASM
$(OBJ_DIR)\SCPU2.OBJ	:	SCPU2.ASM
