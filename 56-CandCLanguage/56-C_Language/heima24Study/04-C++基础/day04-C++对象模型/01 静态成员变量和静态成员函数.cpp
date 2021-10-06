#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
1 静态成员变量和静态成员函数
	1.1	静态成员变量
		1.1.1 编译阶段分配内存
		1.1.2 所有对象共享数据
		1.1.3 通过对象访问、通过类名访问
		1.1.4 有权限控制
		1.1.5 类内声明 类外初始化

	1.2	静态成员函数
		1.2.1 可以访问静态成员变量，不可以方法普通成员变量
		1.2.2 普通成员函数 都可以访问
		1.2.3 静态成员函数也有权限
		1.2.4 可以通过对象访问，也可以通过类名进行访问
*/


class Person
{
public:
	Person()
	{
		//m_Age = 10; //Person::m_Age不会调用构造函数，所以不建在“类内部"初始化静态数据。
	}

	/*
	* 加入static就是“静态成员变量”，会共享数据
	* 静态成员变量，在“类内”声明，“类外”进行初始化
	*
	*/
	static int m_Age;

	int m_A; //“静态成员变量”也是有权限的

	/*
	* 静态成员函数
	*/
	static void func()
	{
		//m_A = 10;  //不可以访问“普通成员变量”
		m_Age = 100; //可以访问“静态成员变量”
		cout << "func调用 m_Age = " << m_Age << endl;
	};

	/*
	* 普通成员函数
	*/
	void myFunc()
	{
		m_A = 100;   //可以访问“普通成员变量”
		m_Age = 100; //也可以访问“静态成员变量”
	}

private:
	static int m_other; //私有权限 在类外不能访问

	static void func2()
	{
		cout << "func2调用" << endl;
	}
};

//类外初始化，初始化时不加static
int  Person::m_Age = 0;
int  Person::m_other = 10;

void test01()
{
	//1 通过对象访问属性
	Person p1;
	p1.m_Age = 10;

	Person p2;
	p2.m_Age = 20;

	cout << "p1 = " << p1.m_Age << endl; //10 或者 20？ 20
	cout << "p2 = " << p2.m_Age << endl; //20
	//共享数据

	//2 通过类名访问属性
	cout << "通过类名访问Age：" << Person::m_Age << endl; //通过类名访问Age：20
	//cout << "other = " << Person::m_other << endl; //error 私有权限在类外无法访问

	//静态成员函数调用
	p1.func();
	p2.func();
	Person::func();

	//“静态成员函数”也是有权限的
	//Person::func2(); //error

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1 = 20
p2 = 20
通过类名访问Age：20
func调用 m_Age = 100
func调用 m_Age = 100
func调用 m_Age = 100
请按任意键继续. . .
*/