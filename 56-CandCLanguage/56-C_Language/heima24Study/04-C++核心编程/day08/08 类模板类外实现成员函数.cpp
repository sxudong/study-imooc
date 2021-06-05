#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>


/*
7 类模板的“类外实现"成员函数
	template < class T1, class T2>
	7.1	Person<T1, T2>::Person(T1 name, T2 age)
*/


/*
* 类模板
*/
template<class T1 ,class T2> //相当于“Java泛型类”指定类的泛型参数列表
class Person
{
public:
	T1 m_Name;
	T2 m_Age;

	Person(T1 name, T2  age); //类外实现
	void showPerson();        //类外实现
};

/*
* “类外实现”成员函数（Person类构造函数）
*/
template <class T1, class T2> //相当于“Java泛型方法”指定类的泛型参数列表
Person<T1, T2>::Person(T1 name, T2 age)
{
	this->m_Name = name;
	this->m_Age = age;
}

template <class T1, class T2> //相当于“Java泛型方法”指定类的泛型参数列
void Person<T1, T2>::showPerson()
{
	cout << "姓名：" << this->m_Name << "  年龄：  " << this->m_Age << endl;
}

void test01()
{
	Person <string ,int> p1("Mt", 100);
	p1.showPerson();
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
姓名：Mt  年龄：  100
请按任意键继续. . .
*/