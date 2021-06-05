#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
6 空指针访问成员函数
	6.1	如果成员函数没有用到this，那么空指针可以直接访问
	6.2	如果成员函数用的this指针，就要注意，可以加if判断，如果this为NULL就return
*/


class Person
{
public:

	void show()
	{
		cout << "Person show" << endl;
	}

	void showAge() //void showAge(Person * this)
	{
		//防止空指针去访问成员变量，否则程序会挂掉
		if (this == NULL)
			return;

		cout << this->m_Age << endl; // NULL -> m_Age
	}

	int m_Age;
};

void test01()
{
	Person * p = NULL;
	p->show();    //Person show
	p->showAge(); //this == NULL 返回了，没有打印。
}

int main(){
	test01();

	system("pause");
	return EXIT_SUCCESS;
}