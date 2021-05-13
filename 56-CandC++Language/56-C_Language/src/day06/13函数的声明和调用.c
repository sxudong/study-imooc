#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//1、声明  声明函数的格式
extern int add01(int a, int b);

int main13()
{

	//3、调用  执行函数 需要完成某些功能  声明 定义一次之后 可以多次调用
	int a = add01(10, 20);
	printf("%d\n", a);

	system("pause");
	return EXIT_SUCCESS;
}

//2、定义  函数的定义就是对函数功能的实现
int add01(int a, int b)
{
	return a + b;
}