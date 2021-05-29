#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int arr[10];

/*
* 决定的函数的类型应该是：函数的返回值  函数的参数列表
*/

void func() //func函数名其实是代表函数的入口地址
{
	printf("hello world!");
}


//如何去定义一个指向函数的指针
int myfunc(int a, char b)
{
	printf("int myfunc(int a,char b) !\n");
	return 0;
}

void test01()
{
	/*
	* 1.定义“函数类型”，通过“类型”来定义“函数指针”
	*/
	typedef int(FUN_TYPE)(int, char);  //int myfunc(int a, char b)
	FUN_TYPE* pFunc = myfunc;

	pFunc(10, 'a');    //调用myfunc()函数
	(*pFunc)(20, 'b'); //调用myfunc()函数
	myfunc(30, 'c');   //正常调用函数方法了


	/*
	* 2. 直接定义“函数指针类型”
	*/
	typedef int(*FUNC_P)(int, char);  //int myfunc(int a, char b)
	FUNC_P pFunc2 = myfunc;
	pFunc2(20, 'd'); //调用myfunc()函数

	//尽量“函数指针”不要指向同类型
	//pFunc2 = func;  //运行时报错


	/*
	* 3. 直接定义“函数指针变量”
	*/
	//把"指针"转换为"函数指针"类型写法
	int(*pFunc3)(int, char) = (int(*)(int, char))NULL;  //int myfunc(int a, char b)
	pFunc3 = myfunc;
	pFunc3(50, 'p'); //调用myfunc()函数

	printf("pFunc3 size:%d\n", sizeof(pFunc3)); //4  任何指针都是4个字节

	//假设0x001是函数地址，把它转换为“函数指针类型”，如下：
	//(int(*)(int,int)) 0x001;
}


int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
int myfunc(int a,char b) !
int myfunc(int a,char b) !
int myfunc(int a,char b) !
int myfunc(int a,char b) !
int myfunc(int a,char b) !
pFunc3 size:4
请按任意键继续. . .
*/