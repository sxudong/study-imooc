#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main05()
{
	int a = 40;
	int b = 50;
	int c = 30;
	//三目
	//int d = a>b ? 1 : 0;
	//表达式1?(表达式2?结果1:结果2):(表达式3?结果1:结果2);
	int d = a > b ? (a > c ? a : c) :( b > c ? b : c);
	printf("%d\n", d);

	return EXIT_SUCCESS;
}