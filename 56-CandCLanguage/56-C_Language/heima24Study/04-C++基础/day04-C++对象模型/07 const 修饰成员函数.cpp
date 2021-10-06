#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
7 常函数 常对象
	7.1	常函数  void func() const {} 常函数
	7.2	常函数 修饰是this指针  const Type* const this
	7.3	常函数 不能修改this指针执行的值
	7.4	常对象 在对象前 加入 const修饰 const Person p1
	7.5	常对象 不可以调用普通的成员函数
	7.6	常对象 可以调用常函数
	7.7	用mutable修饰的关键字是在常函数可以修改的
*/


class Person
{
public :
	Person()
	{
		//构造中修改属性
		//this 永远执行本体
		//Person * const this 指针的指向不可以修改
		this->m_A = 0;
		this->m_B = 0;
	}

	/*
	* “常函数”不允许修改指针指向的值
	*/
	void showInfo() const
	{
		//this->m_A = 1000; //err 常函数 不允许修改指针指向的值
		this->m_B = 1000;   //mutable修饰的变量，“常函数”也可以修改

		// const Person * const this
		cout << "m_A = " << this->m_A << endl; //m_A = 0
		cout << "m_B = " << this->m_B << endl; //m_B = 1000
	}

	void show2()
	{
		m_A = 100;
	}

	void show3() const
	{
		//m_A = 100; //err 常函数 不允许修改指针指向的值
	}

	int m_A;
	mutable int m_B; //就算是“常函数”我还是执意要修改

};

void test01()
{

	Person p1;
	p1.showInfo();

	/*
	* “常对象”不允许修改属性
	*/
	const Person p2;
	cout << p2.m_A << endl; //0
	//p2.show2();  //常对象 不可以调用“普通成员函数”
	p2.show3();    //常对象 可以调用“常函数”
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}