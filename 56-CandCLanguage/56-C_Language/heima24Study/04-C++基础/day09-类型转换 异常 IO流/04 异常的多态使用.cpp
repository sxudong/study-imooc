#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
6 异常的多态使用
	6.1	利用多态来实现 printError 同一个接口调用
	6.2	抛出不同的错误对象，提示不同错误。
*/


/*
* 异常基类
*/
class BaseException
{
public:
	virtual void printError(){

	}
};

//派生异常
class  NullPointerException : public BaseException
{
public:
	virtual void printError(){
		cout << "空指针异常" << endl;
	}
};

//派生异常
class OutofRangeException : public BaseException
{
public:
	virtual void printError(){
		cout << "越界异常" << endl;
	}
};


void doWork1()
{
	throw NullPointerException(); //空指针异常
}

void doWork2()
{
	throw OutofRangeException();   //越界异常
}


void test01()
{
	try{
		doWork1();
	}catch (BaseException & e){ //发生多态，调服子类的异常
		e.printError();
	}
}

void test02()
{
	try {
		doWork2();
	}
	catch (BaseException & e){ //发生多态，调服子类的异常
		e.printError();
	}
}


int main(){

	test01();
	cout << "------------------" << endl;
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
空指针异常
------------------
越界异常
请按任意键继续. . .
*/