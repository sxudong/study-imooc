#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
11 多继承的概念以及问题
	11.1 class A : public B1, public B2, ….
	11.2 引发二义性问题
	11.3 想解决二义性问题，就需要通过作用域来进行区分
*/


class Base1
{
public:
	int m_A;

	Base1()
	{
		m_A = 10;
	}
};


class Base2
{
public:
	int m_A;

	Base2()
	{
		m_A = 20;
	}
};


/*
* 多继承
*/
class Son : public Base1, public Base2
{
public:
	int m_C;
	int m_D;
};


/*
* 多继承中很容易引发“二义性”
*/
void test01()
{
	cout << sizeof(Son) << endl; //16

	Son s1;
	//s1.m_A; //err 二义性

	//现在“二义性”怎么办？显示的加“域名”访问
	cout << s1.Base1::m_A << endl; //10
	cout << s1.Base2::m_A << endl; //20
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
16
10
20
请按任意键继续. . .
*/