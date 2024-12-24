.386                                                        ; 指定代码将以 386 架构（即 Intel 80386 处理器）为目标进行编译或汇编

data segment use16
    cnt db 0                                                ; 定义一个字节变量 cnt，初始化为 0

    ; 英雄飞机的变量
    hero_x dw 50                                            ; 定义英雄飞机的 X 坐标，初始化为 50
    hero_y dw 50                                            ; 定义英雄飞机的 Y 坐标，初始化为 50

    ; 玩家发射的子弹
    shots dw 100 DUP(0)                                     ; 定义一个数组 shots，用于存储玩家发射子弹的坐标，每个子弹的初始值为 0
    shots_cnt dw 0                                          ; 定义变量 shots_cnt，用于记录当前屏幕上的子弹数量，初始化为 0

    ; 敌机模型
    ; 每个敌机模型为 64 字节（8x8），共 4 个敌机模型
    ships_models db '   xx   '                              ; 英雄飞机的图像（8x8像素）
                 db '  xxxx  '
                 db '   xx   '
                 db '  xxxx  '
                 db 'x  xx  x'
                 db 'x  xx  x'
                 db 'x xxxx x'
                 db ' xxxxxx '
                 db ' xxxxxx '
                 db 'x  xx  x'
                 db 'x  xx  x'
                 db 'xxxxxxxx'
                 db '  xxxx  '
                 db '  xxxx  '
                 db ' x    x '
                 db 'x      x'
                 db '        '
                 db '  x   x '
                 db '   x x  '
                 db ' xxxxxx '
                 db 'xx xx xx'
                 db 'xxxxxxxx'
                 db 'x x  x x'
                 db '        '
                 db '   xx   '
                 db '  xxxx  '
                 db ' xxxxxx '
                 db 'xxxxxxxx'
                 db 'xx xx xx'
                 db 'xxxxxxxx'
                 db ' x xx x '
                 db 'x x  x x'
    ships_models_len equ $-ships_models                     ; 计算 ships_models 的长度，用于后续访问

    ; 敌机的状态
    ; （是否死亡、模型索引、X 坐标、Y 坐标）
    ships dw 0,1,100,50, 0,1,130,50, 0,1,160,50, 0,1,190,50, 0,1,210,50, 0,1,240,50
          dw 0,2,100,70 ,0,2,130,70 ,0,2,160,70 ,0,2,190,70 ,0,2,210,70 ,0,2,240,70
          dw 0,3,100,90 ,0,3,130,90 ,0,3,160,90 ,0,3,190,90 ,0,3,210,90 ,0,3,240,90
    ships_cnt dw 18                                         ; 定义总共 18 个敌机

    ; 游戏结束时显示的消息
    END_MSG1 db 01h," Victory !"
    END_MSG1_LEN equ $-END_MSG1                             ; 计算 END_MSG1 字符串的长度
    END_MSG1_CENTER equ 20 - (END_MSG1_LEN/2)               ; 计算 END_MSG1 在屏幕上居中的位置

    END_MSG2 db " Press any key to exit"
    END_MSG2_LEN equ $-END_MSG2                             ; 计算 END_MSG2 字符串的长度
    END_MSG2_CENTER equ 20 - (END_MSG2_LEN/2)               ; 计算 END_MSG2 在屏幕上居中的位置

    ; 游戏开始时显示的消息
    START_MSG1 db 0FH,"  SPACE INVADERS  ",0FH
    START_MSG1_LEN equ $-START_MSG1                         ; 计算 START_MSG1 字符串的长度
    START_MSG1_CENTER equ 20 - (START_MSG1_LEN/2)           ; 计算 START_MSG1 在屏幕上居中的位置

    START_MSG1b db 06H," Assembly Project ",06H
    START_MSG1b_LEN equ $-START_MSG1b                       ; 计算 START_MSG1b 字符串的长度
    START_MSG1b_CENTER equ 20 - (START_MSG1b_LEN/2)         ; 计算 START_MSG1b 在屏幕上居中的位置

    START_MSG2 db "Press any key to start"
    START_MSG2_LEN equ $-START_MSG2                         ; 计算 START_MSG2 字符串的长度
    START_MSG2_CENTER equ 20 - (START_MSG2_LEN/2)           ; 计算 START_MSG2 在屏幕上居中的位置

    START_MSG3 db "Author: Jishen Lin"
    START_MSG3_LEN equ $-START_MSG3                         ; 计算 START_MSG3 字符串的长度
    START_MSG3_CENTER equ 20 - (START_MSG3_LEN/2)           ; 计算 START_MSG3 在屏幕上居中的位置

