#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
9 类模板碰到友元函数
	9.1	友元函数“类内实现”
	9.2	friend void printPerson(Person<T1, T2> &p)
*/


/*
* 类模板
*/
template<class T1 ,class T2>  //相当于“Java泛型类”指定类的泛型参数列表
class Person
{
	/*
	* 友元函数类内实现（默认是全局函数）
	*/
	friend void printPerson( Person<T1 ,T2> & p ){
		cout << "姓名：" << p.m_Name << "  年龄： " << p.m_Age << endl;
	}

private:
	T1 m_Name;
	T2 m_Age;

public:
	Person(T1 name, T2 age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}

	//void printPerson() {
	//	cout << "姓名：" << this->m_Name << "  年龄： " << this->m_Age << endl;
	//}
};

void test01()
{
	Person<string, int> p("Tom", 10);
	//p.printPerson();
	printPerson(p); //全局函数直接访问它的姓名和年龄
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