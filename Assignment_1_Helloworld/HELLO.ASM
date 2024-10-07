.MODEL SMALL                                ; 定义内存模型为small模式
.STACK 100h                                 ; 定义堆栈大小为256字节

.DATA
    Hello DB 'Hello world!', 0dh, 0ah, '$'  ; 定义要输出的字符串 'Hello world!'
                                            ; 0Dh = 回车符 (CR)
                                            ; 0Ah = 换行符 (LF)
                                            ; '$' 表示字符串的结束符，用于DOS的INT 21h功能9

.CODE
START:
    ; 初始化数据段寄存器
    MOV AX, @DATA                           ; 将数据段的基地址存入AX
    MOV DS, AX                              ; 将AX中的数据段地址加载到DS寄存器

    ; 调用DOS中断输出字符串
    MOV DX, offset Hello                    ; 将Hello字符串的地址存入DX
    MOV AH, 9                               ; DOS功能号9：输出字符串，字符串必须以'$'结束
    INT 21H                                 ; 触发中断21h，执行字符串输出

    ; 正常结束程序
    MOV AX, 4C00H                           ; 设置返回代码为0的结束程序指令
    INT 21h                                 ; 触发中断21h，返回到操作系统

END START                                   ; 标记程序结束，START是入口点