#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
9 类模板碰到友元函数
	9.3	友元函数“类外实现”
	9.4	friend void printPerson<>(Person<T1, T2> &p); //没有<> 普通函数; 声明加上<> 模板函数声明
	9.5	让编译器看到 函数 并且看到这个Person类型
*/


/*
* 让编译器看到 Person类 声明
* 让编译器提前看到 printPerson 声明
*/
template<class T1, class T2> class Person;
template<class T1, class T2> void printPerson(Person<T1, T2> & p);


/*
* 类模板
*/
template<class T1, class T2> //相当于“Java泛型类”指定类的泛型参数列表
class Person
{
	//1.友元函数“类外实现”利用在printPerson后加上<>空参数列表，告诉编译器这是“模板函数的声明”
	//2.还里面要让编译器看到 Person类 声明 和 printPerson 声明
	friend void printPerson<>(Person<T1, T2> & p); //普通函数 声明

private:
	T1 m_Name;
	T2 m_Age;

public:
	Person(T1 name, T2 age){
		this->m_Name = name;
		this->m_Age = age;
	}
};

/*
* 类外实现
*/
template<class T1 ,class T2> //相当于“Java泛型方法”指定类的泛型参数列表
void printPerson(Person<T1, T2> & p)
{
	cout << "姓名：" << p.m_Name << "  年龄： " << p.m_Age << endl;
}

void test01()
{
	Person<string, int> p("Tom", 10);
	printPerson(p);
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
姓名：Tom  年龄： 10
请按任意键继续. . .
*/