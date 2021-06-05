#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
8 常量引用
    8.1	使用场景 修饰形参为只读
    8.2	const int &a = 10;会分配内存
*/


void test01()
{
	//int &ref = 10; //err 引用了不合法的内存，不可以
	const int &ref = 10; //加入const后 ，编译器处理方式为： int tmp = 10; const int &ref = tmp;

	//ref = 10; //err

	//绕过编译器检查去修改它
	int * p = (int*) &ref;
	*p = 1000;

	cout << "ref = " << ref << endl; //ref = 1000

}

/*
* 常量引用使用场景 用来修饰形参
*/
void showValue(const int &val)
{
	//val += 1000; //如果只是想显示内容，而不修改内容，那么就用const修饰这个形参
	cout << "val = " << val << endl; //val = 10
}

void test02()
{
	int a = 10;
	showValue(a);
}

int main(){
	test01();
	test02();
	system("pause");
	return EXIT_SUCCESS;
}