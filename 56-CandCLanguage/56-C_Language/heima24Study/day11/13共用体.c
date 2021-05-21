#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/**
 * 共用体
 * union 共用体名称 {
 *   成员列表
 * } 共用体变量名
 *
 * 优点是省内存。
 * 缺点是值会被覆盖。
 */
union vars
{
    double a;
    float b;
    int c;
    short d;
    char f;
    //char arr[17];//17
}var;


int main()
{
    printf("%d\n", sizeof(var)); //8
    var.a = 100;
    var.b = 3.14;
    var.c = 66;

    //共用体最后一个赋值一定是准备的，其它的值都会发生变化。
    printf("%f\n", var.a); //100.000000
    printf("%f\n", var.b); //0.000000
    printf("%d\n", var.c); //66

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
8
100.000000
0.000000
66
请按任意键继续. . .
*/