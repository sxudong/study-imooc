#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main08()
{
	int index = 0;
	while (index <= 100)
	{
		index++;
		//������ 1����7  2��7�ı���  35
		if (index % 7 == 0 || index % 10 == 7 || index / 10 == 7)
		{
			//����
			continue;
		}
		printf("���֣�%d\n", index);
	}


	system("pause");
	return EXIT_SUCCESS;
}