#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main07()
{

	int a = 0;
	int sum = 0;
	while (a<100)
	{
		a++;//a+=1 a=a+1
		sum += a;
		//printf("a=%d\n", a);
	}
	printf("1到100的和为：%d\n", sum);
	system("pause");
	return EXIT_SUCCESS;
}