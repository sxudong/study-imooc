#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{
	int i = 5;
	printf("hello world1\n");
	goto Here;
	printf("hello world2\n");
	printf("hello world3\n");
	printf("hello world5\n");
	printf("hello world6\n");
	printf("hello world7\n");

	for (; i < 10; i++)
	{
	//Here:
		printf("hello world4\n");
	//if()
	}

	system("pause");
	return EXIT_SUCCESS;
Here:

	//语句
	printf("hello world7\n");

}