;-----------------------------------------------------------------------;
;                       StrI2CCycle                                     ;
;-----------------------------------------------------------------------;
; I2C Start Cycle                                                       ;
;-----------------------------------------------------------------------;
StrI2CCycle     PROC    PUBLIC
        push	ax
	push	dx

        mov     ah, 02h         ; 2 bits need to program for Start cycle
        mov     dh, 00000001b   ; I2C data
        mov     dl, 00000011b   ; I2C clock
StartCycle:
        push	dx
	mov	al, dh
	and	al, 00000001b
        shl     al, 01h
        and     dl, 00000001b
        or      al, dl

        shl     al, 03h
        pop	dx
        call    CsI2CWrite
        shr     dh, 01h
        shr     dl, 01h
	dec	ah
        jne     StartCycle

        pop	dx
	pop	ax
        ret
StrI2CCycle     ENDP


;-----------------------------------------------------------------------;
;                       StpI2CCycle                                     ;
;-----------------------------------------------------------------------;
; Send stop command to I2C bus.                                         ;
;-----------------------------------------------------------------------;
StpI2CCycle     PROC    PUBLIC
        push	ax
	push	dx

        mov     ah, 02h         ; 2 bits need to program for Stop cycle
        mov     dh, 00000010b   ; I2C data
        mov     dl, 00000011b   ; I2C clock
StopCycle:
        push	dx
	mov	al,dh
	and	al, 00000001b
        shl     al, 01h
        and     dl, 00000001b
        or      al, dl
        shl     al, 03h
        pop	dx
        call    CsI2CWrite
        shr     dh, 01h
        shr     dl, 01h
        dec	ah
        jne     StopCycle

        pop	dx
	pop	ax
        ret
StpI2CCycle     ENDP


;-----------------------------------------------------------------------;
;                       PreStpI2CCycle                                  ;
;-----------------------------------------------------------------------;
; Send stop command to I2C bus for data low pre-1 clk.                  ;
;-----------------------------------------------------------------------;
PreStpI2CCycle  PROC    PUBLIC
        push	ax
	push	dx

        mov     ah, 03h         ; 3 bits need to program for Stop cycle
        mov     dh, 00000100b   ; I2C data
        mov     dl, 00000110b   ; I2C clock
PreStopCycle:
        push	dx
	mov	al, dh
	and	al, 00000001b
        shl     al, 01h
        and     dl, 00000001b
        or      al, dl
        shl     al, 03h
        pop	dx
        call    CsI2CWrite
        shr     dh, 01h
        shr     dl, 01h
	dec	ah
        jne     PreStopCycle

        pop	dx
	pop	ax
        ret
PreStpI2CCycle  ENDP


;-----------------------------------------------------------------------;
;                       CSI2CCmd                                        ;
;-----------------------------------------------------------------------;
; I2C Command cycle and all common R/W.                                 ;
;-----------------------------------------------------------------------;
CSI2CCmd        PROC    PUBLIC
        push	ax
WriteCmd:
	rol	dh, 01h
	mov	al, dh
	and	al, 01h
        shl     al, 01h
	rol	dl, 01h
        adc     al, 00h
        shl     al, 03h
        call    PreCsI2CWrite
        call    CsI2CDummy
	dec	ah
        jne     WriteCmd

	pop	ax
        ret
CSI2CCmd        ENDP


;-----------------------------------------------------------------------;
;                       CSI2CDummy                                      ;
;-----------------------------------------------------------------------;
; Assert I2C clock to low to extend wait cycle.                         ;
;-----------------------------------------------------------------------;
CSI2CDummy      PROC    PUBLIC
        push	ax
	push	cx

        mov     ah, 06dh
        call    read_sio_byte
        and     al, 11110111b           ;I2C bus clock active level low
        call    write_sio_byte

        mov     cx, 07ffh
        call    DelayBase01

	pop	cx
        pop	ax
        ret
CSI2CDummy     ENDP


;-----------------------------------------------------------------------;
;                       CSI2CRead                                       ;
;-----------------------------------------------------------------------;
; I2C Read Cycle.                                                       ;
;-----------------------------------------------------------------------;
CSI2CRead       PROC    PUBLIC
	push	cx
        push	eax
	push	dx

        mov     cl, al                  ; decode PCI / ATM space

        mov     eax, 8000086ch
        mov     dx, 0cf8h
        out     dx, eax
	jmp	short $+2
        mov     dl, 0fdh
        in      al, dx
        and     al, 11100111b           ; pull data , clock to high
        mov     ah, al
        or      al, 00010000b
        out     dx, al

        mov     cx, 04ffh
        call    DelayBase

        mov     al, ah
        or      al, 00011000b
        out     dx, al

        mov     cx, 07ffh
        call    DelayBase

        in      al, dx
	jmp	short $+2
	mov	cl,al

	pop	dx
	pop	eax
	mov	al,cl
	pop	cx
        ret
