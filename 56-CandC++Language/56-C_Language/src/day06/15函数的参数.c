#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

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
int main()
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