#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main11()
{
	char arr[] = "  100he100llo  ";
	int a = atoi(arr);
	//long a = atol(arr);
	//float a = atof(arr);
	printf("%d\n", a);


	system("pause");
	return EXIT_SUCCESS;
}