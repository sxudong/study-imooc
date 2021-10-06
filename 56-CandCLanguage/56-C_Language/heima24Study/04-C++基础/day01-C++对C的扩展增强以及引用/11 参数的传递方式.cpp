#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
6.2	参数3种传递方式
    6.2.1 值传递
    6.2.2 地址传递
    6.2.3 引用传递
*/


/*
* 值传递
*/
void mySwap(int a, int b)
{
	int tmp = a;
	a = b;
	b = tmp;

	cout << "mySwap::a = " << a << endl; //mySwap::a = 20
	cout << "mySwap::b = " << b << endl; //mySwap::b = 10
}

void test01()
{
	int a = 10;
	int b = 20;
	mySwap(a, b); //值传递

	cout << "a = " << a << endl; //a = 10
	cout << "b = " << b << endl; //b = 20
}


/*
* 地址传递
*/
void mySwap2(int * a, int * b)
{
	int tmp = *a;
	*a = *b;
	*b = tmp;
}


void test02()
{
	int a = 10;
	int b = 20;
	mySwap2(&a, &b);

	cout << "a = " << a << endl; //a = 20
	cout << "b = " << b << endl; //b = 10
}


/*
* 引用传递 类似传地址
*/
void mySwap3(int &a, int &b)  //&a = a &b = b
{
	int tmp = a;
	a = b;
	b = tmp;
}


void test03()
{
	int a = 10;
	int b = 20;
	mySwap3(a, b);

	cout << "a = " << a << endl; //a = 20
	cout << "b = " << b << endl; //b = 10
}


/*
* 引用的注意事项
*   1、 引用必须引一块合法的内存空间
*   2、不要返回局部变量的引用
*/
int& doWork()
{
	int a = 10; //局部变量
	return a;   //返回局部变量引用
}


void test04()
{
	//int &a = 10; //err 引用必须引一块合法的内存空间

	int &ret = doWork();
	cout << "ret = " << ret << endl; //10  第一次10是编译器做了优化
	cout << "ret = " << ret << endl; //ret = 254642568
	cout << "ret = " << ret << endl; //ret = 254642568
	cout << "ret = " << ret << endl; //ret = 254642568
	cout << "ret = " << ret << endl; //ret = 254642568
}


int& doWork2()
{
	static int a = 10; //静态变量
	return a;          //返回引用
}

void test05()
{

	int &ret = doWork2();
	cout << "ret = " << ret << endl; //ret = 10
	cout << "ret = " << ret << endl; //ret = 10

	/*
	* 如果函数的返回值是“引用”，那么这个函数调用可以作为“左值”
	*/
	doWork2() = 1000; //相当于写了 a = 1000;
	cout << "ret = " << ret << endl;
}

int main(){

	test01();
	cout << "--------------" << endl;
	test02();
	cout << "--------------" << endl;
	test03();
	cout << "--------------" << endl;
	test04();
	cout << "--------------" << endl;
	test05();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
mySwap::a = 20
mySwap::b = 10
a = 10
b = 20
--------------
a = 20
b = 10
--------------
a = 20
b = 10
--------------
ret = 10
ret = 254642568
ret = 254642568
ret = 254642568
ret = 254642568
--------------
ret = 1000
请按任意键继续. . .
*/