CSI2CRead       ENDP


;-----------------------------------------------------------------------;
;                       CSI2CWrite                                      ;
;-----------------------------------------------------------------------;
; I2C Write Cycle.                                                      ;
;-----------------------------------------------------------------------;
CSI2CWrite      PROC    PUBLIC
        push	eax
	push	cx
	push	dx

        mov	cl,al

        mov     eax, 8000086ch
        mov     dx, 0cf8h
        out     dx, eax
	jmp	short $+2
        mov     dl, 0fdh
        in      al, dx
        and     al, 11100111b
        or      al, cl
        out     dx, al

        mov     cx, 0954h
        call    DelayBase01

        pop	dx
	pop	cx
	pop	eax
        ret
CSI2CWrite       ENDP


;-----------------------------------------------------------------------;
;                       PreCSI2CWrite                                   ;
;-----------------------------------------------------------------------;
; I2C Write Cycle for delay clock.                                      ;
; Input : (AL)                                                          ;
; Output:                                                               ;
; Register destroyed: None                                              ;
;-----------------------------------------------------------------------;
PreCSI2CWrite   PROC    PUBLIC
        push	eax
	push	cx
	push	dx

        mov     cl, al

        mov     eax, 8000086ch
        mov     dx, 0cf8h
        out     dx, eax
	jmp	short $+2
        mov     dl, 0fdh
        in      al, dx
        and     al, 11100111b
        or      al, cl
        mov     ah, al
        and     al, 11110111b
        out     dx, al

        mov     cx, 05ffh
        call    DelayBase01

        mov     al, ah
        out     dx, al

        mov     cx, 07ffh
        call    DelayBase01

        pop	dx
	pop	cx
	pop	eax
        ret
PreCSI2CWrite    ENDP


;-----------------------------------------------------------------------;
;                       RvDvAcktoTm                                     ;
;-----------------------------------------------------------------------;
; Receiver send ACK to Transmitter.                                     ;
;-----------------------------------------------------------------------;
RvDvAcktoTm     PROC    PUBLIC
        push	ax
	push	cx
;	push	dx

;        mov     dh, 00000001b   ; I2C data , this is for Receiver ACK cycle
;        mov     dl, 00000001b   ; I2C clock
;        mov     al, 00h
;        or      al, dh
;        shl     al, 01h
;        or      al, dl
;        shl     al, 03h
	mov	al,00011000b
        call    PreCsI2CWrite

        mov     cx, 007ffh
        call    DelayBase01

        call    CsI2CDummy

;        pop	dx
	pop	cx
	pop	ax
        ret
RvDvAcktoTm ENDP


;-----------------------------------------------------------------------;
;                       SeqRdDvAcktoTm                                  ;
;-----------------------------------------------------------------------;
; Receiver send ACK to Transmitter when sequential read.                ;
;-----------------------------------------------------------------------;
SeqRdDvAcktoTm  PROC    PUBLIC
        push	ax
	push	cx
;	push	dx

;        mov     dh, 00000000b   ; I2C data , this is for Receiver ACK cycle
;        mov     dl, 00000001b   ; I2C clock
;        mov     al, 00h
;        or      al, dh
;        shl     al, 01h
;        or      al, dl
;        shl     al, 03h
	mov	al,00001000b	
        call    PreCsI2CWrite

        mov     cx, 07ffh
        call    DelayBase01

        call    CsI2CDummy

;        pop	dx
	pop	cx
	pop	ax
        ret
SeqRdDvAcktoTm  ENDP


;-----------------------------------------------------------------------;
;                       ChkAck                                          ;
;-----------------------------------------------------------------------;
; Wait the slave to assert data to low for acknowledge.                 ;
; Input : None                                                          ;
; Output:                                                               ;
; Register destroyed: None                                              ;
;-----------------------------------------------------------------------;
ChkAck          PROC    PUBLIC
        push	ax
	push	cx

        mov     ah, 06dh
        call    read_sio_byte
        or      al, 00010000b           ;I2C bus data active level high
        call    write_sio_byte

        mov     cx, 05ffh
        call    DelayBase01

        mov     cl, 010h
NoAckW:
        dec     cx
        jz      WaitAckTimOut
        mov     al, 00h                 ;This is for Transmitter ACK cycle
        call    CsI2CRead
        test    al, 00010000b
        jnz     NoAckW

        clc
        jmp     short EndWaitAck

WaitAckTimOut:
        stc