data ends

code segment use16
    assume cs:code, ds:data

start:
    ; 初始化数据段寄存器
    ; 将数据段地址加载到 DS 和 ES 寄存器中
    mov ax, data
    mov ds, ax
    mov es, ax

    ; 进入图形模式
    ; 设置图形模式为 320x200 分辨率，16 种颜色，显存地址为 A0000h
    mov ax, 0013h
    int 10h

    ; 显示第一条欢迎信息
    mov ax, 1300h                                           ; 设置显示字符串的功能号
    mov bx, 02h                                             ; 设置显示属性（颜色）
    mov dh, 10                                              ; 设置行号
    mov dl, START_MSG1_CENTER                               ; 设置列号（居中）
    mov cx, START_MSG1_LEN                                  ; 设置字符串长度
    lea bp, START_MSG1                                      ; 加载字符串地址
    int 10h                                                 ; 调用 BIOS 中断显示字符串

    ; 显示第二条欢迎信息
    mov ax, 1300h
    mov bx, 04h
    mov dh, 11
    mov dl, START_MSG1b_CENTER
    mov cx, START_MSG1b_LEN
    lea bp, START_MSG1b
    int 10h

    ; 显示第三条欢迎信息
    mov ax, 1300h
    mov bx, 0Fh
    mov dh, 13
    mov dl, START_MSG2_CENTER
    mov cx, START_MSG2_LEN
    lea bp, START_MSG2
    int 10h

    ; 显示第四条欢迎信息
    mov ax, 1300h
    mov bx, 0Fh
    mov dh, 18
    mov dl, START_MSG3_CENTER
    mov cx, START_MSG3_LEN
    lea bp, START_MSG3
    int 10h

    ; 等待任意键按下
    mov ah, 07h
    int 21h

    ; 处理模型数据
    ; 将模型中的空格字符替换为 0，其他字符替换为对应的颜色值
    ; 0 - BLACK    4 - RED	        8 - DARKGRAY      C - LIGHTRED
    ; 1 - BLUE     5 - MAGENTA      9 - LIGHTBLUE     D - LIGHTMAGENTA
    ; 2 - GREEN    6 - BROWN	    A - LIGHTGREEN    E - YELLOW
    ; 3 - CYAN     7 - LIGHTGRAY    B - LIGHTCYAN     F - WHITE

    xor cx, cx                                              ; 清零 CX 寄存器，用于计数
    lea di, ships_models                                    ; 加载模型数据地址到 DI 寄存器

    process_models:
        cmp BYTE PTR [di], ' '                              ; 比较当前字符是否为空格
        je pm_blank                                         ; 如果是空格，跳转到 pm_blank

        cmp cx, 64                                          ; 比较当前处理的字符是否在前 64 个字节内
        jb pm_hero                                          ; 如果是前 64 个字节，跳转到 pm_hero（处理英雄飞机模型）

        mov BYTE PTR [di], 3                                ; 如果不是前 64 个字节，将字符替换为颜色值 3（CYAN）
        jmp pm_inc                                          ; 跳转到 pm_inc 进行下一个字符处理

    pm_hero:
        mov BYTE PTR [di], 2                                ; 如果是前 64 个字节，将字符替换为颜色值 2（GREEN）
        jmp pm_inc                                          ; 跳转到 pm_inc 进行下一个字符处理

    pm_blank:
        mov BYTE PTR [di], 0                                ; 如果是空格，将字符替换为 0（BLACK）

    pm_inc:
        inc di                                              ; 指向下一个字符
        inc cx                                              ; 增加计数器
        cmp cx, ships_models_len                            ; 比较是否处理完所有字符
        jb process_models                                   ; 如果没有处理完，继续循环

    ; 初始化视频显存
    mov ax, 0A000h                                          ; 设置 ES 寄存器为显存段地址
    mov es, ax

    ; 将英雄飞机移动到初始位置
    mov hero_x, 160                                         ; 设置英雄飞机的 X 坐标为 160
    mov hero_y, 150                                         ; 设置英雄飞机的 Y 坐标为 150

    main_loop:
        ; wait the frame - vsync
        mov dx, 3DAh
        wait1_:
            in al,dx
            test al,8
            jz wait1_
        wait2_:
            in al,dx
            test al,8
            jnz wait2_

        ; clear the screen
        clear_scr:
            mov ecx, 32000
            xor eax, eax
            xor di, di
            rep stosd

        draw:
            cmp ships_cnt, 0
            jne draw_non_final

        draw_final:
            ; show final message :)
            ; reset es to data
            mov ax, data
            mov es, ax

            mov ax, 1300h
            mov bx, 0Eh
            mov dh, 11 ;row
            mov dl, END_MSG1_CENTER ; column
            mov cx, END_MSG1_LEN
            lea bp, END_MSG1
            int 10h

            mov ax, 1300h
            mov bx, 0Fh
            mov dh, 13 ;row
            mov dl, END_MSG2_CENTER ; column
            mov cx, END_MSG2_LEN
            lea bp, END_MSG2
            int 10h

            ; press any key :)
            mov ah, 07h
            int 21h

            jmp exit

        draw_non_final:
            lea si, ships_models ; index 0 is hero model
            xor cx, cx

        draw_hero:
            mov ax, [hero_y]		; hero y position
            mov di, ax				; duplicate position
            shl ax, 8				; multiply by 256
            shl di, 6				; multiply by 64
            add di, ax				; y*64 + y*256 = y*320
            add di, [hero_x]		; add x position
            mov cx, 8				; number of lines
            dh_next:				; here draws a new line
                movsd				; draw 4 pixels
                movsd				; draw 4 pixels
                add di,320-8		; point to next line
                loop dh_next		; continue drawing

        ; draw the shot
        draw_shot:

            cmp shots_cnt, 0 ; any shots?
            je draw_ships

            xor cx, cx
            lea si, shots
            ds_loop:
                push cx
                push si

                mov ax, 0C04h
                mov bx, 0h
                mov cx, [si]
                mov dx, [si+2]
                int 10h

                ; mirror vertically
                mov ax, 0C04h
                inc dx
                int 10h

                ; mirror horizontally
                mov ax, 0C04h
                inc cx
                int 10h

                mov ax, 0C04h
                dec dx
                int 10h


                pop si
                pop cx

                inc cx
                add si, 4 ; 2 words
                cmp cx, shots_cnt
                jb ds_loop

        draw_ships:
            xor cx, cx
            lea bx, ships
        draw_ships_loop:
            cmp WORD PTR [bx], 1 ; is dead?
            je ds_loop_inc

            push cx

            lea si, ships_models
            ; get the model index
            mov ax, [bx+2]
            shl ax, 6 ; index * 64bytes (2^6 = 64)
            add si, ax

            mov ax, [bx+6]			; ship y position
            mov di, ax				; duplicate position
            shl ax, 8				; multiply by 256
            shl di, 6				; multiply by 64
            add di, ax				; y*64 + y*256 = y*320
            add di, [bx+4]			; add x position
            mov cx, 8				; number of lines
            dsh_next:				; here draws a new line
                movsd				; draw 4 pixels
                movsd				; draw 4 pixels
                add di,320-8		; point to next line
                loop dsh_next		; continue drawing

            ; model drawing ended
            pop cx
        ds_loop_inc:
            add bx, 8
            inc cx
            cmp cx, ships_cnt
            jb draw_ships_loop

        ; ======= update ============
        update:

        update_shot:
            cmp shots_cnt, 0
            je update_ships

            lea si, shots
            xor cx, cx
            us_loop:

                ; decrease shots's y coord
                dec WORD PTR [si+2]

                cmp WORD PTR [si+2], 0 ; is y outside coords
                jg us_loop_inc ; >0 => skip this

                ; remove this shot
                dec shots_cnt
                cmp shots_cnt, 0
                je update_ships ; we have just removed the latest one!

                lea di, shots
                mov ax, shots_cnt
                shl ax, 2 ; shots_cnt*4

                add di, ax

                mov ax, [di]
                mov [si], ax
                mov ax, [di+2]
                mov [si+2], ax

                ; clear the old value
                mov WORD PTR [di], 0
                mov WORD PTR [di+2], 0


                sub si, 4 ; let's process this one again
                dec cx

            us_loop_inc:
                add si, 4
                inc cx
                cmp cx, shots_cnt
                jb us_loop

        update_ships:

            xor cx, cx
            xor ax, ax ; count "undead" ships
            lea si, ships
        update_ships_loop:
            cmp WORD PTR [si], 1 ; is dead?
            je ush_loop_inc

            inc ax

            ; do we have to check collisions?
            cmp shots_cnt, 0
            je ush_loop_inc

            ; start model check
            push cx
            push ax

            lea di, ships_models
            ; get the model index
            mov ax, [si+2]
            shl ax, 6 ; index * 64bytes (2^6 = 64)
            add di, ax

            xor cx, cx
            ush_model:
                cmp BYTE PTR [di], 0
                je ush_model_inc ; no collision check - blank

                ; compute the pixel
                mov ax, cx
                mov dx, cx
                shr ax, 3 ; divide by 8 = quotient
                and dx, 7 ; modulo 8

                ; get real location
                add dx, WORD PTR [si+4]
                add ax, WORD PTR [si+6]

                push di
                push si
                push cx

                xor cx, cx
                lea di, shots
                ush_model_shots:
                    mov bx, WORD PTR [di]
                    mov si, WORD PTR [di+2]

                    cmp ax, si
                    jne ush_model_shots1

                    cmp dx, bx
                    je ush_model_shots_disable

                ush_model_shots1:
                    inc bx

                    cmp ax, si
                    jne ush_model_shots2

                    cmp dx, bx
                    je ush_model_shots_disable

                ush_model_shots2:
                    inc si

                    cmp ax, si
                    jne ush_model_shots3

                    cmp dx, bx
                    je ush_model_shots_disable

                ush_model_shots3:
                    dec bx

                    cmp ax, si
                    jne ush_model_shots_inc

                    cmp dx, bx
                    je ush_model_shots_disable


                    jmp ush_model_shots_inc
                ush_model_shots_disable:
                    ; remove the shot, so he won't hit anothers
                    dec shots_cnt
                    lea si, shots
                    mov ax, shots_cnt
                    shl ax, 2 ; shots_cnt*4

                    add si, ax

                    mov ax, [si]
                    mov [di], ax
                    mov ax, [si+2]
                    mov [di+2], ax

                    ; clear the old value
                    mov WORD PTR [si], 0
                    mov WORD PTR [si+2], 0

                    ; done checking. jump out now!
                    pop cx
                    pop si
                    pop di

                    pop cx ; ush_model

                    mov WORD PTR [si], 1 ; dead!
                    jmp ush_loop_inc

                ush_model_shots_inc:
                    add di, 4 ; 2 words
                    inc cx
                    cmp cx, shots_cnt
                    jb ush_model_shots

                pop cx
                pop si
                pop di

            ush_model_inc:
                inc di
                inc cx
                cmp cx, 64
                jb ush_model


            ; model checking ended
            pop ax
            pop cx
        ush_loop_inc:
            add si, 8
            inc cx
            cmp cx, ships_cnt
            jb update_ships_loop

            cmp ax, 0 ; did we have at least 1 undead ship?
            jne key_handling
            ; nope. then reset ships_cnt
            mov ships_cnt, 0

        ; ======= key handling code ========
        key_handling:
            ; check if a key is pressed
            mov ax, 0100h
            int 16h
            jz main_loop ; no char = no zero

            ; read now the key for real
            mov ah, 07h
            int 21h

            ; get extra key if we have al=0
            cmp al, 0
            jne key_left
            mov ah, 07h
            int 21h

            ; handle keys
            key_left:
                cmp al, 4Bh
                jne key_right

                cmp hero_x, 0
                je main_loop

                dec hero_x
                jmp main_loop

            key_right:
                cmp al, 4DH
                jne key_up

                cmp hero_x, 300
                je main_loop

                inc hero_x
                jmp main_loop

            key_up:
                ;cmp al, 48H
                ;jne key_down
                ;dec hero_y
                ;jmp main_loop

            key_down:
                ;cmp al, 50h
                ;jne key_space
                ;inc hero_y
                ;jmp main_loop

            ; shoot!
            key_space:
                cmp al, 20H
                jne key_x

                cmp shots_cnt, 10 ; max 10 shots
                ja key_x

                ; copy hero's coords
                lea si, shots ; shots + shots_cnt*4
                mov ax, shots_cnt
                mov bx, 4
                mul bx
                add si, ax

                mov ax, hero_x
                add ax, 3 ; shift right 3 pixels
                mov [si], ax
                mov ax, hero_y
                dec ax ; shift up 1 pixel
                mov [si+2], ax

                inc shots_cnt

                jmp main_loop

            key_x: ;
                cmp al, 78h ; x key --> exit
                jne main_loop

            jmp exit

    exit:
        ; go text
        mov ax, 0003h
        int 10h

        mov ax, 4c00h
        int 21h
code ends
end start