#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main07()
{

	char arr1[] = "hel\0world";
	char arr2[] = "hel\0lorld";
	//int value = strcmp(arr1, arr2);
	//int value = strncmp(arr1, arr2, 3);
	//printf("%d\n", value);
	if (!strncmp(arr1, arr2, 4))
	{
		printf("相同\n");
	}
	else
	{
		printf("不相同\n");

	}

	system("pause");
	return EXIT_SUCCESS;
}