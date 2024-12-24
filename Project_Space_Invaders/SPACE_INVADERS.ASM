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
    ships dw 0,1,50,50, 0,1,90,50, 0,1,130,50, 0,1,170,50, 0,1,210,50, 0,1,250,50
          dw 0,2,50,70, 0,2,90,70, 0,2,130,70, 0,2,170,70, 0,2,210,70, 0,2,250,70
          dw 0,3,50,90, 0,3,90,90, 0,3,130,90, 0,3,170,90, 0,3,210,90, 0,3,250,90
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
        ; 等待帧同步 - 垂直同步（VSync）
        ; 通过检测 VGA 的垂直同步信号来确保绘制操作与屏幕刷新同步
        mov dx, 3DAh                                        ; VGA 状态寄存器端口地址（0x3DA）

        wait1_:
            in al, dx                                       ; 从 VGA 状态寄存器读取状态
            test al, 8                                      ; 检测垂直同步信号（位 3）
            jz wait1_                                       ; 如果垂直同步信号为 0，继续等待

        wait2_:
            in al, dx                                       ; 再次读取状态
            test al, 8                                      ; 检测垂直同步信号（位 3）
            jnz wait2_                                      ; 如果垂直同步信号为 1，继续等待，直到信号结束

        ; 清屏
        clear_scr:
            mov ecx, 32000                                  ; 设置循环次数为 32000（320x200 分辨率下，每行 320 字节，共 200 行）
            xor eax, eax                                    ; 清零 EAX 寄存器，用于填充显存
            xor di, di                                      ; 清零 DI 寄存器，指向显存起始地址（0xA0000）
            rep stosd                                       ; 重复将 EAX 的值（0）写入 ES:DI 指向的内存，每次写入 4 字节，直到 ECX 为 0

        ; 绘制游戏元素
        draw:
            cmp ships_cnt, 0                                ; 检查敌机数量是否为 0
            jne draw_non_final                              ; 如果不为 0，跳转到 draw_non_final（继续绘制游戏内容）

        ; 绘制最终画面
        draw_final:
            ; 重置 ES 寄存器为数据段
            mov ax, data                                    ; 将数据段地址加载到 AX
            mov es, ax                                      ; 将数据段地址加载到 ES 寄存器

            ; 显示第一条最终消息
            mov ax, 1300h                                   ; 设置功能号为 1300h，用于显示字符串
            mov bx, 0Eh                                     ; 设置显示属性（颜色为亮白色）
            mov dh, 11                                      ; 设置行号为 11
            mov dl, END_MSG1_CENTER                         ; 设置列号为居中位置
            mov cx, END_MSG1_LEN                            ; 设置字符串长度
            lea bp, END_MSG1                                ; 加载字符串 END_MSG1 的地址到 BP
            int 10h                                         ; 调用 BIOS 中断 10h 显示字符串

            ; 显示第二条最终消息
            mov ax, 1300h
            mov bx, 0Fh                                     ; 设置显示属性（颜色为白色）
            mov dh, 13                                      ; 设置行号为 13
            mov dl, END_MSG2_CENTER                         ; 设置列号为居中位置
            mov cx, END_MSG2_LEN                            ; 设置字符串长度
            lea bp, END_MSG2                                ; 加载字符串 END_MSG2 的地址到 BP
            int 10h                                         ; 调用 BIOS 中断 10h 显示字符串

            ; 等待任意键按下
            mov ah, 07h                                     ; 设置功能号为 07h，等待键盘输入（无回显）
            int 21h                                         ; 调用 DOS 中断 21h，等待用户按键

            ; 跳转到退出程序
            jmp exit                                        ; 跳转到 exit 标签，结束程序

        ; 绘制非最终画面
        draw_non_final:
            lea si, ships_models                            ; 加载 ships_models 的地址到 SI，索引 0 是英雄模型
            xor cx, cx                                      ; 清零 CX 寄存器，用于计数

        ; 绘制英雄飞机
        draw_hero:
            mov ax, [hero_y]                                ; 获取英雄的 Y 坐标
            mov di, ax                                      ; 将 Y 坐标复制到 DI 寄存器
            shl ax, 8                                       ; 将 Y 坐标乘以 256（左移 8 位）
            shl di, 6                                       ; 将 Y 坐标乘以 64（左移 6 位）
            add di, ax                                      ; y*64 + y*256 = y*320，计算 Y 坐标对应的行偏移
            add di, [hero_x]                                ; 加上 X 坐标，得到英雄在显存中的起始地址
            mov cx, 8                                       ; 设置循环次数为 8，表示绘制 8 行

            dh_next:                                        ; 绘制新的一行
                movsd                                       ; 从 SI 复制 4 个字节（4 像素）到 ES:DI，绘制 4 个像素
                movsd                                       ; 再次复制 4 个字节，绘制另外 4 个像素
                add di, 320-8                               ; 移动到下一行的起始位置（320 是每行的字节数，减去 8 是因为已经绘制了 8 个像素）
                loop dh_next                                ; 继续绘制下一行，直到 CX 为 0

        ; 绘制子弹
        draw_shot:
            cmp shots_cnt, 0                                ; 检查是否有子弹
            je draw_ships                                   ; 如果没有子弹，跳转到绘制敌机

            xor cx, cx                                      ; 清零 CX 寄存器，用于计数
            lea si, shots                                   ; 加载子弹数组的起始地址到 SI

            ; 循环绘制所有子弹
            ds_loop:
                push cx                                     ; 保存当前计数器 CX 的值
                push si                                     ; 保存当前子弹的地址 SI

                mov ax, 0C04h                               ; 设置功能号为 0C04h，用于在屏幕上绘制一个像素（颜色为红色）
                mov bx, 0h                                  ; 设置页号为 0
                mov cx, [si]                                ; 获取子弹的 X 坐标
                mov dx, [si+2]                              ; 获取子弹的 Y 坐标
                int 10h                                     ; 调用 BIOS 中断 10h，绘制一个像素

                ; 垂直镜像绘制
                mov ax, 0C04h                               ; 再次设置功能号为 0C04h
                inc dx                                      ; 增加 Y 坐标，绘制垂直镜像的像素
                int 10h                                     ; 调用 BIOS 中断 10h，绘制垂直镜像的像素

                ; 水平镜像绘制
                mov ax, 0C04h                               ; 再次设置功能号为 0C04h
                inc cx                                      ; 增加 X 坐标，绘制水平镜像的像素
                int 10h                                     ; 调用 BIOS 中断 10h，绘制水平镜像的像素

                mov ax, 0C04h                               ; 再次设置功能号为 0C04h
                dec dx                                      ; 减少 Y 坐标，回到原始位置
                int 10h                                     ; 调用 BIOS 中断 10h，绘制水平镜像的像素

                pop si                                      ; 恢复子弹的地址 SI
                pop cx                                      ; 恢复计数器 CX 的值

                inc cx                                      ; 增加计数器
                add si, 4                                   ; 移动到下一个子弹（每个子弹占用 4 字节，2 个字）
                cmp cx, shots_cnt                           ; 比较当前计数器是否达到子弹总数
                jb ds_loop                                  ; 如果还有子弹未绘制，继续循环

        ; 绘制敌机
        draw_ships:
            xor cx, cx                                      ; 清零 CX 寄存器，用于计数
            lea bx, ships                                   ; 加载敌机数组的起始地址到 BX

        ; 循环绘制敌机
        draw_ships_loop:
            cmp WORD PTR [bx], 1                            ; 检查当前敌机是否已死亡（状态为 1 表示死亡）
            je ds_loop_inc                                  ; 如果已死亡，跳过绘制，直接增加 BX

            push cx                                         ; 保存当前计数器 CX 的值

            lea si, ships_models                            ; 加载敌机模型的起始地址到 SI

            ; 获取敌机的模型索引
            mov ax, [bx+2]                                  ; 获取敌机的模型索引
            shl ax, 6                                       ; 将模型索引乘以 64（每个模型占用 64 字节）
            add si, ax                                      ; 计算模型在 ships_models 中的偏移地址

            mov ax, [bx+6]                                  ; 获取敌机的 Y 坐标
            mov di, ax                                      ; 将 Y 坐标复制到 DI 寄存器
            shl ax, 8                                       ; 将 Y 坐标乘以 256（左移 8 位）
            shl di, 6                                       ; 将 Y 坐标乘以 64（左移 6 位）
            add di, ax                                      ; y*64 + y*256 = y*320，计算 Y 坐标对应的行偏移
            add di, [bx+4]                                  ; 加上 X 坐标，得到敌机在显存中的起始地址
            mov cx, 8                                       ; 设置循环次数为 8，表示绘制 8 行

            dsh_next:                                       ; 绘制新的一行
                movsd                                       ; 从 SI 复制 4 个字节（4 像素）到 ES:DI，绘制 4 个像素
                movsd                                       ; 再次复制 4 个字节，绘制另外 4 个像素
                add di, 320-8                               ; 移动到下一行的起始位置（320 是每行的字节数，减去 8 是因为已经绘制了 8 个像素）
                loop dsh_next                               ; 继续绘制下一行，直到 CX 为 0

            ; 模型绘制结束
            pop cx                                          ; 恢复计数器 CX 的值

        ; 绘制所有存活的敌机
        ds_loop_inc:
            add bx, 8                                       ; 移动到下一个敌机（每个敌机占用 8 字节）
            inc cx                                          ; 增加计数器
            cmp cx, ships_cnt                               ; 比较当前计数器是否达到敌机总数
            jb draw_ships_loop                              ; 如果还有敌机未绘制，继续循环

        ; 更新画面
        update:

        ; 更新子弹
        update_shot:
            cmp shots_cnt, 0                                ; 检查是否有子弹
            je update_ships                                 ; 如果没有子弹，跳转到更新敌机

            lea si, shots                                   ; 加载子弹数组的起始地址到 SI
            xor cx, cx                                      ; 清零 CX 寄存器，用于计数

            us_loop:
                ; 减少子弹的 Y 坐标
                dec WORD PTR [si+2]                         ; 将当前子弹的 Y 坐标减 1

                cmp WORD PTR [si+2], 0                      ; 检查子弹的 Y 坐标是否小于等于 0
                jg us_loop_inc                              ; 如果 Y 坐标大于 0，跳过删除操作

                ; 移除这颗子弹
                dec shots_cnt                               ; 减少子弹计数器
                cmp shots_cnt, 0                            ; 检查是否所有子弹都已移除
                je update_ships                             ; 如果所有子弹都已移除，跳转到更新敌机

                lea di, shots                               ; 加载子弹数组的起始地址到 DI
                mov ax, shots_cnt                           ; 获取当前子弹计数器
                shl ax, 2                                   ; 将计数器乘以 4（每个子弹占用 4 字节）

                add di, ax                                  ; 计算下一个子弹的地址

                mov ax, [di]                                ; 将下一个子弹的 X 坐标复制到当前子弹的 X 坐标
                mov [si], ax
                mov ax, [di+2]                              ; 将下一个子弹的 Y 坐标复制到当前子弹的 Y 坐标
                mov [si+2], ax

                ; 清除旧的子弹数据
                mov WORD PTR [di], 0                        ; 将下一个子弹的 X 坐标清零
                mov WORD PTR [di+2], 0                      ; 将下一个子弹的 Y 坐标清零

                sub si, 4                                   ; 重新处理当前子弹（因为它的数据已被更新）
                dec cx                                      ; 减少计数器

            us_loop_inc:
                add si, 4                                   ; 移动到下一个子弹
                inc cx                                      ; 增加计数器
                cmp cx, shots_cnt                           ; 比较当前计数器是否达到子弹总数
                jb us_loop                                  ; 如果还有子弹未处理，继续循环

        ; 更新敌机
        update_ships:
            xor cx, cx                                      ; 清零 CX 寄存器，用于计数
            xor ax, ax                                      ; 清零 AX 寄存器，用于统计未死亡的敌机数量
            lea si, ships                                   ; 加载敌机数组的起始地址到 SI

        ; 循环更新敌机
        update_ships_loop:
            cmp WORD PTR [si], 1                            ; 检查当前敌机是否已死亡（状态为 1 表示死亡）
            je ush_loop_inc                                 ; 如果已死亡，跳过更新，直接增加 SI

            inc ax                                          ; 增加未死亡敌机的计数器

            ; 碰撞检测
            cmp shots_cnt, 0                                ; 检查是否有子弹
            je ush_loop_inc                                 ; 如果没有子弹，跳过碰撞检测

            ; 开始模型碰撞检测
            push cx                                         ; 保存当前计数器 CX 的值
            push ax                                         ; 保存未死亡敌机的计数器 AX 的值

            lea di, ships_models                            ; 加载敌机模型的起始地址到 DI

            ; 获取敌机的模型索引
            mov ax, [si+2]                                  ; 获取敌机的模型索引
            shl ax, 6                                       ; 将模型索引乘以 64（每个模型占用 64 字节）
            add di, ax                                      ; 计算模型在 ships_models 中的偏移地址

            xor cx, cx                                      ; 清零 CX 寄存器，用于遍历模型像素

            ush_model:
                cmp BYTE PTR [di], 0                        ; 检查当前模型像素是否为空白（0 表示空白）
                je ush_model_inc                            ; 如果是空白，跳过碰撞检测

                ; 计算像素的实际坐标
                mov ax, cx                                  ; 将 CX 的值复制到 AX
                mov dx, cx                                  ; 将 CX 的值复制到 DX
                shr ax, 3                                   ; 将 AX 右移 3 位，相当于除以 8（获取行号）
                and dx, 7                                   ; 将 DX 与 7 进行按位与操作，获取列号

                ; 获取像素的实际位置
                add dx, WORD PTR [si+4]                     ; 将列号加上敌机的 X 坐标
                add ax, WORD PTR [si+6]                     ; 将行号加上敌机的 Y 坐标

                push di                                     ; 保存模型像素的地址 DI
                push si                                     ; 保存当前敌机的地址 SI
                push cx                                     ; 保存当前模型像素的计数器 CX

                xor cx, cx                                  ; 清零 CX 寄存器，用于遍历子弹
                lea di, shots                               ; 加载子弹数组的起始地址到 DI

                ush_model_shots:
                    mov bx, WORD PTR [di]                   ; 获取子弹的 X 坐标
                    mov si, WORD PTR [di+2]                 ; 获取子弹的 Y 坐标

                    cmp ax, si                              ; 比较敌机像素的 Y 坐标与子弹的 Y 坐标
                    jne ush_model_shots1                    ; 如果不相等，跳过

                    cmp dx, bx                              ; 比较敌机像素的 X 坐标与子弹的 X 坐标
                    je ush_model_shots_disable              ; 如果相等，表示碰撞，跳转到禁用子弹

                ush_model_shots1:
                    inc bx                                  ; 增加子弹的 X 坐标

                    cmp ax, si                              ; 再次比较敌机像素的 Y 坐标与子弹的 Y 坐标
                    jne ush_model_shots2                    ; 如果不相等，跳过

                    cmp dx, bx                              ; 比较敌机像素的 X 坐标与子弹的 X 坐标
                    je ush_model_shots_disable              ; 如果相等，表示碰撞，跳转到禁用子弹

                ush_model_shots2:
                    inc si                                  ; 增加子弹的 Y 坐标

                    cmp ax, si                              ; 再次比较敌机像素的 Y 坐标与子弹的 Y 坐标
                    jne ush_model_shots3                    ; 如果不相等，跳过

                    cmp dx, bx                              ; 比较敌机像素的 X 坐标与子弹的 X 坐标
                    je ush_model_shots_disable              ; 如果相等，表示碰撞，跳转到禁用子弹

                ush_model_shots3:
                    dec bx                                  ; 减少子弹的 X 坐标

                    cmp ax, si                              ; 再次比较敌机像素的 Y 坐标与子弹的 Y 坐标
                    jne ush_model_shots_inc                 ; 如果不相等，跳过

                    cmp dx, bx                              ; 比较敌机像素的 X 坐标与子弹的 X 坐标
                    je ush_model_shots_disable              ; 如果相等，表示碰撞，跳转到禁用子弹

                    jmp ush_model_shots_inc                 ; 如果没有碰撞，跳转到下一个子弹

                ush_model_shots_disable:
                    ; 移除子弹，避免它击中其他敌机
                    dec shots_cnt                           ; 减少子弹计数器
                    lea si, shots                           ; 加载子弹数组的起始地址到 SI
                    mov ax, shots_cnt                       ; 获取当前子弹计数器
                    shl ax, 2                               ; 将计数器乘以 4（每个子弹占用 4 字节）

                    add si, ax                              ; 计算下一个子弹的地址

                    mov ax, [si]                            ; 将下一个子弹的 X 坐标复制到当前子弹的 X 坐标
                    mov [di], ax
                    mov ax, [si+2]                          ; 将下一个子弹的 Y 坐标复制到当前子弹的 Y 坐标
                    mov [di+2], ax

                    ; 清除旧的子弹数据
                    mov WORD PTR [si], 0                    ; 将下一个子弹的 X 坐标清零
                    mov WORD PTR [si+2], 0                  ; 将下一个子弹的 Y 坐标清零

                    ; 完成碰撞检测，跳出循环
                    pop cx                                  ; 恢复模型像素的计数器 CX
                    pop si                                  ; 恢复当前敌机的地址 SI
                    pop di                                  ; 恢复模型像素的地址 DI

                    pop cx                                  ; 恢复未死亡敌机的计数器 CX

                    mov WORD PTR [si], 1                    ; 标记敌机为死亡状态
                    jmp ush_loop_inc                        ; 跳转到下一个敌机

                ush_model_shots_inc:
                    add di, 4                               ; 移动到下一个子弹（每个子弹占用 4 字节）
                    inc cx                                  ; 增加子弹计数器
                    cmp cx, shots_cnt                       ; 比较当前计数器是否达到子弹总数
                    jb ush_model_shots                      ; 如果还有子弹未处理，继续循环

                pop cx                                      ; 恢复模型像素的计数器 CX
                pop si                                      ; 恢复当前敌机的地址 SI
                pop di                                      ; 恢复模型像素的地址 DI

            ush_model_inc:
                inc di                                      ; 移动到下一个模型像素
                inc cx                                      ; 增加模型像素计数器
                cmp cx, 64                                  ; 比较当前计数器是否达到模型像素总数
                jb ush_model                                ; 如果还有模型像素未处理，继续循环

            ; 模型碰撞检测结束
            pop ax                                          ; 恢复未死亡敌机的计数器 AX
            pop cx                                          ; 恢复当前敌机的计数器 CX

        ush_loop_inc:
            add si, 8                                       ; 移动到下一个敌机（每个敌机占用 8 字节）
            inc cx                                          ; 增加敌机计数器
            cmp cx, ships_cnt                               ; 比较当前计数器是否达到敌机总数
            jb update_ships_loop                            ; 如果还有敌机未处理，继续循环

            cmp ax, 0                                       ; 检查是否存在未死亡的敌机
            jne key_handling                                ; 如果存在未死亡的敌机，跳转到按键处理

            ; 如果没有未死亡的敌机，重置敌机计数器
            mov ships_cnt, 0                                ; 将敌机计数器清零

        key_handling:
            ; 检查是否有按键按下
            mov ax, 0100h                                   ; AH = 01h，检查键盘缓冲区是否有按键
            int 16h                                         ; 调用 BIOS 中断 16h，检查是否有按键
            jz main_loop                                    ; 如果没有按键按下（ZF = 1），跳回主循环

            ; 读取实际按键
            mov ah, 07h                                     ; AH = 07h，等待键盘输入（无回显）
            int 21h                                         ; 调用 DOS 中断 21h，读取按键

            ; 如果 AL = 0，表示按下了扩展键（如方向键），需要读取额外的扫描码
            cmp al, 0
            jne key_left                                    ; 如果 AL 不为 0，跳转到处理普通按键
            mov ah, 07h                                     ; 再次读取扩展键的扫描码
            int 21h

            ; 处理按键
            key_left:
                cmp al, 4Bh                                 ; 检查是否按下了左箭头键（扫描码 4Bh）
                jne key_right                               ; 如果不是左箭头键，跳转到处理右箭头键

                cmp hero_x, 0                               ; 检查英雄飞机的 X 坐标是否已经到达左边界
                je main_loop                                ; 如果已经到达左边界，跳回主循环

                dec hero_x                                  ; 向左移动英雄飞机
                jmp main_loop                               ; 跳回主循环

            key_right:
                cmp al, 4DH                                 ; 检查是否按下了右箭头键（扫描码 4Dh）
                jne key_up                                  ; 如果不是右箭头键，跳转到处理上箭头键

                cmp hero_x, 300                             ; 检查英雄飞机的 X 坐标是否已经到达右边界
                je main_loop                                ; 如果已经到达右边界，跳回主循环

                inc hero_x                                  ; 向右移动英雄飞机
                jmp main_loop                               ; 跳回主循环

            key_up:
                ; cmp al, 48H                               ; 检查是否按下了上箭头键（扫描码 48h）
                ; jne key_down                              ; 如果不是上箭头键，跳转到处理下箭头键
                ; dec hero_y                                ; 向上移动英雄飞机
                ; jmp main_loop                             ; 跳回主循环

            key_down:
                ; cmp al, 50h                               ; 检查是否按下了下箭头键（扫描码 50h）
                ; jne key_space                             ; 如果不是下箭头键，跳转到处理空格键
                ; inc hero_y                                ; 向下移动英雄飞机
                ; jmp main_loop                             ; 跳回主循环

            ; 发射子弹
            key_space:
                cmp al, 20H                                 ; 检查是否按下了空格键（ASCII 码 20h）
                jne key_x                                   ; 如果不是空格键，跳转到处理其他按键

                cmp shots_cnt, 10                           ; 检查当前子弹数量是否已达到最大值（10 颗子弹）
                ja key_x                                    ; 如果已达到最大值，跳转到处理其他按键

                ; 复制英雄飞机的坐标到子弹数组
                lea si, shots                               ; 加载子弹数组的起始地址到 SI
                mov ax, shots_cnt                           ; 获取当前子弹数量
                mov bx, 4                                   ; 每个子弹占用 4 字节
                mul bx                                      ; 计算子弹数组的偏移量
                add si, ax                                  ; 计算当前子弹的地址

                mov ax, hero_x                              ; 获取英雄飞机的 X 坐标
                add ax, 3                                   ; 向右偏移 3 个像素（子弹从飞机中间发射）
                mov [si], ax                                ; 将 X 坐标保存到子弹数组
                mov ax, hero_y                              ; 获取英雄飞机的 Y 坐标
                dec ax                                      ; 向上偏移 1 个像素（子弹从飞机上方发射）
                mov [si+2], ax                              ; 将 Y 坐标保存到子弹数组

                inc shots_cnt                               ; 增加子弹数量计数器

                jmp main_loop                               ; 跳回主循环

            key_x:
                cmp al, 78h                                 ; 检查是否按下了 'x' 键（ASCII 码 78h）
                jne main_loop                               ; 如果不是 'x' 键，跳回主循环

            jmp exit                                        ; 如果是 'x' 键，跳转到退出程序

    exit:
        ; 切换回文本模式
        mov ax, 0003h                                       ; 设置功能号为 0003h，切换到文本模式（80x25 文本模式）
        int 10h                                             ; 调用 BIOS 中断 10h，切换到文本模式

        ; 退出程序
        mov ax, 4c00h                                       ; 设置功能号为 4c00h，用于退出程序并返回 DOS
        int 21h                                             ; 调用 DOS 中断 21h，退出程序并返回 DOS

code ends
end start