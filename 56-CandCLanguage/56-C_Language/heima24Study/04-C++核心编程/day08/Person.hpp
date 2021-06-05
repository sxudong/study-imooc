#pragma  once 
#include <iostream>
#include <string>
using namespace std;


/*
* 类模板
*/
template<class T1 ,class T2> //相当于“Java泛型类”指定类的泛型参数列表
class Person
{
public:
	T1 m_Name;
	T2 m_Age;

	Person(T1 name,T2 age); //类外实现

	void showPerson();      //类外实现
};


/*
* “类外实现”成员函数（Person类构造函数）
*/
template<class T1, class T2> //相当于“Java泛型方法”指定类的泛型参数列表
Person<T1, T2>::Person(T1 name, T2  age)
{
	this->m_Name = name;
	this->m_Age = age;
}


template <class T1, class T2> //相当于“Java泛型方法”指定类的泛型参数列表
void Person<T1, T2>::showPerson()
{
	cout << "姓名：" << this->m_Name << "  年龄：  " << this->m_Age << endl;
}
