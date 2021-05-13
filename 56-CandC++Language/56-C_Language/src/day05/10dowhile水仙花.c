#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main10()
{
	int index = 100;
	do
	{
		//将一个三位数拆解成个位 十位 百位
		int a = 0, b = 0, c = 0;
		//百位
		a = index / 100;
		//十位 
		b = index / 10 % 10;
		//个位
		c = index % 10;
		if (a*a*a + b*b*b + c*c*c == index)
		{
			printf("%d是水仙花\n", index);
		}
		index++;
	} while (index < 1000);

	system("pause");
	return EXIT_SUCCESS;
}