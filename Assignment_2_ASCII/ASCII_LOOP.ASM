.MODEL SMALL
.STACK 100h

.DATA
    newline DB 0Dh, 0Ah, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV CX, 26
    MOV AL, 'a'

outer_loop:
    PUSH CX
    MOV CX, 13
    CMP AL, 'z'
    JA end_loop

inter_loop:
    MOV AH, 02h
    MOV DL, AL
    INT 21h
    INC AL
    LOOP inter_loop
    MOV AH, 09h
    LEA DX, newline
    INT 21h
    POP CX
    SUB CX, 13
    JNZ outer_loop

end_loop:
    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN