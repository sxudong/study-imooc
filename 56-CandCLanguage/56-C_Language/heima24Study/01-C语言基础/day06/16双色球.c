#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <time.h>

int main()
{
	srand((unsigned int)time(NULL));
	//˫ɫ��  ����ԭɫ ���� + ���� ��6+1��  ���� 1-33   ���� 1-16  ��ӡ˫ɫ���н���Ϣ
	//��ɫ�����ظ�  ����ͺ�������ظ�
	int ball[6];

	//��ɫ
	for (int i = 0; i < 6; i++)
	{
		// qiu = rand()%33 + 1;
		ball[i] = rand() % 33 + 1;
		//ȥ��
		for (int j = 0; j < i; j++)
		{
			if (ball[i] == ball[j])
			{
				i--;
				continue;
			}
		}
	}

	//����
	for (int i = 0; i < 6; i++)
	{
		printf("%d   ", ball[i]);
	}
	printf("+   %d\n", rand() % 16 + 1);
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
22   3   11   23   13   25   +   12
�밴���������. . .
*/