#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//可读性 要比 效率更重要
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

	//1. sizeof  2.对数组名取地址&arr
	//以上两种情况下，数组名不是指向首元素的指针
	//以上两种请款下，数组名是数组类型
	//！除了以上两点之外，数据名在其他任何情况下都是指向首元素的指针

	printf("sizeof arr:%d\n", sizeof arr);

	printf("&arr addr : %d\n", &arr);
	printf("&arr + 1 addr : %d\n", &arr + 1);

	int* p = arr;

	//数组名是一个常量指针
	//arr = NULL;

	//数组下标能否是负数?
	p += 3;
	printf("p[-1]:%d\n", p[-1]);
	printf("p[-1]:%d\n", *(p - 1));

	//数组指针类型和数组首元素指针类型

}


/*
* 如何定义一个可以指向数组的指针
*/
void test02()
{
	int arr[5] = { 1, 2, 3, 4, 5 };

	//1. 我们先定义数组类型，再定义数组指针类型。
	//ARRAY_TYPE是别名，int是类型，[5]数组中元素个数
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
	* 对数组名取地址代表"指向整个数组的指针"
	*/
	ARRAY_TYPE* pArray = &myarray;
	pArray = &arr;

	//1. *pArray 表示拿到pArray指针指向的"整个数组"
	//2. *pArray类型 就是数组名，指向"首元素类型的指针"

	printf("\n*(*pArray + 1) : %d\n", *(*pArray + 1));

	//2. 直接定义"数组指针类型"
	typedef int(*ARRAY_POINTER)[5]; //定义类型
	ARRAY_POINTER pArr = &arr;  //指向整个数组

	//3. 直接定义"数组指针变量"
	int(*pArrParam)[5] = &arr;  //指向整个数组

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
请按任意键继续. . .
*/