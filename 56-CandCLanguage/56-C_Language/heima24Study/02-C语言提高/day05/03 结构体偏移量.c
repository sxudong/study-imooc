#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stddef.h>

#pragma pack(show) //对齐规则模数（默认对齐模数是8）

/*
* 结构体偏移量
* 只要使到结构体的“地址”和“偏移量”就可以取到它里面的数据
*/


struct A
{
	char a1; // 0
	int a2;  // 4 - 7  //a2地址从4开始到7
};

void test01()
{
	struct A a = { 'b', 20 };
	//通过指针拿到属性“a2”的值,offsetof()查找结构体A，偏移到a2的值。
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
	struct C c; //嵌套另一个结构体C。等价于下面的注释
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

	//计算偏移量
	int off1 = offsetof(struct B, c);
	int off2 = offsetof(struct C, b);

	printf("%f\n", *(double*)(((char*)&b + off1) + off2)); //3.140000
	printf("%d\n", &(b.c.b));                              //8059716
	printf("%f\n", ((struct C*)((char*)&b + off1))->b);    //3.140000
}


//1. 第一个元素偏移量是0
//2. 从第二个元素开始计算偏移量

struct Student {
	int a;    //  0-3
	char b;   //  4-7   //b放在地址4上
	double c; //  8-15  //c放在地址8上
	float d;  // 16-19  //d放在地址16上
};
//结构体会做一个整体偏移，找结构体最大的成员 double，和对齐模数8比，最终的倍数必需是8的倍数。

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
请按任意键继续. . .
*/