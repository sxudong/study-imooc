#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main06()
{

	char arr1[100] = "hello";
	char arr2[] = "world";
	//strcat(arr1, " nihao ");//hello nihao 
	//strcat(arr1, arr2);//hello nihao world
	strncat(arr1, arr2, 3);//hellowor  ע�⣺����׷��Ҳ�Ὣ\0׷��
	printf("%s\n", arr1);
	printf("%s\n", arr2);

	system("pause");
	return EXIT_SUCCESS;
}