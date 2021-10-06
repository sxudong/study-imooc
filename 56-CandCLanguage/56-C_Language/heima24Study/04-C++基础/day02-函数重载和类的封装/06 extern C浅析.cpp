#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "test.h"

/*
6 extern C浅析
    6.1	解决了C++文件中调用C语言的代码
    6.2	ifdef __cplusplus extern “C” {
    6.3	}
*/


/*
* C++中想调用C语言方法
*/
//解决方法一：
//extern "C" void show();  //show方法 按照C语言方式做连接

//解决方法二：
//在test.h头文件中加上“条件编译”#ifdef __cplusplus

/*
* 解决的问题就是 在C++中调用C语言的函数
*/
int main(){

	//在C++中,函数是可以发生重载的，编译器会把这个函数名称偷偷改变  _showv  void
	show(); //hello world

	system("pause");
	return EXIT_SUCCESS;
}