#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void printArray(int** arr, int len)
{
	for (int i = 0; i < len; ++i){
		printf("%d ", *arr[i]);
	}
	printf("\n");
}

void test01()
{
	//���Ϸ���ָ������
	int** pArray = malloc(sizeof(int*) * 6);

	//ջ�Ϸ������ݿռ�
	int a1 = 100;
	int a2 = 200;
	int a3 = 300;
	int a4 = 400;
	int a5 = 500;
	int a6 = 600;

#if 0
	pArray[0] = &a1; //����ָ��ָ��ջ�ϵĻ�����������
	pArray[1] = &a2;
	pArray[2] = &a3;
	pArray[3] = &a4;
	pArray[4] = &a5;
	pArray[5] = &a6;
#endif
	*(pArray + 0) = &a1;
	*(pArray + 1) = &a2;
	*(pArray + 2) = &a3;
	*(pArray + 3) = &a4;
	*(pArray + 4) = &a5;
	*(pArray + 5) = &a6;

	printArray(pArray, 6);

	//�ͷ������ڴ棨�ͷŶ��ڴ棩
	if (pArray != NULL){
		free(pArray);
		pArray = NULL;
	}
}

int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
100 200 300 400 500 600
�밴���������. . .
*/