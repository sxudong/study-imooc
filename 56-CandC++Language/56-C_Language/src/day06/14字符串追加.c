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
		//1������\0���ַ���ӵ�arrbuf
		arrBuf[index] = arr1[index];
		//2������������
		index++;
	}
	while (arr2[index - 5] != '\0')
	{
		arrBuf[index] = arr2[index - 5];
		index++;
	}

	// ����ַ���������־
	arrBuf[index] = '\0';  // helloworld�밴���������. . .
	printf("%s", arrBuf);
	system("pause");
	return EXIT_SUCCESS;
}