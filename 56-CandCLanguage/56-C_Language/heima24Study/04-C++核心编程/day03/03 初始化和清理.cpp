#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
3 对象的初始化和清理
    3.1	构造函数
        3.1.1 没有返回值 没有void，类名相同，可以发生重载，可以有参数
    3.2	析构函数
        3.2.1 没有返回，没有void ，函数名称： ~类名，不可以发生重载，不可以有参数
    3.3	系统会默认调用 构造函数和析构函数，而且只会调用一次
    3.4	如果程序员没有提供构造和析构，系统会默认提供，空实现
*/


class Person
{
public:

	/*
	* 构造函数写法
	* 与类名相同，没有返回值 ，不写void，可以发生重载 （可以有参数）
	* 构造函数由编译器自动调用，而不是手动，而且只会调用一次
	*/
	Person()
	{
		cout << "构造函数调用" << endl;
	}

	Person(int a)
	{
		cout << "构造函数调用(int a)" << endl;
	}


	/*
	* 析构函数写法
	* 与类名相同 类名前面加一个符号 “~” ,也没有返回值 ，不写void， 不可以有参数（不能发生重载）
	* 自动调用，只会调用一次。
	*
	* 作用：析构函数主要用于“对象销毁前”系统自动调用，执行一些清理工作。
	*/
	~Person()
	{
		cout << "析构函数调用" << endl;
	}

};


void test01()
{
	Person p1(1); //默认调用了构造和析构，是系统提供的两个空实现的函数
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
构造函数调用(int a)
析构函数调用
请按任意键继续. . .
*/