#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


void  fun02(int a, int b)
{
	int c = a + b;
	printf("%d\n", c);
	return;
}
int fun03(int a, int b)
{
	int c = a + b;
	return c;
}
void fun04()
{
	printf("===========================\n");
}
int main17()
{

	/*
	1、有参无返
	2、有参有返
	3、无参无返
	*/
	fun04();
	fun02(10, 20);
	fun04();
	int ab = fun03(10, 20);
	printf("%d\n", ab);
	fun04();



	system("pause");
	return EXIT_SUCCESS;
}