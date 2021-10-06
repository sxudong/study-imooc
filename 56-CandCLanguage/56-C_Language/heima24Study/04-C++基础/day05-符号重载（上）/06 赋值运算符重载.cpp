#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 =等号 赋值运算符重载
	5.1	系统默认给类提供 赋值运算符写法 是简单值拷贝
	5.2	导致如果类中有指向堆区的指针，就可能出现“深浅拷贝”的问题
	5.3	所以要重载 = 运算符
	5.4	如果想链式编程 return*this
*/


//一个类默认创建 默认构造、析构、拷贝构造 operator=赋值运算符 进行简单的值传递
class Person
{
public:

	Person(int a)
	{
		this->m_A = a;
	}

	int m_A;
};

void test01()
{
	Person p1(10);

	Person p2(0);

	p2 = p1; //赋值（调用系统默认的赋值运算）

	cout << "p2 的m_A" << p2.m_A <<endl;
}


class Person2
{
public:

	char* pName;

	Person2(char * name)
	{
		this->pName = new char[strlen(name) + 1];
		strcpy(this->pName, name);
	}

	/*
	* 重载 = 赋值运算符
	*/
	Person2 & operator= ( const Person2 & p) //返回值引用（引用的本质是指针）
	{
		//判断如果原来已经“堆区有内容”，先释放
		if (this->pName != NULL){
			delete[] this->pName;
			this->pName = NULL;
		}
		//重新开启堆空间
		this->pName = new char[strlen(p.pName) + 1];
		strcpy(this->pName, p.pName);

		return *this; //返回本体
	}

	//Person2的析构函数
	~Person2()
	{
		if (this->pName != NULL){
			delete[] this->pName;
			this->pName = NULL;
		}
	}
};

void test02()
{
	Person2 p1("狗蛋");
	Person2 p2("狗剩");
	//p2 = p1;

	Person2 p3("");
	p3 = p2 = p1; //调用“=等号”重载运算符（深浅拷贝，所以需要重载=等号运算符）

	cout << p2.pName << endl;
	cout << p3.pName << endl;

	//C++系统默认的赋值运算符
	//int a = 10;
	//int b = 20;
	//int c;
	//c = a = b; //都是20
	//cout << a << " " << b << " " << c << endl;

}

int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p2 的m_A10
----------------
狗蛋
狗蛋
请按任意键继续. . .
*/