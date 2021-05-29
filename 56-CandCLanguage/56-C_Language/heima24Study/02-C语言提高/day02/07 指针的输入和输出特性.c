#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 1. �������������ڴ棬��������ʹ���ڴ�  ָ�����������
*/
void printString(const char* str)
{
	//�ӵ�2���ַ���ʼ��ӡ
	printf("��ӡ����:%s\n", str + 2); //����һ����ַ�����ͻ�һֱ�����ң�ֱ��'\0'������
	//strlen();
}

void printDoubleArray(double* arr, int len)
{
	//arr[0]��char���͵�
	for (int i = 0; i < len; ++i)
	{
		printf("%lf\n", arr[i]);
	}
}

void printStringArray(char** arr, int len)
{
	//arr[0]��char*���͵�
	for (int i = 0; i < len; ++i)
	{
		printf("%s\n", arr[i]);
	}
}

void test01()
{
	//���Ϸ����ڴ�
	char* s = malloc(sizeof(char) * 100);
	memset(s, 0, 100);
	strcpy(s, "I am Polly!");
	printString(s);

	//���������������ͻ��˻�Ϊָ��������Ԫ�ص�ָ��
	double arr[] = { 1.1, 2.2, 3.3, 4.4, 5.5 };
	int arrlen = sizeof(arr) / sizeof(arr[0]);
	printDoubleArray(arr, arrlen);


	//ջ�Ϸ���
	const char* strs[] = {
		"aaaaa",
		"bbbbb",
		"ccccc",
		"ddddd",
		"eeeee",
	};

	int len = sizeof(strs) / sizeof(strs[0]);

	printStringArray(strs, len);

	printf("----------------\n");
}

/*
* 2. ������� �������������ڴ棬��������ʹ���ڴ�
*/
void allocateSpace(char** temp) //����ռ�
{
	char* p = malloc(100);
	memset(p, 0, 100);
	strcpy(p, "hello world!");

	//ָ��ļ�Ӹ�ֵ
	*temp = p;
}

void test02()
{
	char* p = NULL;
	allocateSpace(&p);
	printf("p = %s\n", p); //p = hello world!

	if (p != NULL)
	{
		free(p);  //�ͷ��ڴ�
		p = NULL; //ָ���
	}
}


int main() {

	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��ӡ����:am Polly!
1.100000
2.200000
3.300000
4.400000
5.500000
aaaaa
bbbbb
ccccc
ddddd
eeeee
----------------
p = hello world!
�밴���������. . .
*/
