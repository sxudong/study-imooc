#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
4 智能指针实现
	4.1	Person类有showAge 成员函数
	4.2	如果new出来的Person对象，就要让程序员自觉的去释放  delete
	4.3	有了智能指针，让智能指针托管这个Person对象，对象的释放就不用操心了，让智能指针管理
	4.4	为了让智能指针想普通的Person * 指针一样使用 就要重载 -> 和 *
*/


class Person
{
public:
	Person(int age)
	{
		this->m_Age = age;
	}

	void showAge()
	{
		cout << "年龄为：" << this->m_Age << endl;
	}

	~Person()
	{
		cout << "Person的析构调用" << endl;
	}

	int m_Age;
};



/*
* 智能指针
* 用来托管自定义类型的对象，让对象进行自动的释放。
*/
class SmartPointer
{
private:
	Person* person;

public:
	SmartPointer(Person * person)
	{
		this->person = person;
	}

	/*
	* 重载 -> 让智能指针对象 像 Person *p 一样去使用
	*/
	Person * operator-> ()
	{
		return this->person; //返回指针
	}

	/*
	* 重载 *
	*/
	Person & operator* ()
	{
		return *this->person; //把维护指针的本体返回去
	}

	/*
	* SmartPointer的析构函数
	* 智能指针析构掉时，顺带把 Person 释放。
	*/
	~SmartPointer()
	{
		cout << "智能指针析构了" << endl;
		if (this->person != NULL){
			delete this->person;
			this->person = NULL;
		}
	}
};

void test01()
{
	//1.自动析构
	//Person p1(10);

	//2.Person的析构调用
	//new出来的Person对象，就要让程序员自觉的去释放 delete
	//Person * p1 = new Person(10);
	//p1->showAge();
	//delete p1;

	//3.智能指针
	//智能指针托管这个Person对象，对象的释放就不用操心了
	SmartPointer sp(new Person(10)); //sp开辟到了栈上，开辟在栈上会自动释放
	sp->showAge();                   //sp->->showAge(); 编译器优化了写法。使用重载的->
	(*sp).showAge();                 //使用重载 *

}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
年龄为：10
年龄为：10
智能指针析构了
Person的析构调用
请按任意键继续. . .
*/
