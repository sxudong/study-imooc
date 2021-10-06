#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
2 左移运算符重载
	2.1	不要随意乱用符号重载
	2.2	内置数据类型 的运算符不可以重载
	2.3	cout << 直接对Person自定义数据类型 -> 进行输出
	2.4	写到全局函数中 ostream & operator<< (ostream & cout, Person & p1) {}
	2.5	如果重载时候想访问 p1的私有成员，那么全局函数要做Person的“友元函数”
*/


class Person
{
	/*
	* “全局函数”变为我的好朋友 —— 友元函数
	*/
	friend ostream & operator << (ostream & cout, Person & p1);

public:
	Person(){}
	Person(int a, int b)
	{
		this->m_A = a;
		this->m_B = b;
	}

	/*
	//“重载左移运算符”不可以写到成员函数中
	void operator<<()
	{

	}
	*/

private:
	int m_A;
	int m_B;
};


//左移重载函数
//第一个参数 cout  第二个参数  p1
ostream & operator<< (ostream & cout , Person & p1 )
{
	//访问 p1 的私有成员，全局函数要做Person的“友元函数”
	cout << "m_A = " << p1.m_A << " m_B = " << p1.m_B;

	return cout;
}


void test01()
{
	Person p1(10, 10);

	cout << p1 << "helloworld" <<endl;
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
m_A = 10 m_B = 10helloworld
请按任意键继续. . .
*/