EndWaitAck:
        pop	cx
	pop	ax
        ret
ChkAck          ENDP


;-----------------------------------------------------------------------;
;                       PreEnableI2CBus                                 ;
;-----------------------------------------------------------------------;
; Set the GPIO to default high.                                         ;
; Input : None                                                          ;
; Output: None                                                          ;
; Register destroyed: None                                              ;
;-----------------------------------------------------------------------;
PreEnableI2CBus PROC    PUBLIC
        push	ax
	push	cx

        mov     ah, 06dh
        call    read_sio_byte
        or      al, 00011000b           ;I2C bus data/clock active level high
        call    write_sio_byte

        mov     cx, 07ffh
        call    DelayBase01

        pop	cx
	pop	ax
        ret
PreEnableI2CBus ENDP


;-----------------------------------------------------------------------;
;                       EnableI2CBus                                    ;
;-----------------------------------------------------------------------;
; Input : None                                                          ;
; Output: None                                                          ;
; Register destroyed: None                                              ;
;-----------------------------------------------------------------------;
EnableI2Cbus    PROC    PUBLIC
        push	ax
        mov     ah, 06dh
        call    read_sio_byte
        or      al, 00000100b           ;Enable I2C bus control
        call    write_sio_byte
        pop	ax
        ret
EnableI2CBus    ENDP


;-----------------------------------------------------------------------;
;                       DelayBase                                       ;
;-----------------------------------------------------------------------;
; Input : (CX) Delay count                                              ;
; Output: (CX) = 0                                                      ;
; Register destroyed: CX                                                ;
;-----------------------------------------------------------------------;
DelayBase:
        jmp     short $+2
DelayBase01:
        jmp     short $+2
        jmp     short $+2
        jmp     short $+2
        jmp     short $+2
        jmp     short $+2
        loop    DelayBase
        ret
;;==========================================================================;;
;; Input: AH = Device Slave Address
;;	  AL = Device Register Index
;; Output:AL = Register Value
;; Destroy:None
i2c_read_byte proc public

	push	cx
	push	dx

	mov	cx, ax

        call    PreEnableI2CBus         ;I2C bus Data/Clock active level High
        call    EnableI2CBus            ;Enable I2C bus

        call    StrI2CCycle

        call    CsI2CDummy
	
        mov     ah, 08h          	; Device Slave Address
        mov     dh, ch		 	; I2C data (/W)
        mov     dl, 11111111b    	; I2C clock
        call    csI2CCmd

        call    ChkAck

        call    CsI2CDummy

        mov     dh, cl		 	; I2C data (Device Register Index)
        call    csI2CCmd
	
        call    ChkAck

        call    CsI2CDummy

        call    StrI2CCycle

        call    CsI2CDummy
	
        mov     dh, ch			; I2C data
	or	dh, 01h			; (Read) 
        call    csI2CCmd

        call    ChkAck

        call    CsI2CDummy

	mov	ah, ch				; Restore AH

	mov	cx,8
	mov	dl,0
read_loop:
	shl	dl,1
	call	CSI2CRead
	test	al,10h
	jz	read_data_low
	or	dl,1
read_data_low:
	loop	read_loop

	mov	al, dl				; AL = Read Data

	call	RvDvAcktoTm

        call    CsI2CDummy

        call    PreStpI2CCycle

        mov     cx, 0ffffh
        call    DelayBase01

	pop	cx
	pop	dx
	ret
i2c_read_byte endp
;;==========================================================================;;
;; Input: AH = Device Slave Address
;;	  AL = Device Register Index
;;	  CL = Write Data
;; Output:None
;; Destroy:None
i2c_write_byte proc public

	push	cx
	push	dx

	mov	ch, ah

        call    PreEnableI2CBus         ;I2C bus Data/Clock active level High
        call    EnableI2CBus            ;Enable I2C bus

        call    StrI2CCycle

        call    CsI2CDummy
	
        mov     ah, 08h          	; Device Slave Address
        mov     dh, ch		 	; I2C data (/W)
        mov     dl, 11111111b    	; I2C clock
        call    csI2CCmd

        call    ChkAck

        call    CsI2CDummy

        mov     dh, al		 	; I2C data (Device Register Index)
        call    csI2CCmd
	
        call    ChkAck

        call    CsI2CDummy

        mov     dh, cl			; I2C data
        call    csI2CCmd		; Write Data

        call    ChkAck

        call    CsI2CDummy

	mov	ah, ch				; Restore AH

        call    PreStpI2CCycle

        mov     cx, 0ffffh
        call    DelayBase01

	pop	cx
	pop	dx
	ret
i2c_write_byte endp
;;==========================================================================;;

