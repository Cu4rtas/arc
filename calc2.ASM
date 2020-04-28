;PROGRAMA PARA MULTIPLICAR DOS NUMEROS DE DOS DIGITOS****************************
;**************************************************************************


        .MODEL  SMALL
        .386
        .STACK          
        .DATA           
N1      DB      ?
N2      DB      ?
N3      DB      ?
RE	DB	?
RES     DW      ?
UNI     DB      ?
DECE    DB      ?
CLV    	DB     	10,13,'$'
MMEN    DB     	10,13,'.::::CALCULADORA DE NUMEROS DE DOS DIGITOS::::.$'
MN1     DB      10,10,13,'INGRESAR NUMERO 1 (DOS DIGITOS): $'
MN2     DB      10,13,'INGRESAR NUMERO 2 (DOS DIGITOS): $'
MRE	DB	10,13,'RESIDUO: $'
MN3	DB   	10,10,13,'INGRESE  CARACTER DE OPERACION: S: suma, R: resta, M: multi, D: div. INGRESE X PARA SALIR.$'
MIN	DB	10,10,13,'INGRESE OPCION: $'
MRES    DB      10,10,13,'RESULTADO DE OPERACION: $'
MSALIR  DB      10,10,13,'DIGITE <X> PARA SALIR O PRESIONE CUALQUIER TECLA PARA CONTINUAR: $'
ASCVAL  DB      5 DUP(00H),'$'
BINVAL  DW      0000

        .CODE
        ORG     0000    ;ASEGURAR DESPLAZAMIENTO 0000 PARA EL CS
        JMP     MAIN

;****** DEFINICION DEL SEGMENTO DE DATOS ***********
SEG_DAT:
        MOV     AX,@DATA
        MOV     DS,AX
        RET
;****************************************************

;******* RUTINA PARA MENSAJE *******************************
MOSTRAR_MENSAJE:
        MOV     AH,09H
        INT     21H
        RET

DIV_MENSAJE:
        MOV     AH,09H
        INT     21H
        RET
;****************************************************

;********** INGRESO NUMERO *****************************
INGRESO:
        MOV     AH,01H
        INT     21H
        RET
;**********************************************************
VERIFICAR_ENTRADA:
	MOV	AH,07H
	INT	21H
	CMP	AL,30H
	JB	VERIFICAR_ENTRADA
	CMP	AL,39H
	JA	VERIFICAR_ENTRADA
	RET


INGRESO_NUM:
	MOV	AH,01H
	INT	21H
	RET

;**********************************************************
INGRESO2DIG:
	CALL	VERIFICAR_ENTRADA
	MOV     N3, AL

	AND	AL,0FH
	MOV	AH,0
	MOV	DL,10
	MUL	DL
        MOV     BL,AL
	
	LEA 	DX, N3
	CALL	MOSTRAR_MENSAJE

	CALL	VERIFICAR_ENTRADA

	MOV	N3, AL
	AND	AL,0FH
	ADD 	BL, AL

	LEA 	DX, N3
	CALL	MOSTRAR_MENSAJE		
	RET
;**********************************************************

;**********************************************************
SALIR:  MOV     AH,4CH
        INT     21H
	RET
;**********************************************************


;**********************************************************
BINASCII:       
	LEA     SI,ASCVAL
        MOV     CX,5
        MOV     AL,00H
C10:    MOV     [SI],AL
        INC     SI
        LOOP    C10
        MOV     CX,10
        LEA     SI,ASCVAL+4
        MOV     AX,BINVAL
C20:    CMP     AX,CX
        JB      C30
        XOR     DX,DX
        DIV     CX
        OR      DL,30H
        MOV     [SI],DL
        DEC     SI
        JMP     C20
C30:    OR      AL,30H
        MOV     [SI],AL
        RET
;**************************OPERACIONES *******************************

MULTI:
	MOV     AH,0
	MOV	AL,N1
        MUL     N2
	CALL 	RESULTADO
	RET


DIVI:
	MOV	AH,0
	MOV	AL,N1
	DIV	N2
	MOV	RE,AH
	MOV 	AH,0
	CALL	RESULTADO
	RET

SUM:
	MOV 	AH,0
	MOV	AL,N1
	ADD 	AL,N2
	CALL	RESULTADO
	RET

RESTA:
	MOV	AH,0
	MOV	AL,N1
	SUB	AL,N2
	CALL 	RESULTADO
	RET

;*********************************************************************
RESULTADO:
	MOV	BINVAL,AX
	CALL	BINASCII

	MOV	DX,OFFSET MRES
	CALL    MOSTRAR_MENSAJE
	MOV	DX,OFFSET ASCVAL
	CALL    MOSTRAR_MENSAJE

FINAL_PROGRAMA:
	MOV	DX,OFFSET MSALIR
        CALL    MOSTRAR_MENSAJE
        CALL    INGRESO
        CMP     AL,'X'
        JE      SALIR
        JMP     CICLOING
	

;*********** PROGRAMA PRINCIPAL *************************
MAIN:   CALL    SEG_DAT
CICLOING:
        MOV     DX,OFFSET MMEN
	CALL    MOSTRAR_MENSAJE

MENU:  	MOV     DX,OFFSET MN1
	CALL    MOSTRAR_MENSAJE
        CALL    INGRESO2DIG
	MOV	N1,BL

        MOV	DX,OFFSET MN2
	CALL    MOSTRAR_MENSAJE
        CALL    INGRESO2DIG
	MOV	N2,BL

	MOV 	DX,OFFSET MN3
	CALL 	MOSTRAR_MENSAJE
	MOV	DX,OFFSET MIN
	CALL    MOSTRAR_MENSAJE
	CALL	INGRESO

	CMP     AL,'M'
        JE      MULTI

	CMP 	AL,'S'
	JE	SUM

	CMP	AL,'R'
	JE	RESTA

	CMP	AL,'D'
	JE	DIVI

	CALL 	FINAL_PROGRAMA


        END
ÿ
ÿ
