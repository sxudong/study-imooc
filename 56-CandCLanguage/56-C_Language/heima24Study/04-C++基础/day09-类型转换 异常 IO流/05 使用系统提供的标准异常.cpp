#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
* 系统提供标准异常 要包含头文件
*/
#include <stdexcept>


/* 3.3 C++标准异常库
7 使用系统标准异常
	7.1	#incldue < stdexcept>
	7.2	throw out_of_range（”aaa”） 。。。
	7.3	catch (out_of_range& e)  cout << e.what();
*/


class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;

		//年龄做检测
		if (age < 0 || age > 200) {
			//抛出越界异常
			throw out_of_range("年龄越界了！");
		}

		//名字长度检测
		if (name.length() > 4) {
			throw length_error("长度越界");
		}
	}
};

void test01()
{
	try{
		Person p("张三",300);
	}
	catch (out_of_range & e){  //超出有效范围异常
		cout << e.what() << endl;
	}
	catch (length_error & e){  //超出该类型最大长度的
		cout << e.what() << endl;
	}
}

void test02()
{
	try {
		Person p("张三峰", 80);
	}
	catch (out_of_range & e){  //超出有效范围异常
		cout << e.what() << endl;
	}
	catch (length_error & e){  //超出该类型最大长度的
		cout << e.what() << endl;
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
年龄越界了！
------------------
长度越界
请按任意键继续. . .
*/