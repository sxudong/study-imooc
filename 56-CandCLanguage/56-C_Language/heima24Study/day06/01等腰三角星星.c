#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main01()
{

	int row;
	printf("����������:\n");
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
	//�൱�ڶ���10��int���͵ı���  []�������ĳ�ΪԪ�ظ���
	int scores[10];//scores[0] ��scores[9]
	//�ҵ������еĳ�Ա   �±��Ǵ�0 ��ʼ�� scores[0]
	//int score_01,score_02;
	//score_01 = 100;
	//score_02 = 99;
	//printf("01��%d\n", score_01);
	//printf("02��%d\n", score_02);
	system("pause");
	return EXIT_SUCCESS;
}