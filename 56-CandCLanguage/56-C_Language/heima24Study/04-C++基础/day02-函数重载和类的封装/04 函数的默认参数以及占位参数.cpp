#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
3 函数默认参数
    3.1	参数可以有默认值
    3.2	如果有一个位置有了默认值，那么从这个位置开始，从左往右都必须有默认值
    3.3	函数声明和实现 只能有一个有默认值

4 函数占位参数
    4.1	void func(int) 占位参数 调用时候必须要提供这个参数
    4.2	占位参数也可以有默认值
    4.3	c语言中没有默认参数 和占位参数
*/


/*
* 函数的“默认参数”，参数后面 = ...
* 函数参数注意事项，如果有一个位置有了默认参数，那么从这个位置开始，从左往后都必须有默认参数
* 传入参数 ，如果有参数，就用传入的参数，没有参数就用“默认值”。
*/


/*
* 如果函数声明里面有了“默认参数”，那么函数实现时候必须“没有”。
* 函数声明和实现里 只能有一个里有默认参数，不要同时都出现默认参数
*/
void myFunc(int a = 10, int b = 10); //函数声明
void myFunc(int a , int b ){         //实现

}

void func( int a, int b = 10, int c = 1 )
{
	cout << "a + b + c = " << a + b + c << endl;
}

void test01()
{
	//func();

	func(1,2); //a + b + c = 4

}



/*
* 函数——占位参数
*
*/
void func2(int a , int) //占位参数 没有什么大用途，只有后面重载 ++符号才有一点点用
{

}
void func3(int a, int = 1) //占位参数 可以有默认值
{

}

void test02()
{
	func2(10,1); //如果有了占位参数，函数调用时候必须要提供这个参数 ,但是用不到参数
	func3(10);
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}