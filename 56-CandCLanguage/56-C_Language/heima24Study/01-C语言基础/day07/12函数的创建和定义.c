#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//�����Ķ����еĲ����б���е����ݳ�Ϊ��������ʽ����   �β�  �βν���ʵ�� �ں����ڲ���������
void Bubble(int arr[], int len)
{
	for (int i = 0; i < len-1; i++)
	{
		for (int j = 0; j < len - 1 - i; j++)
		{
			if (arr[j] < arr[j + 1])
			{
				int temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}
		}
	}
	return;
}

int main12()
{

	int arr[] = { 3,5,2,7,9,1,8,10,4,6 };
	//������Ϊ���������������˻�Ϊ������  �����˻�Ϊָ��
	//�β� ʵ��  ʵ�ʲ���
	//��������
	Bubble(arr, 10);
	//strcmp()

	for (int i = 0; i < 10; i++)
	{
		printf("%d\n", arr[i]);
	}

	//int arr1[] = { 31,52,21,17,94,10,86 };
	//for (int i = 0; i < 7; i++)
	//{
	//	for (int j = 0; j < 7 - i; j++)
	//	{
	//		if (arr1[j] < arr1[j + 1])
	//		{
	//			int temp = arr1[j];
	//			arr1[j] = arr1[j + 1];
	//			arr1[j + 1] = temp;
	//		}
	//	}
	//}



	system("pause");
	return EXIT_SUCCESS;
}