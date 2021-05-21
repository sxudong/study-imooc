#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stdlib.h>

/**
 * 开辟堆空间和释放堆空间
 */
int main()
{
    int a = 10;

    //8.2.4 堆区内存分配和释放
    //void *malloc(size_t size);
    //功能：在内存的动态存储区(堆区)中分配一块长度为size字节的连续区域，
    //用来存放类型说明符指定的类型。

    //定义一个变量在"堆中"  单位是byte
    //char* p = (char*)malloc(1); //开辟1个字节的空间,定义char接收，开辟完之后会返回1个空间大小地址。
    char *p = (char *)malloc(sizeof(char)); //char类型是1个字节的空间

    //*p是值（开辟一个堆空间，返回它的地址，改变它的值）
    *p = 100;
    printf("%c\n", *p); //d

    //释放，根据首地址自动释放。
    //如果创建完的堆空间在使用结束之后“不释放”，会占用系统资源。
    //free(p);

    //int arr[10];
    //这个 c 等同于上面的 arr,这两个写法是一样的，操作c等同于操作arr
    int * c = (int *)malloc(sizeof(int) * 10); // 4*10 (10个int类型大小区),c相当于数组中的首地址

    for (int i = 0; i < 10; i++){
        c[i] = i;
    }

    for (int i = 0; i < 10; i++)
        //printf("%d\n", *(c + i)); //另外一种操作指针的方式
        printf("%d\n", c[i]);


    free(c);

    system("pause");
    return EXIT_SUCCESS;
}
/*
d
0
1
2
3
4
5
6
7
8
9
请按任意键继续. . .
*/
