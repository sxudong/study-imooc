#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

class Person
{
public:
	Person()
	{
		cout << "默认构造函数调用" << endl;
	}

	Person(int a)
	{
		cout << "有参构造函数调用" << endl;
	}

	Person(const Person & p )
	{
		m_Age = p.m_Age;
		cout << "拷贝构造函数调用" << endl;
	}

	~Person()
	{
		cout << "析构函数调用" << endl;
	}

	int m_Age;

};


/*
* 拷贝构造调用的时机
*/
//1、用“已经创建好的对象”来“初始化新的对象”
void test01()
{
	Person p1;     //默认构造函数调用
	p1.m_Age = 10;

	Person p2(p1); //拷贝构造函数调用
}


//2、以“值传递”的方式给“函数参数”传值
void doWork(Person p1) // Person p1 = Person(p) //拷贝构造函数调用
{

}

void test02()
{
	Person p;     //默认构造函数调用
	p.m_Age = 10;

	doWork(p);
}


//3、以值方式返回局部对象
Person doWork2()
{
	Person p1;  //默认构造函数调用
	return p1;  //拷贝构造函数调用
}

void test03()
{
	Person p = doWork2();
}

//test03()在Release发布模式下，好的编译器会给我们优化，优化成什么样？
//在Debug模式下还是原来的4个数据。
/*
    Person p; 不调用默认构造
	doWork2(p);

	void doWork2(Person & p)
	{
		Person p1 //调用默认构造
	}

	优化后输出:
	默认构造函数调用
    析构函数调用
*/


int main(){

	test01();
	cout << "-------------" << endl;
	test02();
	cout << "-------------" << endl;
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
默认构造函数调用
拷贝构造函数调用
析构函数调用
析构函数调用
-------------
默认构造函数调用
拷贝构造函数调用
析构函数调用
析构函数调用
-------------
默认构造函数调用
拷贝构造函数调用
析构函数调用
析构函数调用
请按任意键继续. . .
*/