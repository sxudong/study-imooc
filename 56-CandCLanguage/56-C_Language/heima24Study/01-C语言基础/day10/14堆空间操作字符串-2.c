#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{
    //存储在栈区
    char arr[100] = "hello world";
    arr[1] = 'A';

    //存储在堆区
    char * p = malloc(sizeof(char) * 100); // 开辟100个字节空间

    //字符串常量在数据区
    char * p1 = "hello world";
    char * p2 = "hello world";
    //常量中的地址，两个地址一样
    printf("%p\n", p1); //00404064
    printf("%p\n", p2); //00404064

    //存储在堆区
    strcpy(p, "hello world"); //p与p1,p2的地址不一样
    *p = 'A';
    printf("%p\n", p); //00F00F90
    printf("%s\n", p); //Aello world

    free(p);
    return 0;
}
