#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <time.h>

/*
1、添加头文件 time.h  stdlib.h
2、添加随机数种子 srand((unsigend int )time(NULL));
3、生成随机数 rand()  %  
*/
int main15()
{
	srand((unsigned int)time(NULL));
	for (int i = 0; i < 100; i++)
	{
		printf("%d\n", rand() % 11 + 50);//50-60
	}


	//system("pause");
	return EXIT_SUCCESS;
}