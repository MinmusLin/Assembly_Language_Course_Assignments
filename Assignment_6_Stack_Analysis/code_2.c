#include <stdio.h>

// 递归函数，模拟系统栈空间的使用
void recursive_function(int depth) {
    // 在栈上分配一个大小为 1000 字节的缓冲区
    char buffer[1000];

    // 打印当前递归的深度和缓冲区的地址
    printf("Recursion Depth: %d\tBuffer Address: %p\n", depth, buffer);

    // 如果递归深度小于 10000，则继续递归
    if (depth < 10000) {
        recursive_function(depth + 1);
    }
}

int main() {
    // 从递归深度 0 开始调用递归函数
    recursive_function(0);

    return 0;
}