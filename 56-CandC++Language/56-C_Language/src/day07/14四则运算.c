#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

extern int add(int a, int b);
extern int sub(int a, int b);
extern int mlt(int a, int b);
extern int dive(int a, int b);


//1、函数的返回值
//2、函数的参数列表
//3、return 和exit(0)
int main14()
{
	//1+2  3 3*4 12 3/0  0 不能作为被除数 4/5 =0

	int a, b;
	char c; 
	int value=0;
	while (1)
	{
		scanf("%d%c%d", &a, &c, &b);
		switch (c)
		{
		case '+':
			//printf("%d+%d=%d\n")
			 value= add(a, b);
			 printf("%d+%d=%d\n", a, b, value);
			 break;
		case '-':
			//printf("%d+%d=%d\n")
			value = sub(a, b);
			printf("%d-%d=%d\n", a, b, value);
			break;
		case '*':
			//printf("%d+%d=%d\n")
			value = mlt(a, b);
			printf("%d*%d=%d\n", a, b, value);
			break;
		case '/':
			if (!b)
			{
				printf("0不能作为除数\n");
				continue;
			}
			//printf("%d+%d=%d\n")
			value = dive(a, b);
			printf("%d/%d=%d\n", a, b, value);
			break;
		}
	}


	system("pause");
	return EXIT_SUCCESS;
}

//函数的定义
int add(int a, int b)
{
	return a + b;
}
int sub(int a, int b)
{
	return a - b;
}
int mlt(int a, int b)
{
	return a*b;
}
int dive(int a, int b)
{
	if (a)
	{
		//return a;
		//代表程序结束
		exit(0);
	}
	return a / b;
}

/*

	1、形参出现在函数定义中，
	在整个函数体内都可以使用，
	离开该函数则不能使用。

	2实参出现在主调函数中，
	进入被调函数后，实参也不能使用。
	3、实参变量对形参变量的数据传递是
	“值传递”，即单向传递，
	只由实参传给形参，
	而不能由形参传回来给实参。
	4、在调用函数时，
	编译系统临时给形参分配存储单元。
	调用结束后，形参单元被释放。
	实参单元与形参单元是不同的单元。
	调用结束后，形参单元被释放，
	函数调用结束返回主调函数后
	则不能再使用该形参变量。
	实参单元仍保留并维持原值。
	因此，在执行一个被调用函数时，
	形参的值如果发生改变，
	并不会改变主调函数中实参的值。


*/