#include <stdio.h>
#include <stdlib.h>

// 全局变量（已初始化）
int global_var = 1;

// 全局变量（未初始化）
int uninitialized_var;

// 打印各个变量存储地址的函数
void print_addresses() {
    // 局部变量
    int local_var = 2;

    // 动态分配内存，创建堆区变量
    int* heap_var = (int*)malloc(sizeof(int));
    if (heap_var == NULL) {
        printf("内存分配失败\n");  // 如果内存分配失败，输出错误信息
        return;
    }

    *heap_var = 3;  // 给堆区变量赋值

    // 打印各个变量的存储地址
    printf("代码段地址:           %p\n", (void*)print_addresses);     // 打印代码段地址
    printf("全局变量地址:         %p\n", (void*)&global_var);         // 打印全局变量的地址
    printf("未初始化全局变量地址: %p\n", (void*)&uninitialized_var);  // 打印未初始化的全局变量地址
    printf("栈区地址:             %p\n", (void*)&local_var);          // 打印栈区局部变量的地址
    printf("堆区地址:             %p\n", (void*)heap_var);            // 打印堆区变量的地址

    // 释放堆区内存
    free(heap_var);
}

int main() {
    print_addresses();  // 调用打印地址的函数

    return 0;
}