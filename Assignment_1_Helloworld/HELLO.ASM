.model small
.data
Hello DB 'Hello world!', 0dh, 0ah, '$'
.code
START:
    MOV AX, @DATA
    MOV DS, AX
    MOV DX, offset Hello
    MOV AH, 9
    INT 21H
    MOV AX, 4C00H
    INT 21h
END START