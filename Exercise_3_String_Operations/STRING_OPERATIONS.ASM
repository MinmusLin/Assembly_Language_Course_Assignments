.MODEL SMALL
.STACK 100h

.DATA
STRBUF DB 'ASASAASASSASASAASAS'
COUNT EQU $-STRBUF
STRING DB 'AS'
MESSG DB 'The Number of "AS" is: $'
NUM DB 0
NEWLINE DB 0AH, 0DH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV NUM, 0
    MOV CX, COUNT
    MOV SI, OFFSET STRBUF
    MOV DI, OFFSET STRING

CHECK_LOOP:
    MOV AL, [SI]
    CMP AL, [DI]
    JNE NEXT_CHAR
    MOV AL, [SI + 1]
    CMP AL, [DI + 1]
    JNE NEXT_CHAR
    INC NUM

NEXT_CHAR:
    INC SI
    LOOP CHECK_LOOP
    MOV AH, 09h
    LEA DX, MESSG
    INT 21h
    MOV AL, NUM
    CALL PRINT_NUM
    MOV AH, 09h
    LEA DX, NEWLINE
    INT 21h
    MOV AH, 4Ch
    INT 21h

MAIN ENDP

PRINT_NUM PROC
    MOV CX, 0
    MOV BX, 10
    MOV AH, 0

CONVERT_LOOP:
    XOR DX, DX
    DIV BX
    ADD DL, '0'
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ CONVERT_LOOP

PRINT_DIGITS:
    POP DX
    MOV AH, 02h
    MOV DL, DL
    INT 21h
    LOOP PRINT_DIGITS
    RET

PRINT_NUM ENDP

END MAIN