#define _CRT_SECURE_NO_WARNINGS
#include <time.h>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main15()
{
	//�������������
	srand((unsigned int)time(NULL));
	int num = rand()%100+1;//1-100
	int value;
	while (1)//for(;;)
	{
		scanf("%d", &value);
		if (value > num)
			printf("���������̫����\n");
		else if (value < num)
			printf("���������̫С��\n");
		else
		{
			printf("��ϲ�����н���~\n");
			break;
		}
	}


	system("pause");
	return EXIT_SUCCESS;
}