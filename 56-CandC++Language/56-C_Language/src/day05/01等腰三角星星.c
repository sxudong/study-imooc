#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{

	int row;
	printf("«Î ‰»Î–– ˝:\n");
	scanf("%d", &row);
	for (int i = 1; i <= row; i++)
	{
		for (int j = 1; j <= row - i; j++)
		{
			printf(" ");
		}
		for (int k = 1; k <= i * 2 - 1; k++)
		{
			printf("*");
		}
		printf("\n");

	}

	system("pause");
	return EXIT_SUCCESS;
}