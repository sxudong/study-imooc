#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main05()
{
	int a = 40;
	int b = 50;
	int c = 30;
	//��Ŀ
	//int d = a>b ? 1 : 0;
	//���ʽ1?(���ʽ2?���1:���2):(���ʽ3?���1:���2);
	int d = a > b ? (a > c ? a : c) :( b > c ? b : c);
	printf("%d\n", d);

	return EXIT_SUCCESS;
}