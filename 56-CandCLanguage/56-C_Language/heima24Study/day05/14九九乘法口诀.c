#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main14()
{

	//linux Œﬁ∑®±‡“Î≥Ã–Ú  -std=c90  c99   gcc -o .exe .c -std=c99
	int i, j;
	for (i = 1; i <= 9; i++)
	{
		for (j = 1; j <= i; j++)
		{
			printf("%d*%d=%d\t", j, i, i*j);
		}
		printf("\n");
	}


	system("pause");
	return EXIT_SUCCESS;
}