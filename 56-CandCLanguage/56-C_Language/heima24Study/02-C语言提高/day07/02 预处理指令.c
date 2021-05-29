#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//1 、头文件包含  "" <>区别
// ""包含自定义头文件
// <> 包含系统头文件

//2、 宏 常量
//  不重视作用域
//  可以利用 undef卸载宏
//  宏常量 没有数据类型的

//宏 函数
//  将短小、频繁使用的函数写成宏函数
//  加括号保证运算完整性
//  优点：以空间换时间

void test01()
{
    #define  MAX 1024
    //#undef  MAX
}

//3、 条件编译
//#define  DEBUG
#ifdef DEBUG
void func()
{
    printf("Debug版本发布\n");
}
#else
    //自定义条件编译
#if 0
void func()
{
    printf("Release1版本发布\n");
}
#else
void func()
{
    printf("Release2版本发布\n");
}
#endif

#endif



//特殊宏
void doWork(char * p)
{
    if (p == NULL){
        printf("文件： %s 第 %d 行 出错了\n", __FILE__, __LINE__);
        printf("日期：%s\n", __DATE__);
        printf("时间：%s\n", __TIME__);
        return;
    }
}

void test02()
{
    doWork(NULL);
}


int main(){

    printf("MAX = %d\n", MAX); //MAX = 1024
    func(); //Release2版本发布
    test02();

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
MAX = 1024
Release2版本发布
文件： ..\day06\main.c 第 55 行 出错了
日期：May 29 2021
时间：12:18:34
请按任意键继续. . .
*/