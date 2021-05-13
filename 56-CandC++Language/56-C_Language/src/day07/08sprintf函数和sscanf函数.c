#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main08()
{

	int a = 0;
	char arr[100];
	int b, c;
	//char dest[100] = "hello 123";
	char dest[100]= "1+2=";//1+2=3
	//将数据格式化后放入在字符串中
	//sprintf(dest, "%s %d", arr, a);
	//sscanf(dest, "%s %d", arr, &a);
	sscanf(dest, "%d+%d=", &b, &c);
	sprintf(dest, "%d+%d=%d", b, c, b + c);
	printf("%s\n", dest);
	//printf("%s\n", arr);
	//printf("%d\n", dest);
	//printf("%d+%d=%d", b, c, b + c);
	//system("pause");
	return EXIT_SUCCESS;
}