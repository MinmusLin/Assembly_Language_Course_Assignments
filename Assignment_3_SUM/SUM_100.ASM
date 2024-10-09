.MODEL SMALL
.STACK 100h

.DATA
    SumResult DB ?
    OutputResult DB ?

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX
    MOV CX, 100
    MOV AX, 0

SumLoop:
    ADD AX, CX
    LOOP SumLoop
    MOV SumResult, AL
    PUSH AX
    MOV CX, 10
    MOV BX, 10000

PrintLoop:
    XOR DX, DX
    MOV AX, BX
    DIV CX
    CMP AX, 0
    JL ExitProgram
    JE ExitProgram
    MOV BX, AX
    XOR DX, DX
    POP AX
    DIV BX
    PUSH DX
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H
    JMP PrintLoop

ExitProgram:
    MOV AH, 4CH
    INT 21H

END START