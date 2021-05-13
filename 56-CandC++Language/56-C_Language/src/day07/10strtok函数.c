#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main10()
{

	char arr[] = "1234567\0qq\0com";
	char *p = strtok(arr, "@");
	while (p != NULL)
	{
		printf("%s\n", p);
		p = strtok(NULL, ".");
	}
	//将切割点用\0表示
	//printf("%s\n", p);
	//printf("%s\n", arr);


	system("pause");
	return EXIT_SUCCESS;
}