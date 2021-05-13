#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main13()
{
	//字符数组
	//char arr[10] = { 'H','e','l','l','o' };
	//char arr[] = { 'H','e','\','0','o' };
	//char arr[] = "h\n\0e\nllo";
	char arr[100];
	scanf("%[^\n]", arr);
	
	//%s会接收字符串结束标志【'\0'】之前的所有字符 在ASCII中就是数字0
	printf("%s", arr);

	//for (int i = 0; i < 10; i++)
	//{
	//	printf("%c", arr[i]);
	//}
	//printf("%d\n", sizeof(arr));
	//system("pause");
	return EXIT_SUCCESS;
}