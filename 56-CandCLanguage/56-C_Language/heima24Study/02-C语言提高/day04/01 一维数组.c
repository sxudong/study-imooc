#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//可读性 要比 效率更重要
void printArray(int arr[], int len)
{
	for (int i = 0; i < len; ++i){
	    //程序都是根据地址来处理的，程序根本就没有什么下标，这是语法，代码可读性，方便程序员写程序。
		printf("%d ", arr[i]);
		//printf("%d ", *(arr + i)); //与上面一条代码一样的结果，上面语法可读性更好。
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

	printf("sizeof arr:%d\n", sizeof arr);    //16

	printf("&arr addr : %d\n", &arr);         //7338384
	printf("&arr + 1 addr : %d\n", &arr + 1); //7338400  //加了16个字节，加了整个数组大小。

	int* p = arr;


	//数组名是一个“常量指针”
	//arr = NULL;   //err 不能修改

	//数组下标能否是负数?不能
	p += 3;
	printf("p[-1]:%d\n", p[-1]);     //p[-1]:3
	printf("p[-1]:%d\n", *(p - 1));  //p[-1]:3  //编译器把在底层把p[-1]转换成*(p - 1)地址操作

    //“数组指针类型” 和 “数组首元素指针类型”

	printArray(arr, sizeof(arr)/sizeof(arr[0]));
}


int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
sizeof arr:16
&arr addr : 7338384
&arr + 1 addr : 7338400
p[-1]:3
p[-1]:3
1 2 3 4
请按任意键继续. . .
*/