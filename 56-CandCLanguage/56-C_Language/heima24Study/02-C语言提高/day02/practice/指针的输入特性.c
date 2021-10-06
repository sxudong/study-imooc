#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void printStringArray(char **arr, int len)
{
	for (int i = 0; i < len; ++i)
	{
		printf("%s\n", arr[i]);//
	}
}

void allocateSpace(char **p)
{
	char *temp = malloc(sizeof(char) * 100);
	memset(temp, 0, 100);//动态分配内存时，要初始化
	strcpy(temp, "hello world");//
	*p = temp;
}


void printfstring(char **prr,int len)
{
	int *temp = *prr;
	for (int i = 0; i < len; i++)
	{
		printf("%s\n", *(temp + i));

	}

}




void test02()
{
	char * arr[] =
	{
		"aaaaaa",
		"bbbbbb",
		"cccccc",
		"dddddd",
	};

	int len = sizeof(arr) / sizeof(arr[0]);
	printfstring(arr, len);

}




void main()
{
	char *p = NULL;
	allocateSpace(&p);
	printf("p=%s\n", p);
	test02();
	system("pause");

}