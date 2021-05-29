#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* 1. sizeof���ص��Ǳ���ʵ����ռ�ÿռ�Ĵ�С����λ�ֽ�
* #pragma pack(1)
*/
struct Person
{
	char a; //1 -> 4���ֽڣ���3���ֽ��ǿյġ�a��b���½���һ�£�������ֽڻ���5
	int b;  //4
};
void test01()
{
	printf("int size:%d\n", sizeof(int)); //int size : 4
	double a = 3.14;
	printf("a size:%d\n", sizeof a); //a size : 8

	printf("Person size:%d\n", sizeof(struct Person)); //Person size : 8
}


/*
* 2. sizeof���ؽ���ǡ�unsigned int��
*/
void test02()
{
	unsigned int a = 10; //�з�������������
	if (a - 20 > 0)
	{
		printf("����0\n"); //����0
	}
	else
	{
		printf("С��0\n");
	}


	if (sizeof(int) - 5 < 0)
	{
		printf("< 0\n");
	}
	else
	{
		printf("> 0\n"); //> 0
	}
}



/*
* 3. sizeof��������
* ������Ϊ�����������˻�Ϊָ��������Ԫ�ص�ָ��
*/
int caculateArraySize(int arr[])
{
	return sizeof(arr);
}

void test03()
{
	int arr[] = { 1, 2, 3, 4, 5, 6, 7 };
	printf("sizeof arr:%d\n", sizeof(arr)); //sizeof arr:28
	printf("sizeof arr:%d\n", caculateArraySize(arr)); //sizeof arr:4
}

int main() {

	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}