#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 1. 主调函数分配内存，被调函数使用内存  指针的输入特性
*/
void printString(const char* str)
{
	//从第2个字符开始打印
	printf("打印内容:%s\n", str + 2); //给它一个地址，它就会一直往后找，直接'\0'结束。
	//strlen();
}

void printDoubleArray(double* arr, int len)
{
	//arr[0]是char类型的
	for (int i = 0; i < len; ++i)
	{
		printf("%lf\n", arr[i]);
	}
}

void printStringArray(char** arr, int len)
{
	//arr[0]是char*类型的
	for (int i = 0; i < len; ++i)
	{
		printf("%s\n", arr[i]);
	}
}

void test01()
{
	//堆上分配内存
	char* s = malloc(sizeof(char) * 100);
	memset(s, 0, 100);
	strcpy(s, "I am Polly!");
	printString(s);

	//数组名左函数参数就会退化为指向数组首元素的指针
	double arr[] = { 1.1, 2.2, 3.3, 4.4, 5.5 };
	int arrlen = sizeof(arr) / sizeof(arr[0]);
	printDoubleArray(arr, arrlen);


	//栈上分配
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
* 2. 输出特性 被调函数分配内存，主调函数使用内存
*/
void allocateSpace(char** temp) //分配空间
{
	char* p = malloc(100);
	memset(p, 0, 100);
	strcpy(p, "hello world!");

	//指针的间接赋值
	*temp = p;
}

void test02()
{
	char* p = NULL;
	allocateSpace(&p);
	printf("p = %s\n", p); //p = hello world!

	if (p != NULL)
	{
		free(p);  //释放内存
		p = NULL; //指向空
	}
}


int main() {

	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
打印内容:am Polly!
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
请按任意键继续. . .
*/
