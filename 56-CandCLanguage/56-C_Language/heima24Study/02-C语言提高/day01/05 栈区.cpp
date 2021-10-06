#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 1. 栈区的内存自动申请自动释放，不需要程序手动管理
*/
int* myFunc()
{
	//不要返回局部变量的地址
	int a = 10; //栈上
	return &a;  //编译器报错，不能返回局部变量的地址
}

void test01()
{
	//我们并不关心值是多少，因为局部变量a的内存已经被回收
	int* p = myFunc();
	printf("*p = %d\n", *p);
}



char* getString()
{
	char str[] = "hello world!"; //数组也在栈上，

    //数组名里保存的是“数组首地址”
	return str; //编译器报错。局部变量返回时会被回收，内存被释放掉了，里面什么值都有可能。
}


void test02()
{
	char* s = NULL;

	s = getString();

	printf("s = %s\n", s); //s = 烫烫烫烫烫烫烫烫l鼾
}


int main() {

	//两个方法都会导致编译器报错，不能执行
	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}