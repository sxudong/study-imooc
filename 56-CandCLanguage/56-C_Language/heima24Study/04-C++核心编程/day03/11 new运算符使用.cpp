#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
* 4.3.6 动态对象创建
*/

class Person
{
public:
	Person()
	{
		cout << "默认构造调用" << endl;
	}

	Person(int a)
	{
		cout << "有参构造调用" << endl;
	}

	~Person()
	{
		cout << "析构函数调用" << endl;
	}

};


void test01()
{
	//Person p1;  //栈区开辟

	/*
	* 所有“new”出来的对象，都会返回该类型的指针
	* malloc 返回 void* 还要强转
	* malloc 会调用构造吗？ 不会。new 会调用构造函数。
	* new 运算符  malloc 函数
	*/
	Person * p2 = new Person; //堆区开辟，会调用构造函数
	/*
		Person* p2 = new Person;
		//相当于:
		Person* p2 = (Person*) malloc(sizeof(Person));
		if (p2 == NULL) {
			return 0;
		}
		p2->Init();
	*/


	/*
	* 释放 堆区空间
	* “delete”也是运算符，配合“new”用，malloc 配合 free用。
	*/
	delete p2;

}

void test02()
{
	//当用“void*”接收“new”出来的指针，会出现释放的问题
	void *p = new Person(10);

	//无法释放p，所以避免这种写法
	delete p;
}

void test03()
{
	//通过“new”开辟数组，一定会调用“默认构造函数”,所以一定要“提供默认构造函数”。
	Person * pArray = new Person[10];

	//在栈上开辟数组，可以指定有参构造
	//Person pArray2[2] = { Person(1), Person(2) };

	//释放数组 delete []，不加“中括号”会挂掉。
	//数组会记录一个“数组大小记录”，如果加了[]，编译器会去找有几个数组对象，并释放。
	//不同的编译器会做不同的处理，QT它可能不会奔，它也不给你释放掉，它只给你释放一个，剩下9个怎么办？内存泄露了呗。
	//VS至少知道自己是怎么挂的？
	delete [] pArray;
}

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
默认构造调用
析构函数调用
-------------
有参构造调用     //没有调用“析构函数”释放
-------------
默认构造调用
默认构造调用
默认构造调用
默认构造调用
默认构造调用
默认构造调用
默认构造调用
默认构造调用
默认构造调用
默认构造调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
析构函数调用
请按任意键继续. . .
*/