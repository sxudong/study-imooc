#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//声明变量 就是可以使用这个变量  声明不会分配内存空间
extern int a;

//全局变量 作用整个项目中  使用的前提是需要在使用的文件中进行声明
//int a = 100;
void fun01(int a, int b, int c)
{
    //先赋值c，再赋值b，再赋值a
    //printf("%p\n", &c);
    //printf("%p\n", &b);
    //printf("%p\n", &a);
    a += 10;
    printf("%d\n", a); //20

    //getchar();
}

int main()
{
    printf("%d\n", a); //100
    //变量的作用范围：从创建到所在函数结束
    int a = 10;

    printf("=================\n");
    //{//程序体 代码体  函数体}
    int *p;
    { //程序体，未命名的函数体
        printf("%d\n", a); //10
        int a = 1000; //出函数体变量a就被销毁
        p = &a;
        printf("%d\n", a); //1000
    }
    int b = 100;
    //打针p生命周期出了函数体也可以保存值
    printf("p=%d\n", *p); //p=1000
    printf("=================\n");

    int i = 100;
    for (int i = 0; i < 10; i++)
    {
        printf("%d\n", i);
    }
    printf("%d\n", i); //100
    printf("=================\n");

    //int i = 100;
    fun01(a,a,a);
    printf("%d\n", a); //10
    //system("pause");
    return EXIT_SUCCESS;
}
//如果全局变量写在主函数下面 想使用需要申明
//int a = 100;

/* Output:
100
=================
10
1000
p=1000
=================
0
1
2
3
4
5
6
7
8
9
100
=================
20
10
*/