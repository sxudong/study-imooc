#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main12()
{

	int arr[2][3][4] = { 
		{
			{1,2,3,4},
			{2,3,4,5},
			{3,4,5,6}
		},
		{
			{4,5,6,7},
			{5,6,7,8},
			{6,7,8,9}
		}
	};
	
	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 4; k++)
			{
				printf("%d\t", arr[i][j][k]);
			}
			printf("\n");
		}
		printf("=============================================\n");
		
	}

	printf("%d\n", sizeof(arr));
	printf("%d\n", sizeof(arr[0]));
	printf("%d\n", sizeof(arr[0][0]));
	printf("%d\n", sizeof(arr[0][0][0]));

	printf("%p\n", arr);
	printf("%p\n", arr[0]);
	printf("%p\n", arr[0][0]);
	printf("%p\n", &arr[0][0][0]);
	system("pause");
	return EXIT_SUCCESS;
}