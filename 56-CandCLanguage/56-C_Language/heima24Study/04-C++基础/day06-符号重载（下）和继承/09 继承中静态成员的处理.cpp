#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
10 继承中静态成员的处理
	10.1 类似非静态成员函数处理
	10.2 如果想访问父类中的成员，加作用域即可
*/


class Base
{
public:
	static int m_A;

	static void func()
	{
		cout << "base fun()" << endl;
	}

	static void func(int a)
	{
		cout << "base fun(int)" << endl;
	}
};
int Base::m_A = 10;


class Son : public Base
{
public:
	static int m_A;

	static void func()
	{
		cout << "son fun()" << endl;
	}
};
int Son::m_A = 20;


/*
* 静态成员属性，子类可以继承下来
*/
void test01()
{
	cout << Son::m_A << endl;
	//访问父类的m_A
	cout << Base::m_A << endl;

	Son::func();
	//访问 父类中同名的函数
	Son::Base::func();
	Son::Base::func(10);
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
10
son fun()
base fun()
base fun(int)
请按任意键继续. . .
*/