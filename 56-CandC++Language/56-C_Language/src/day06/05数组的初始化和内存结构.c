#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main05()
{
	//像变量赋值一样 为数组的元素一次赋值
	//int scores[10] = { 99,89,78,67,56,34,99,21,80,80 };
	//如果赋值时括号中一次为数组前面的元素赋值，如果数组长度超过元素个数，后面的值全部初始化为0
	//int scores[10] = { 12,23,34 };//3 10
	//int scores[] = { 12,23,34 };
	//int scores[10] = { 1 };
	//printf("数组长度：%d\n", sizeof(scores) / sizeof(scores[0]));
	//for (int i = 0; i < sizeof(scores) / sizeof(scores[0]); i++)
	//{
	//	printf("%d\n", scores[i]);
	//}

	//栈区 
	//数组的内存结构
	int scores[10] = { 99,89,78,67,56,34,99,21,80,80 };
	//%p打印变量的内存地址 是以无符号十六进制格式打印  打印时需要在变量前加上 【&】


	//打印数组名

	printf("数组名对应的地址：%p\n", scores);
	printf("数组第一个元素对应的地址：%p\n", &scores[0]);
	printf("数组第二个元素对应的地址：%p\n", &scores[1]);

	//
	//0000 0000 0000 0000 0000 0000 0110 0011
	//00 00 00 63
	//63 00 00 00
	system("pause");
	return EXIT_SUCCESS;
}