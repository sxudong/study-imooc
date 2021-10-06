#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 异常变量生命周期
	5.1	如果 MyException e，会多开销一份数据, 调用拷贝构造
	5.2	如果 MyExcepiton * e， 不 new提前释放对象 new 自己管理delete
	5.3	推荐 MyException & e  容易写，而且就一份数据。
*/


/*
* 自定义异常类
*/
class MyException
{
public:
	int m_A;

	MyException(){
		cout << "MyException的默认构造" << endl;
	}

	MyException(const MyException & e){
		cout << "MyException的拷贝构造" << endl;
	}

	~MyException(){
		cout << "MyException的析构调用" << endl;
	}

	void printError(){
		this->m_A = 100;
		cout << "error"  << m_A<< endl;
	}
};

void doWork1()
{
	throw MyException();
}

void doWork2()
{
	throw & MyException();
}

void doWork3()
{
	throw new MyException();
}


void test01()
{
	try{
		doWork1();
    }catch (MyException e){ //拷贝构造，MyException e，会多开销一份数据
		cout << "捕获异常" << endl;
	}
}
/* Output:
MyException的默认构造
MyException的拷贝构造
捕获异常
MyException的析构调用
MyException的析构调用
*/


/*
* 推荐引用
*/
void test02()
{
	try {
		doWork1();
	}catch (MyException & e){ //提高效率
		cout << "捕获异常" << endl;
	}
}
/* Output:
MyException的默认构造
捕获异常
MyException的析构调用
*/

void test03()
{
	try {
		doWork2();
	}catch (MyException * e) {
		//e->printError(); //用不了了，e已经被提前干掉了
		//e->printError();
		//e->printError(); //结果是正确的，指向非法内存空间，不应该这么做

		cout << "捕获异常" << endl;
	}
}
/* Output:
MyException的默认构造
MyException的析构调用
捕获异常
*/


void test04()
{
	try {
		doWork3();
	}catch (MyException * e) {
		cout << "捕获异常" << endl;
		delete e; //靠自觉 释放对象
	}
}
/* 需要手动“delete”释放，才会调用“析构函数”了。
MyException的默认构造
捕获异常
MyException的析构调用
*/


int main(){
	test01();
	cout << "------------------" << endl;
	test02();
	cout << "------------------" << endl;
	test03();
	cout << "------------------" << endl;
	test04();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
MyException的默认构造
MyException的拷贝构造
捕获异常
MyException的析构调用
MyException的析构调用
------------------
MyException的默认构造
捕获异常
MyException的析构调用
------------------
MyException的默认构造
MyException的析构调用
捕获异常
------------------
MyException的默认构造
捕获异常
MyException的析构调用
请按任意键继续. . .
*/