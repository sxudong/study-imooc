#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int aa = 10;

//在函数内除了常数，静态变量，全局变量外，其它都被销毁。
//1.5.1 编写C语言代码：hello.c 和 2.1.3 const常量， ""引起来的成为 —— 字符串常量.
char * test()
{
    //“字符数组”创建位置在栈区
    //char arr[] = "hello world";

    //“字符串常量”会在程序运行时，字符串放在了常量区，
    //“常量区”不能被修改的，在程序结束时“销毁”。
    char * arr = "hello world";
    //static
    aa = 100;
    //保证指针地址对应的值是有内容的
    return arr;
}


int main()
{
    char * p = test();
    printf("%p\n", p);
    printf("%s\n", p);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
00404064
hello world
请按任意键继续. . .
*/

//strstr   hello  world   llo