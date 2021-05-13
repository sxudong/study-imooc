#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main11()
{

	//for (int i = 0; i < 10; i++)
	//{
	//	printf("%d\n", i);
	//}
	int i = 0;
	for (; ; )
	{
		if (i >= 10)
		{
			break;
		}
		printf("%d\n", i);
		i++;
	}

	system("pause");
	return EXIT_SUCCESS;
}