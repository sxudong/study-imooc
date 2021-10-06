#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "test.h"


//extern int a = 10; 默认外部链接
int a = 10; //全局区

//静态全局变量是内部链接
static int b = 20; //静态区

//内部链接和外部链接有什么区别？
//1. 如果变量是内部链接的话，那么此变量只能在当前文件内访问
//2. 如果是变量是外部链接的话，那么此变量可以被其他文件使用


//1. 全局静态变量和局部静态变量都存储在静态区，都是在程序运行期间都是合法有效
//2. 局部静态变量符号的可见范围仅限于当前函数内部，全局静态变量可见范围从定义到文件结尾

//头文件不要放定义，只能放声明

void test01()
{
    static int c = 30; //静态区
}

//头文件不参与编译，每一个.c文件，我们叫做一个编译单元
//编译器独立编译每一个.c文件
void test02()
{
    //声明，表示告诉编译器这个符号是存在的，你让我先编译通过，让连接器去找到底这个符号在那
    extern int g_a; //g_a变量在test.h中声明

    printf("g_a = %d\n", g_a);
}


//--------------------------------------
//常量区 字符串常量 全局const变量

/*
 * 1. const全局和局部变量区别？
 *    const全局变量在常量区，不能修改(直接或者间接)
 */
const int g_c = 100;
void test03()
{
    //直接修改不行
    //g_c = 200;

    //间接修改也不行
    int* p = (int*) &g_c;
    *p = 200;

    //全局const放在常量区，一旦初始化，不能修改
}


/*
 * 2. const局部变量
 *    const局部变量在栈上可以被修改。
 */
void test04()
{
    //栈上
    const int a = 100;
    //a = 200;

    int* p = (int*) &a;
    *p = 200;

    printf("a = %d\n", a); //a = 200
}


/*
 * "hello world!" char*类型字符串
 *  字符串常量约定也是不可以修改的。
 */
void test05()
{
#if 0
    char* p = "hello world!";

    //指针p与字符串的地址一样，好处：节省内存（不过有的编译器生成的地址是不一样的）
    printf("%d\n", &"hello world!"); //4210812
    printf("%d\n", p);               //4210812


    printf("gp = %s\n", p); //p = hello world!
    p[0] = 'A';
    printf("p = %s\n", p);  //有些编译区可以修改字符串常量

#endif

    char* p1 = "hello world!";
    char* p2 = "hello world!";

    printf("p1 = %d\n", p1); //p1 = 4210812
    printf("p2 = %d\n", p2); //p2 = 4210812
}


int main() {

    test04();
    test05();

    system("pause");
    return EXIT_SUCCESS;
}
