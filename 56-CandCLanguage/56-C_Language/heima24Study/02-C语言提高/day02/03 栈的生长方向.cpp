#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test()
{
    int a = 10;
    int b = 20;
    int c = 30;
    int d = 40;

    printf("a = %d\n", &a);
    printf("b = %d\n", &b);
    printf("c = %d\n", &c);
    printf("d = %d\n", &d);
}

int main(){

    test();

    system("pause");
    return EXIT_SUCCESS;
}
/* 栈的地址从上往下生长，地址越来小：
a = 6356620
b = 6356616
c = 6356612
d = 6356608
请按任意键继续. . .
*/