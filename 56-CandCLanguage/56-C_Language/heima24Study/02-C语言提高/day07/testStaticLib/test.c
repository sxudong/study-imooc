#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"mylib.h" //引用拷贝过来的“静态库”头文件


/*
* 12.2.2 静态库的使用
*/
int main(){

	int a = 10;
	int b = 20;

	//调用“静态库”里的函数方法
	int ret = myAdd(a, b);

	printf("ret = %d\n", ret);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 30
请按任意键继续. . .
*/