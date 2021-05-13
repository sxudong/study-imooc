#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main02()
{

	//定义数组
	int scores[10];
	//初始化数组
	for (int i = 0; i < 10; i++)
	{
		scores[i] = 90 + i;
	}
	//打印数组
	for (int i = 0; i < 10; i++)
	{
		printf("%d\n",scores[i]);
	}

	system("pause");
	return EXIT_SUCCESS;
}