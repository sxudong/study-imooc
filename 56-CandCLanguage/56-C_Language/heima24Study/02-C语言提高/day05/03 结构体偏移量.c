#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stddef.h>

#pragma pack(show) //�������ģ����Ĭ�϶���ģ����8��

/*
* �ṹ��ƫ����
* ֻҪʹ���ṹ��ġ���ַ���͡�ƫ�������Ϳ���ȡ�������������
*/


struct A
{
	char a1; // 0
	int a2;  // 4 - 7  //a2��ַ��4��ʼ��7
};

void test01()
{
	struct A a = { 'b', 20 };
	//ͨ��ָ���õ����ԡ�a2����ֵ,offsetof()���ҽṹ��A��ƫ�Ƶ�a2��ֵ��
	printf("A.a2:%d\n", *(int*)((char*)&a + offsetof(struct A, a2))); //A.a2:20
	printf("A.a2:%d\n", *((int*)&a + 1)); //A.a2:20
}

struct C
{
	int a;
	double b;
};

struct B
{
	char a;
	int b;
	struct C c; //Ƕ����һ���ṹ��C���ȼ��������ע��
};

//struct B
//{
//	char a;
//	int b;
//	int a;
//	double b;
//};


void test02()
{
	struct B b = { 'a', 20, 30, 3.14 };

	//����ƫ����
	int off1 = offsetof(struct B, c);
	int off2 = offsetof(struct C, b);

	printf("%f\n", *(double*)(((char*)&b + off1) + off2)); //3.140000
	printf("%d\n", &(b.c.b));                              //8059716
	printf("%f\n", ((struct C*)((char*)&b + off1))->b);    //3.140000
}


//1. ��һ��Ԫ��ƫ������0
//2. �ӵڶ���Ԫ�ؿ�ʼ����ƫ����

struct Student {
	int a;    //  0-3
	char b;   //  4-7   //b���ڵ�ַ4��
	double c; //  8-15  //c���ڵ�ַ8��
	float d;  // 16-19  //d���ڵ�ַ16��
};
//�ṹ�����һ������ƫ�ƣ��ҽṹ�����ĳ�Ա double���Ͷ���ģ��8�ȣ����յı���������8�ı�����

void test03()
{
	printf("%d\n", sizeof(struct Student)); //24
}


int main() {

	test01();
	printf("----------02----------\n");
	test02();
	printf("----------03----------\n");
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
A.a2:20
A.a2:20
----------02----------
3.140000
8059716
3.140000
----------03----------
24
�밴���������. . .
*/