#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
6 构造函数的调用规则
    6.1	如果提供了有参的构造，那么系统就不会提供默认的构造了，但是会提供拷贝构造
    6.2	如果提供了拷贝构造函数，那么系统就不会提供其他的构造函数了
*/


/*
* 系统默认给一个类提供 3个函数  默认构造 、 拷贝构造 、 析构函数
*/
class MyClass
{
public:
	//MyClass()
	//{
	//	cout << "默认构造函数" << endl;
	//}

	MyClass(int a)
	{
		cout << "有参构造函数" << endl;
	}

	//MyClass(const MyClass& m)
	//{
	//}
	int m_A;

};


/*
* 1.当我们提供了“有参构造函数”，那么系统就“不会”再给我们提供默认构造函数了
* 但是 系统还会提供默认拷贝构造函数 , 进行简单的值拷贝
*/
void test01()
{
	MyClass c1(1);
	c1.m_A = 10;
	MyClass c2(c1); //调用系统“默认拷贝构造”，打印出10，证明成功调用“默认拷贝构造”
	cout << c2.m_A << endl; //10
}

/*
* 2.当我们提供了“拷贝构造”，那么系统就“不会”提供其他构造了
*/
class MyClass2
{
public:
	MyClass2()
	{
		cout << "默认构造函数" << endl;
	}

	//MyClass2(int a)
	//{
	//	cout << "有参构造函数" << endl;
	//}

	MyClass2(const MyClass& m) //拷贝构造
	{
	}

	int m_A;
};

void test02()
{
	//提供了“拷贝构造”，需要手动提供“无参构造”，否则编译器会报错。
	MyClass2 c1;
}


int main(){
	test01();
	cout << "-------------" << endl;
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
有参构造函数
10
-------------
默认构造函数
请按任意键继续. . .
*/
