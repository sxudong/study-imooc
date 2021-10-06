#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*参考“06 C++对C语言的增强C++语言.cpp”对照*/

/*
* 1、全局变量检测增强
*/
int a;
int a = 10; //C++中会检测出来重新定义了

/*
* 2、函数检测增强
*/
int getRectS(w, h) //没return返回值，C++中检测是不允许过的
{
}
void test02()
{
	getRectS(10, 10, 10); //这个函数要2个参数，传了3个。在C++中检测不过
}

/*
* 3、类型转换检测增强
*/
void test03()
{
	char * p = malloc(sizeof(64)); //malloc返回值是void*
}

/*
* 4、struct 增强
*/
struct Person
{
	int m_Age;
	//void plusAge(); //c语言中struct不可以加函数
};
void test04()
{
	struct Person p1; //使用时候必须加入struct关键字
}

/*
* 5、 bool类型增强  C语言中没有bool类型
*/
//bool flag;

/*
* 6、三目运算符增强
*/
void test06()
{
	int a = 10;
	int b = 20;

	printf("ret = %d \n", a > b ? a : b); //ret = 20

	//a > b ? a : b = 100; //C语言返回的是值“20 = 100 ”

	//C语言中想模仿C++写
	*(a > b ? &a : &b) = 100;
	printf("a = %d ,b = %d \n", a, b); //a = 10, b = 100

}

/*
* 7、 const增强
* C语言中，const修饰的变量，是伪常量，编译器是会分配内存的
* C++中，const不会分配内存,const int m_B = 20;
*/
const int m_A = 10; //受到保护，不可以改
void test07()
{

	//m_A = 100; //报警，不可以修改

	const int m_B = 20; //伪常量
	//m_B = 100; //报警，不可以修改

	//绕过编译器修改掉了
	int * p = (int *) &m_B;
	*p = 200;
	printf("*p = %d , m_B = %d \n", *p, m_B); //*p = 200 , m_B = 200

	//int arr[m_B]; //不可以初始化数组

}



int main(){

	test06();

	test07();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 20
a = 10, b = 100
* p = 200, m_B = 200
请按任意键继续. . .
*/