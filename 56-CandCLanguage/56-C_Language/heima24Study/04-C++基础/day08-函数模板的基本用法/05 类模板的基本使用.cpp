#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
4 类模板
	4.1	写法template <T…> 紧跟着是类
	4.2	与函数模板区别，可以有默认类型参数
	4.3	函数模板可以进行自动类型推导，而类模板不可以
	4.4	类模板中的成员函数 一开始不会创建出来，而是在运行时才去创建
*/


/*
* 类模板
*/
template <class NameType, class AgeType = int> //类模板可以有“默认类型”（类似Java泛型类的泛型参数列表）
class Person
{
public:
	NameType m_Name;
	AgeType m_Age;

	Person(NameType name, AgeType age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}

	void showPerson()
	{
		cout << "姓名：" << this->m_Name << " 年龄： " << this->m_Age << endl;
	}
};


void test01()
{
	//“类模板”不支持“自动类型推导”
	//Person p("孙悟空", 100); //err

	//显示指定类型
	Person<string, int> p("孙悟空", 100);
	p.showPerson();
}


class Person1
{
public:
	void showPerson1()
	{
		cout << "Person1的调用" << endl;
	}
};

class Person2
{
public:
	void showPerson2()
	{
		cout << "Person2的调用" << endl;
	}
};



template<class T> //模板类（类似Java的泛型类）
class myClass
{
public:
	T obj;
	void func1()
	{
		obj.showPerson1();
	}
	void func2()
	{
		obj.showPerson2();
	}
};

/*
* 结论：“类模板”中成员函数 一开始不会创建出来，而是在运行时才去创建
*/
void test02()
{
	myClass<Person1> m;

	m.func1();

	//m.func2(); //Person1没有func2()方法
}


int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
姓名：孙悟空 年龄： 100
----------------
Person1的调用
请按任意键继续. . .
*/