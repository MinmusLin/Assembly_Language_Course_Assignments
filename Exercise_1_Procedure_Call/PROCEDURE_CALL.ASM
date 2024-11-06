.MODEL SMALL
.STACK 100h

.DATA
    msg db "Hello, world!$", 0

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX
    CALL PrintMessage
    MOV AX, 4C00h
    INT 21h

PrintMessage PROC
    MOV AH, 09h
    LEA DX, msg
    INT 21h
    RET
PrintMessage ENDP

END START