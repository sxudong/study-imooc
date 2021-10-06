#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
7 深拷贝与浅拷贝
    7.1	系统默认提供的拷贝构造 会进行简单的值拷贝
    7.2	如果属性里有指向堆区空间的数据，那么简单的浅拷贝会导致重复释放内存的异常
    7.3	解决上述问题，需要我们自己提供拷贝构造函数，进行深拷贝
*/


class Person
{
public:

	Person(){

	}

	//初始化属性
	Person(char * name,int age)
	{
		m_Name = (char*)malloc(strlen(name) + 1);
		strcpy(m_Name, name);

		m_age = age;
	}

	/*
	* 拷贝构造
	* 系统会提供“默认拷贝构造”，而且是简单的值拷贝——浅拷贝
	* 这里使用“默认拷贝构造”会导致挂掉。
	*
	* 原因：简单的浅拷贝会释放堆区空间“两次”，导致挂掉。
	*
	* 解决办法：深拷贝，自己提供拷贝构造。
	*/
	Person(const Person &p)
	{
		//深拷贝
		m_age = p.m_age;
		m_Name = (char*) malloc(strlen(p.m_Name) + 1); //开辟堆空间
		strcpy(m_Name, p.m_Name);
	}

	//如果直接调用析构函数，会把对象给释放了。但 p.m_Name 是开辟在堆上的，需要在析构中释放
	~Person()
	{
		cout << "析构函数调用" << endl;
		if (m_Name!=NULL)
		{
			free(m_Name);  //释放堆空间
			m_Name = NULL; //指针指向空指针
		}
	}

	//姓名
	char * m_Name;
	//年龄
	int m_age;
};


void test01()
{
	Person p1("敌法",10);
	Person p2(p1); //调用拷贝构造
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
析构函数调用
析构函数调用
请按任意键继续. . .
*/