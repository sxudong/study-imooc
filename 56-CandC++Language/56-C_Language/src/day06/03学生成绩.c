#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define LEN 5  //��϶�

int main03()
{

	int scores[LEN];
	int sum = 0;
	//����ͨ���������������С
	//int len = sizeof(scores) / sizeof(int);
	//����ͨ������Ԫ�������С
	int len = sizeof(scores) / sizeof(sizeof(scores[0]));

	for (int i = 0; i < len; i++)
	{
		//scnaf("%d", &a);
		//��ͨ������Ϊ���鸳ֵ��ʱ����ҪЩȡ��ַ���š�&��

		scanf("%d", &scores[i]);
		sum += scores[i];//sum = sum+scores[i] avg = sum /10
	}
	//��ӡ�ɼ�
	for (int i = 0; i < len; i++)
	{
		printf("��%d��ѧ�����ɼ���%d\n", i + 1, scores[i]);
	}

	//��������Ԫ�ظ���
	//sizeof(int);//4
	//sizeof(����)
	//����༶ƽ���ɼ�

	printf("�༶ƽ���ɼ�Ϊ:%d\n", sum / len);
	system("pause");
	return EXIT_SUCCESS;
}