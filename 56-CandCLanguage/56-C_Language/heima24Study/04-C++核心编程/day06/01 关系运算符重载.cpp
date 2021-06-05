#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
1 关系运算符重载
	1.1	自定义数据类型 不会内部做 比较 == ！ =
	1.2	所以要重载 == ！ =
*/


/*
*  == 关系运算符重载
*/
class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}

	bool operator== ( Person & p){
		//比较对象的名字和年龄
		if (this->m_Name == p.m_Name && this->m_Age == p.m_Age)
			return true;

		return false;
	}

	bool operator!= ( Person & p){
		//比较对象的名字和年龄
		if (this->m_Name == p.m_Name && this->m_Age == p.m_Age)
			return false;

		return true;
	}
};

void test01()
{
	Person p1("小明", 10);
	Person p2("小强", 15);
	Person p3("小强", 15);

	//系统自带的==关系运算符
	//int a = 10;
	//int b = 10;
	//if (a == b ){
	//	cout << "a b相等" << endl;
	//}

	//调用自定义 == 重载函数
	if ( p1 == p2)
		cout << "p1 和 p2 相等" << endl;
	else
		cout << "p1 和 p2 不相等" << endl;

	if (p2 == p3)
		cout << "p2 和 p3 相等" << endl;
	else
		cout << "p2 和 p3 不相等" << endl;

	//调用自定义 != 重载函数
	if (p1 != p2)
		cout << "p1 和 p2 不相等" << endl;
	else
		cout << "p1 和 p2 相等" << endl;
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1 和 p2 不相等
p2 和 p3 相等
p1 和 p2 不相等
请按任意键继续. . .
*/