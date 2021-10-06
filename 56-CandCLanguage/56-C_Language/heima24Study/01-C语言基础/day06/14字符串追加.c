#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main14()
{
	char arr1[] = "hello";//01234
	char arr2[] = "world";
	char arrBuf[100];//'\0'
	
	int index = 0;
	while (arr1[index] != '\0')
	{
		//1、将非\0的字符添加到arrbuf
		arrBuf[index] = arr1[index];
		//2、计数器增长
		index++;
	}
	while (arr2[index - 5] != '\0')
	{
		arrBuf[index] = arr2[index - 5];
		index++;
	}

	// 添加字符串结束标志
	arrBuf[index] = '\0';  // helloworld请按任意键继续. . .
	printf("%s", arrBuf);
	system("pause");
	return EXIT_SUCCESS;
}