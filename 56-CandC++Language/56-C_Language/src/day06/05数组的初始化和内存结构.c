#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main05()
{
	//�������ֵһ�� Ϊ�����Ԫ��һ�θ�ֵ
	//int scores[10] = { 99,89,78,67,56,34,99,21,80,80 };
	//�����ֵʱ������һ��Ϊ����ǰ���Ԫ�ظ�ֵ��������鳤�ȳ���Ԫ�ظ����������ֵȫ����ʼ��Ϊ0
	//int scores[10] = { 12,23,34 };//3 10
	//int scores[] = { 12,23,34 };
	//int scores[10] = { 1 };
	//printf("���鳤�ȣ�%d\n", sizeof(scores) / sizeof(scores[0]));
	//for (int i = 0; i < sizeof(scores) / sizeof(scores[0]); i++)
	//{
	//	printf("%d\n", scores[i]);
	//}

	//ջ�� 
	//������ڴ�ṹ
	int scores[10] = { 99,89,78,67,56,34,99,21,80,80 };
	//%p��ӡ�������ڴ��ַ �����޷���ʮ�����Ƹ�ʽ��ӡ  ��ӡʱ��Ҫ�ڱ���ǰ���� ��&��


	//��ӡ������

	printf("��������Ӧ�ĵ�ַ��%p\n", scores);
	printf("�����һ��Ԫ�ض�Ӧ�ĵ�ַ��%p\n", &scores[0]);
	printf("����ڶ���Ԫ�ض�Ӧ�ĵ�ַ��%p\n", &scores[1]);

	//
	//0000 0000 0000 0000 0000 0000 0110 0011
	//00 00 00 63
	//63 00 00 00
	system("pause");
	return EXIT_SUCCESS;
}