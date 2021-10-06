#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* 1. sizeof返回的是变量实际所占用空间的大小，单位字节
* #pragma pack(1)
*/
struct Person
{
	char a; //1 -> 4个字节，有3个字节是空的。a和b上下交换一下，输出总字节会是5
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
* 2. sizeof返回结果是“unsigned int”
*/
void test02()
{
	unsigned int a = 10; //有符号整数据类型
	if (a - 20 > 0)
	{
		printf("大于0\n"); //大于0
	}
	else
	{
		printf("小于0\n");
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
* 3. sizeof计算数组
* 数组作为函数参数会退化为指向数组首元素的指针
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