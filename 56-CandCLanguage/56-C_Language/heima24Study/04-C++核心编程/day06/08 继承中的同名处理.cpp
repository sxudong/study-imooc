#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
9 继承中的同名处理
	9.1	成员属性 直接调用先调用子类，如果想调用父类，需要作用域。
	9.2	成员函数 直接调用先调用子类，父类的所有版本都会“被隐藏”，除非显示用作用域运算符去调用
*/


class Base
{
public:
	int m_A;

	Base()
	{
		m_A = 100;
	}

	void fun()
	{
		cout << "Base func调用" << endl;
	}

	void fun(int a)
	{
		cout << "Base func (int a)调用" << endl;
	}
};

class Son : public Base
{
public:
	int m_A;

	Son()
	{
		m_A = 200;
	}

	void fun()
	{
		cout << "Son func调用" << endl;
	}
};

void test01()
{
	Son s1;
	cout << s1.m_A << endl; //200

	/*
	* 想调用 父类中 的m_A
	* 加作用域（父类名称）
	*/
	cout << s1.Base::m_A << endl; //100

	s1.fun(); //Son func调用

	//调用父类的func
	s1.Base::fun(10); //Base func (int a)调用

}


/*
* 结论：
* 如果子类和父类拥有同名的“函数”和“属性”，子类会覆盖父类的成员吗？不会。
* 如果子类与父类的“成员函数名称”相同，子类会把父类的所有的同名版本都“隐藏”掉。
* 想调用父类的方法，必须加“作用域”。
*/
int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
200
100
Son func调用
Base func (int a)调用
请按任意键继续. . .
*/