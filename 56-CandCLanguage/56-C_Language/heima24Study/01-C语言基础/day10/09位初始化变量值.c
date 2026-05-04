#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int c;
static int d;
int main()
{

    int a;
    static int b;
    printf("%d\n", a); // 不确定值
    printf("%d\n", b); // 0 （未初始化的静态局部变量，默认初始值为 0）

    b++;
    b *= b;
    printf("%d\n", b); // 1

    // 未初始化的全局变量，默认初始值为 0
    printf("%d\n", c); // 0
    c++;
    c *= c++;
    printf("%d\n", c); // 2

    // 未初始化的静态全局变量，默认初始值为 0
    printf("%d\n", d); //0

    //大数据把栈区占满了
    //int arr[00000000] = {0}; // 4 0000 0000（约等于都381M空间）
    //int arr[7900000] = {0};  // 3160 0000 （约等于都31.1M空间）
    // 栈区大小：
    // 在不同的操作系统中系统分配给每一个程序的栈区空间大小不同
    // 一般 windows 是 1-8M 不等
    // 一般 linux 是 1-16M 不等
    //1024*1024byte
    int arr[100000] = {0}; //约等于0.38M（最多500000）

    // 死循环会死机吗？不会，不会占满内存，会占满 CPU。
    // 递归会占满栈区内存，原因是栈溢出，会导致程序奔溃。
    int i = 0;
//    while (1){ //死循环
//        printf("%d",i++);
//    }

    // 开辟堆空间（只有 C 语言才把数组放在栈空间）
    int *p = (int *)malloc(100000000 * 10); // 开辟 10亿*10*4 空间，约 1G 空间

    getchar();

    system("pause");
    return EXIT_SUCCESS;
}
