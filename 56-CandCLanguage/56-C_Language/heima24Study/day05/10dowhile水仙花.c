#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main10()
{
	int index = 100;
	do
	{
		//��һ����λ�����ɸ�λ ʮλ ��λ
		int a = 0, b = 0, c = 0;
		//��λ
		a = index / 100;
		//ʮλ 
		b = index / 10 % 10;
		//��λ
		c = index % 10;
		if (a*a*a + b*b*b + c*c*c == index)
		{
			printf("%d��ˮ�ɻ�\n", index);
		}
		index++;
	} while (index < 1000);

	system("pause");
	return EXIT_SUCCESS;
}