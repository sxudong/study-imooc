#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
5 类模板做函数的参数
	5.1	三种方式
		5.1.1 显示指定类型
		5.1.2 参数模板化
		5.1.3 整体模板化
	5.2	查看类型名称
		5.2.1 cout << typeid(T).name() << endl;
*/


/*
* 类模板
*/
template <class NameType, class AgeType = int> //类模板可以有默认类型（类似Java的泛型类）
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

/*
* 1 指定传入类型
*/
void doWork(Person<string ,int> & p )
{
	p.showPerson();
}

void test01()
{
	Person<string, int> p("MT",10);
	doWork(p);
}

/*
* 2 参数模板化
*   把Person里的两个参数进行了模板化。
*/
template<class T1 ,class T2>
void doWork2(Person<T1, T2> & p)
{
	//如何查看类型？可以typeid打印出来。
	cout << typeid(T1).name() << endl;
	cout << typeid(T2).name() << endl;
	p.showPerson();
}

void test02()
{
	Person <string, int> p("呆贼", 18);

	doWork2(p);
}


/*
* 3 整体模板化
*   把整个Person对象进行了模板化。
*/
template<class T>
void doWork3(T & p)
{
	cout << typeid(T).name() << endl;
	p.showPerson();
}

void test03()
{
	Person <string, int> p("劣人", 18);

	doWork3(p);
}



int main(){

	test01();
	cout << "--------------------" << endl;
	test02();
	cout << "--------------------" << endl;
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/*
姓名：MT 年龄： 10
--------------------
class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > int
姓名：呆贼 年龄： 18
--------------------
class Person<class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> >,int>
姓名：劣人 年龄： 18
请按任意键继续. . .
*/