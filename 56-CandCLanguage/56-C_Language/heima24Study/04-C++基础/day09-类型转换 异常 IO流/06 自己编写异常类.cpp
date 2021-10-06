#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>


/*
8 编写自己的异常类
	8.1	自己的异常类 需要继承于 exception
	8.2	重写  虚析构   what（）
	8.3	内部维护以错误信息 字符串
	8.4	构造时候传入 错误信息字符串，what返回这个字符串
	8.5	string 转“char *”加“.c_str()”
*/


/*
* 自己编写的异常类
*
* exception 系统提供的“异常基类”，最祖宗的类。
* 如果要知道重写哪些方法？右键“转到定义”找到 virtual 虚函数重写。
*/
class MyOutOfRangeException : public exception //
{

public:
	string m_ErrorInfo;

	MyOutOfRangeException(string errorInfo){
		this->m_ErrorInfo = errorInfo;
	}

	//重写析构函数
	virtual ~MyOutOfRangeException( ){

	}
	//重写what()函数
	virtual const char *  what() const{
		//返回 错误信息
		//string 转“char *”加“.c_str()”
		return this->m_ErrorInfo.c_str();
	}
};

class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;
		//年龄做检测
		if (age < 0 || age > 200)
			throw MyOutOfRangeException( string("我自己的年龄越界异常"));
	}
};

void test01()
{
	try{
		Person p("张三", 300);
	}catch ( MyOutOfRangeException & e ){
		cout << e.what() << endl; //打印错误信息
	}
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
我自己的年龄越界异常
请按任意键继续. . .
*/