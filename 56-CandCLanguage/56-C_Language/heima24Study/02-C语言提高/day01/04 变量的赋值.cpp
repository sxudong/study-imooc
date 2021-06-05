#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test01()
{
	int a = 10;
	//直接赋值
	a = 100;

	//间接赋值
	int* p = &a;
	*p = 200; //间接给a赋值
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

	//相当p的“首地址”向后移动12个字节
	printf("%d\n", *(int*)((char*)&p + 12)); //1000


	//printf("%d\n", &(p.d));

	printf("---------\n");
	double *pp = NULL;
	printf("p:%d\n", pp); //p:0
	//pp的“首地址”加1,11相当于往后移动1个double类型，1个double类型占8个字节，向后移8个字节
	printf("p+1:%d\n", pp+1); //p+1:8
}

int main() {

	test02();

	system("pause");
	return EXIT_SUCCESS;
}