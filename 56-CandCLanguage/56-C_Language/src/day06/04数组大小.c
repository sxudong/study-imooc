#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main04()
{

	int score[10];
	//int len = sizeof(score);//40
	//int len1 = sizeof(int);//4
	//printf("%d\n", len);
	printf("数组元素个数：%d\n", sizeof(score) / sizeof(int));
	system("pause");
	return EXIT_SUCCESS;
}