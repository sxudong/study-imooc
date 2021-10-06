#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test01()
{
	
	//char *arr[4] = { "aaa", "bbb", "ccc", "ddd" }; //等价于下面的写法

#if 0
	char *p1 = "aaa";
	char *p2 = "bbb";
	char *p3 = "ccc";
	char *p4 = "ddd";

	char *arr[] = { p1, p2, p3, p4 };
#endif

	//返回的是“首元素”的地址
	char **arr = malloc(sizeof(char *)* 4);

	//错误写法
	//char **arr = { "aaa", "bbb", "ccc", "ddd" };
}

void printArray1(int* arr, int len){

}
void printArray2(int (*arr)[3], int len){

}
void printArray1(int** arr, int len){

}

void test02()
{

	//除了sizeof 对数组名取地址这两种情况下，其他任何情况下数组名都是指向“首元素”的指针
	int arr1[10]; //arr1 是 int*类型
	printArray1(arr1,10);

	int arr2[3][3] = {
		{1,2,3},
		{4,5,6},
		{7,8,9}

	};  //arr2 是什么类型？ int(*)[3];
	printArray2(arr2,3);

	char* arr3[] = { "aaa", "bbb", "ccc" };
	//arr3是什么类型？ 首元素是char*类型的，所以arr3是char**类型
	//printArray3(arr3,3);

    //arr4什么类型？ 这是一个一维数组，每个元素是char**类型的，所以arr4是char***类型。
	char** arr4[3];
}

void test03()
{
	typedef int(ARRAY_TYPE)[10]; //用别名定义数组，这个名是自定义的
	typedef int(*ARRAY_POINTER_TYPE)[10]; //它定义的变量直接就是一个指针

	int arr[10];
	int arr2[11];
	ARRAY_TYPE *p1=  &arr;
	ARRAY_POINTER_TYPE p2 = &arr;
	//p2 = &arr2;
	int(*p3)[10] = &arr;
}

struct Person
{
	char name[64];
	int age;
};
//只要结构体“内部”不涉及到“指针”指向堆内存，那么使用默认操作是没有问题的。

struct Teacher
{
	char *name; //涉及到“指针”
	int age;
};

void test04()
{
    /*
    * 结构体赋值
    * 如果结构体内部有指针，并且指向堆空间。那么如果发生赋值行为，就会产生两个问题：
    * 1.同一块空间被释放2次。
    * 2.内存泄露
    *   这就是所谓的“深拷贝”。
    */
	struct Teacher p1, p2;
	//p1 = p2;
}

int main(){

	system("pause");
	return EXIT_SUCCESS;
}