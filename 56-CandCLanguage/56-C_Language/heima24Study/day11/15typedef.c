#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
//#include "studentsInfoList.h"

/**
 * 9.4 typedef
 * typedef为C语言的关键字，作用是为一种数据类型(基本类型或自定义数据类型)
 * 定义一个新名字，不能创建新类型。
 */
//定义别名可以简化定义代码
typedef unsigned long long ull; //无符号长整型

//结构体一般定义在.h头文件中
struct studentsInfoList
{
    char name[20];
    char sex;
};
//定义别名可以简化定义代码
typedef struct studentsInfoList sinfo;

int main()
{
    //struct studentsInfoList sinfo;
    sinfo s1;
    s1.name;
    s1.sex;

    ull a = 10;

    printf("%d\n", a);

    system("pause");
    return EXIT_SUCCESS;
}
/*
10
请按任意键继续. . .
*/