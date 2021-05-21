#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main12()
{

	for (int i = 100; i < 1000; i++)
	{
		//将一个三位数拆解成个位 十位 百位
		int a = 0, b = 0, c = 0;
		//百位
		a = i / 100;

		//十位 
		b = i / 10 % 10;
		//个位
		c = i % 10;
		if (a*a*a + b*b*b + c*c*c == i)
		{
			printf("%d是水仙花\n", i);
		}
	}

	system("pause");
	return EXIT_SUCCESS;
}