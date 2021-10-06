#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
2 函数调用运算符重载
	2.1	()仿函数  对象() 看似像函数调用
	2.2	MyAdd()匿名对象
*/


/*
* ()重载
*/
class MyPrint
{
public:
	//()运算符重载
	void operator() (string text)
	{
		cout << text << endl;
	}
};

void test01()
{
	MyPrint myPrint;
	//仿函数（它不是一个函数，但是它的形为类似函数，它是一个类，所以它叫“仿函数”）
	myPrint("hello world1111"); // hello world1111
}


class MyAdd
{
public:
	//()运算符重载
	int operator() (int v1,int v2)
	{
		return v1 + v2;
	}
};

void test02()
{
	MyAdd myAdd;
	cout << myAdd(1, 1) << endl;   //2

	//匿名对象
	cout << MyAdd()(1, 1) << endl; //2
}



int main(){

	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
hello world1111
2
2
请按任意键继续. . .
*/