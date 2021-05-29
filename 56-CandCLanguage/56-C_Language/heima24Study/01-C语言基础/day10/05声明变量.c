#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "06test.h" //引用自定义头文件

//声明
extern int aa;
//定义
signed int aa = 100; //有符号（默认有符号）

int main()
{
    //auto signed int a = 10;
    //extern int a; //声明
    //int a = 10;   //定义（定义的时候自带声明）

    fun03(); //hello world请按任意键继续. . .

    system("pause");
    return EXIT_SUCCESS;
}

void fun03(){
    printf("hello world");
}