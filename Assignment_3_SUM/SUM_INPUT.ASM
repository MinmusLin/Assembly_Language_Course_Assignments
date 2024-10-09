.MODEL SMALL
.STACK 100h

.DATA
    prompt_msg  DB 'Input (1-100): $'
    sum_msg     DB 'Output: $'
    number      DW ?
    sum         DW 0

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    LEA DX, prompt_msg
    MOV AH, 09h
    INT 21h
    XOR CX, CX

READ_INPUT:
    MOV AH, 01h
    INT 21h
    CMP AL, 0Dh
    JE  CALCULATE_SUM
    SUB AL, '0'
    MOV BL, AL
    MOV AX, CX
    MOV CX, 10
    MUL CX
    ADD AX, BX
    MOV CX, AX
    JMP READ_INPUT

CALCULATE_SUM:
    MOV AX, CX
    MOV number, AX
    MOV CX, AX
    MOV BX, 1
    XOR AX, AX

SUM_LOOP:
    ADD AX, BX
    INC BX
    LOOP SUM_LOOP
    MOV sum, AX
    LEA DX, sum_msg
    MOV AH, 09h
    INT 21h
    MOV AX, sum
    CALL PRINT_DECIMAL
    MOV AH, 4Ch
    INT 21h

PRINT_DECIMAL PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    XOR CX, CX
    MOV BX, 10

CONVERT_LOOP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE CONVERT_LOOP

PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP PRINT_LOOP
    POP DX
    POP CX
    POP BX
    POP AX
    RET

PRINT_DECIMAL ENDP

END START