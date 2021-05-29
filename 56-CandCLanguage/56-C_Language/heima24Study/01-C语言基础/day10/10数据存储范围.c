#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define MAX 100

int e;
int f = 10;
static int g;
static int h = 10;
int main()
{
    int a = 10;
    static int b;
    static int c = 10;

    int i[10];
    int j[10] = { 0 };

    int *k;
    int *l = &a;

    char *p = "hello world";
    char ch[] = "hello world";

    const int m = 10;

    printf("局部变量a的地址:%p\n", &a);
    printf("未初始化局部静态变量b的地址:%p\n", &b);
    printf("初始化局部静态变量c的地址:%p\n", &c);
    printf("未初始化全局变量e的地址:%p\n", &e);
    printf("初始化全局变量f的地址:%p\n", &f);
    printf("未初始化静态全局变量g的地址:%p\n", &g);
    printf("初始化静态全局变量h的地址:%p\n", &h);

    printf("未初始化数组i的地址：%p\n", i);
    printf("初始化数组j的地址：%p\n", j);

    printf("未初始化指针k的地址：%p\n", &k);
    printf("初始化指针l的地址：%p\n", &l);

    printf("字符串常量p的地址：%p\n", p);
    printf("常量m的地址：%p\n", &m);

    printf("字符数组ch的地址：%p\n", ch);


    //printf("defien定义的常量", &100);
    //printf("defien定义的常量", &MAX);


    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
局部变量a的地址:0060FEA8
未初始化局部静态变量b的地址:0040603C
初始化局部静态变量c的地址:00403010
未初始化全局变量e的地址:00406464
初始化全局变量f的地址:00403008
未初始化静态全局变量g的地址:00406038
初始化静态全局变量h的地址:0040300C
未初始化数组i的地址：0060FE80
初始化数组j的地址：0060FE58
未初始化指针k的地址：0060FE54
初始化指针l的地址：0060FE50
字符串常量p的地址：00404064
常量m的地址：0060FE40
字符数组ch的地址：0060FE44
请按任意键继续. . .
*/
