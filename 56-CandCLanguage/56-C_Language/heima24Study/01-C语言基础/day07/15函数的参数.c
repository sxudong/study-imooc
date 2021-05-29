#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


//实参会影响形参的值  形参 不会影响实参的值
int fun01(int a, int b)//a=10 b=20
{
	a++;//11
	b++;//21
	printf("%d\n", a);
	printf("%d\n", b);
	printf("%p\n", &a);
	printf("%p\n", &b);
	return;
}
int main15()
{
	int a = 10;
	int b = 20;
	fun01(a, b);
	printf("%d\n", a);
	printf("%d\n", b);
	printf("%p\n", &a);
	printf("%p\n", &b);



	system("pause");
	return EXIT_SUCCESS;
}