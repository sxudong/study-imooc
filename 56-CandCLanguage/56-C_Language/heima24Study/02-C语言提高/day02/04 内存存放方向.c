#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main(){

    int* p1 = 0x1234;    //一级指针
    int*** p2 = 0x1111;  //三级指针

    printf("p1 size:%d\n",sizeof(p1)); // p1 size:4
    printf("p2 size:%d\n",sizeof(p2)); // p2 size:4


    //指针是变量，指针本身也占内存空间，指针也可以被赋值
    int a = 100;
    p1 = &a;

    //指针地址（要用二级指针接收）
    printf("p1 address:%p\n", &p1); // p1 address:0060FEA8
    //找的是a的地址
    printf("p1 address:%p\n", p1);  // p1 address:0060FEA4
    printf("a address:%p\n", &a);   // a address:0060FEA4

    printf("%s\n", p1); //d

    system("pause");
    return EXIT_SUCCESS;
}