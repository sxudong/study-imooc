#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main12()
{

	for (int i = 100; i < 1000; i++)
	{
		//��һ����λ�����ɸ�λ ʮλ ��λ
		int a = 0, b = 0, c = 0;
		//��λ
		a = i / 100;

		//ʮλ 
		b = i / 10 % 10;
		//��λ
		c = i % 10;
		if (a*a*a + b*b*b + c*c*c == i)
		{
			printf("%d��ˮ�ɻ�\n", i);
		}
	}

	system("pause");
	return EXIT_SUCCESS;
}