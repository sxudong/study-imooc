#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//该函数是无返回值的函数，函数在执行之后，函数体内的变量会销毁掉
void tab1(int a, int b)
{
    int temp = a;
    a = b;
    b = temp;
    printf("%d   %d\n", a, b); //20   10
    return;
}

//指针函数
void tab2(int *a, int *b)
{
    int temp = *a;
    *a = *b;       //修改指针指向的内存值
    *b = temp;     //修改指针指向的内存值
}

int main()
{
    int a = 10;
    int b = 20;

    tab1(a, b);

    //无需返回值，通过指针就可以获取值
    tab2(&a, &b);
    printf("%d   %d\n", a, b); //20   10

    return 0;
}