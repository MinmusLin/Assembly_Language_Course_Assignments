.MODEL SMALL
.STACK 100h

.DATA
fib_sum DW 0
MAX_FIB DW 10
newline DB 13, 10, '$'

.CODE
fib_recursive PROC
    PUSH BP
    MOV BP, SP
    CMP AX, 0
    JE fib_zero
    CMP AX, 1
    JE fib_one
    PUSH AX
    DEC AX
    CALL fib_recursive
    MOV BX, AX
    POP AX
    DEC AX
    CALL fib_recursive
    ADD AX, BX
    JMP end_fib

fib_zero:
    MOV AX, 0
    JMP end_fib

fib_one:
    MOV AX, 1

end_fib:
    MOV SP, BP
    POP BP
    RET

fib_recursive ENDP

main PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV CX, MAX_FIB
    MOV AX, 0
    MOV fib_sum, AX

fib_loop:
    MOV AX, CX
    CALL fib_recursive
    ADD fib_sum, AX
    DEC CX
    JNZ fib_loop
    MOV AX, fib_sum
    CALL print_result
    MOV AH, 4Ch
    INT 21h

main ENDP

print_result PROC
    MOV BX, 10
    MOV CX, 0

print_loop:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ print_loop

print_digits:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP print_digits
    LEA DX, newline
    MOV AH, 09h
    INT 21h
    RET

print_result ENDP

END main