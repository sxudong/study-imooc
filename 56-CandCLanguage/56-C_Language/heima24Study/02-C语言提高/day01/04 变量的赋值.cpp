#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test01()
{
	int a = 10;
	//ֱ�Ӹ�ֵ
	a = 100;

	//��Ӹ�ֵ
	int* p = &a;
	*p = 200; //��Ӹ�a��ֵ
}

struct Person
{
	char a;
	int b;
	char c;
	int d;
};

void test02()
{
	struct Person p = { 'a', 100, 'b', 200 };
	printf("p.d:%d\n", p.d); //p.d:200

	p.d = 1000;

	//�൱p�ġ��׵�ַ������ƶ�12���ֽ�
	printf("%d\n", *(int*)((char*)&p + 12)); //1000


	//printf("%d\n", &(p.d));

	printf("---------\n");
	double *pp = NULL;
	printf("p:%d\n", pp); //p:0
	//pp�ġ��׵�ַ����1,11�൱�������ƶ�1��double���ͣ�1��double����ռ8���ֽڣ������8���ֽ�
	printf("p+1:%d\n", pp+1); //p+1:8
}

int main() {

	test02();

	system("pause");
	return EXIT_SUCCESS;
}