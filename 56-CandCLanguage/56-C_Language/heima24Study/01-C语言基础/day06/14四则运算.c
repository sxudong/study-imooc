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
