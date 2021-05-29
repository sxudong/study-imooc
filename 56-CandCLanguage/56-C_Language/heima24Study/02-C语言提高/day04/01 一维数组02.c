#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//�ɶ��� Ҫ�� Ч�ʸ���Ҫ
void printArray(int arr[], int len)
{
	for (int i = 0; i < len; ++i){
		printf("%d ", arr[i]);
		printf("%d ", *(arr + i));
	}
	printf("\n");
}

void test01()
{
	int arr[] = { 1, 2, 3, 4 };

	//1. sizeof  2.��������ȡ��ַ&arr
	//������������£�����������ָ����Ԫ�ص�ָ��
	//������������£�����������������
	//��������������֮�⣬�������������κ�����¶���ָ����Ԫ�ص�ָ��

	printf("sizeof arr:%d\n", sizeof arr);

	printf("&arr addr : %d\n", &arr);
	printf("&arr + 1 addr : %d\n", &arr + 1);

	int* p = arr;

	//��������һ������ָ��
	//arr = NULL;

	//�����±��ܷ��Ǹ���?
	p += 3;
	printf("p[-1]:%d\n", p[-1]);
	printf("p[-1]:%d\n", *(p - 1));

	//����ָ�����ͺ�������Ԫ��ָ������

}


/*
* ��ζ���һ������ָ�������ָ��
*/
void test02()
{
	int arr[5] = { 1, 2, 3, 4, 5 };

	//1. �����ȶ����������ͣ��ٶ�������ָ�����͡�
	//ARRAY_TYPE�Ǳ�����int�����ͣ�[5]������Ԫ�ظ���
	//typedef int ARRAY_TYPE [5];
	typedef int(ARRAY_TYPE)[5];  //typedef unsigned int u32

	ARRAY_TYPE myarray; // int myarray[5];
	for (int i = 0; i < 5; ++i){
		myarray[i] = 100 + i;
	}

	for (int i = 0; i < 5; ++i){
		printf("%d ", myarray[i]);
	}

	/*
	* ��������ȡ��ַ����"ָ�����������ָ��"
	*/
	ARRAY_TYPE* pArray = &myarray;
	pArray = &arr;

	//1. *pArray ��ʾ�õ�pArrayָ��ָ���"��������"
	//2. *pArray���� ������������ָ��"��Ԫ�����͵�ָ��"

	printf("\n*(*pArray + 1) : %d\n", *(*pArray + 1));

	//2. ֱ�Ӷ���"����ָ������"
	typedef int(*ARRAY_POINTER)[5]; //��������
	ARRAY_POINTER pArr = &arr;  //ָ����������

	//3. ֱ�Ӷ���"����ָ�����"
	int(*pArrParam)[5] = &arr;  //ָ����������

}

int main() {

	//test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
100 101 102 103 104
*(*pArray + 1) : 2
�밴���������. . .
*/