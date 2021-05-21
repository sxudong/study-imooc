#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main801()
{
    char arr[] = "hello world";
    char * p;

    p = arr;
    *p = 'A'; //arr[0]，*p == p[0]

    p++; //arr[1]，p++之后*p == p[1]
    *p = 'B';

    printf("%s\n", arr);         //ABllo world
    printf("%d\n", sizeof(arr)); //12 字符串数组含'\0'
    printf("%d\n", strlen(arr)); //11
    printf("%d\n", sizeof(p));   //4
    printf("%d\n", strlen(p));   //10 "Bllo world"10个字符长度

    system("pause");
    return EXIT_SUCCESS;
}

int main08()
{
    char * arr = "hello world";   //常量区
    char  arr1[] = "hello world"; //栈区
    printf("%s\n", arr);    //hello world
    printf("%c\n", arr[0]); //h

    //1.地址赋值一个字符串数组地址
    char * p = arr;
    printf("%p\n", p); //00404064
    //字符串常量是一个常量的数组,可以读取字符或者字符串,但是不能修改
    //p[0] = 'A';
    //*p = 'A';
    printf("%s\n", p); //hello world

    //2.数组引用赋值给p
    p = arr1;
    printf("%p\n", p); //0060FE9C
    p[0] = 'A';
    *p = 'A';
    printf("%s", p); //Aello world
}