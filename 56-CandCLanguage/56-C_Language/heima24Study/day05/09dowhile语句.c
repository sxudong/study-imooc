#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main09()
{

	int a = 0;
	do
	{
		a++;
		if (a == 100)
		{
			break;
		}
		printf("%d\n", a);
	} while (a);
	printf("%d\n", a);
	system("pause");
	return EXIT_SUCCESS;
}