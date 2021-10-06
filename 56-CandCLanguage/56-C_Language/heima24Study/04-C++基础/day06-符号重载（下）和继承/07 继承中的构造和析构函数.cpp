#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
8 继承中的构造和析构顺序
	8.1	子类创建对象时，先调用父类的构造，然后调用自身构造
	8.2	析构顺序与构造顺序相反
	8.3	子类是不会继承父类的构造函数和析构函数
	8.4	补充内容，如果父类中没有合适默认构造，那么子类可以利用初始化列表的方式
*/


class Base
{
public:
	int m_A;

	Base()
	{
		m_A = 10;
		cout << "Base默认构造函数调用" << endl;
	}

	~Base()
	{
		cout << "Base的析构函数调用" << endl;
	}
};


/*
* “子类”会继承“父类”的成员属性，成员函数。
* 但是“子类”不会继承“父类”构造函数 和 析构函数。
* 只有父类自己知道如果构造和析构自己的属性，而子类不知道。
*/
class Son : public Base
{
public:
	Son()
	{
		cout << "Son默认构造函数调用" << endl;
	}

	~Son()
	{
		cout << "Son的析构函数调用" << endl;
	}
};

void test01()
{
	//Base b1;
	Son s1;
}
/* Output:
Base默认构造函数调用
Son默认构造函数调用
Son的析构函数调用
Base的析构函数调用
*/


class Base2
{
public:
	int m_A;

	Base2(int a)
	{
		this->m_A = a;
		cout << "Base2有参构造函数调用 "<< this->m_A << endl;
	}
};

class Son2 : public Base2
{
public:
	/*
	* 利用“初始化列表方式”显示调用 有参构造
	* 类似Java的Super()调用父类构造
	*/
	Son2(int a ) : Base2(a)
	{
		cout << "Son2有参构造函数调用 "<< this->m_A << endl;
	}
};

void test02()
{
	Son2 s2(1000);
}
/* Output:
Base2有参构造函数调用 1000
Son2有参构造函数调用 1000
*/

int main(){

	//test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}