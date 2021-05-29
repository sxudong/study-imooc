#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//定义全局变量
//extern  int a1;
extern int a2;
static int b1 = 10; //静态全局变量
int b2 = 100;

void fun02(){
    int a = 10;
    printf("%d\n", a++);
}
/* Output:
10
10
10
10
10
10
10
10
10
10
*/

void fun03(){
    static int a = 10;
    printf("%d\n", a++);
}
/* Output:
10
11
12
13
14
15
16
17
18
19
*/

int main()
{
    //变量可以重复赋值，static变量也可以被重复赋值。
    int a1 = 10;
    a1 = 100;
    //静态局部变量
    static int a2 = 10;
    a2 = 100;
    printf("%d\n", a1); //100
    printf("%d\n", a2); //100


    //测试static变量与普通定义变量
    for (int i = 0; i < 10; i++){
        fun02();
    }
    for (int i = 0; i < 10; i++){
        fun03(); //static只初始化一次
    }

    //static int a = 100;

    //全局变量，这里是重新赋值操作
    b1 = 100;
    printf("%d\n", b1); //100
    b2 = 1000;
    printf("%d\n", b2); //1000

    system("pause");
    return EXIT_SUCCESS;
}

//int a = 10;
