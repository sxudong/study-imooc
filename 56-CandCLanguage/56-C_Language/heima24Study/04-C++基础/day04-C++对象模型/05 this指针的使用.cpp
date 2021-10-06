#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
5 this指针使用
	5.1	指针永远指向当前对象
	5.2	解决命名冲突
	5.3 * this 指向对象本体
	5.4	非静态的成员函数才有this指针
*/


/*
* this可以解决命名冲突
*/
class Person
{
public:
	//Person(Person * this, int age) //编译器会偷偷加入“Person * this”（this被作为隐藏参数传递给方法）
	Person(int age)
	{
		this->age = age;
		//(*this).age = age; //作用一致
	}

	//对比年龄
	void compareAge( Person & p)
	{
		if (this->age == p.age )
			cout << "年龄相等" << endl;
		else
			cout << "年龄不相等" << endl;
	}

	//年龄相加
	//Person& PlusAge(Person * this, Person & p)
	 Person & PlusAge(Person & p) //返回类型为“引用”,意思者返回的是调用对象本身。
	{
		 this->age += p.age;
		 //每个成员函数(包括类成员)都有一个this指针。“this”指针指向调用对象，如果方法需要引用“整个调用对象”，则可以使用表达式“*this”。
		 //要返回的并不是this，因为this是对象地址，而不是对象本身，即 *this。(将解除引用运算符)
		 //可以将 *this 作为调用对象的别名来完成前面的方法定义。
		 return *this;
	}

	int age;
};

void test01()
{
	Person p1(10);

	cout << "p1的年龄" << p1.age << endl;

	Person p2(10);

	p1.compareAge(p2);

	p1.PlusAge(p2).PlusAge(p2).PlusAge(p2); //链式编程

	cout << "p1的年龄" << p1.age << endl;
}



int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1的年龄10
年龄相等
p1的年龄40
请按任意键继续. . .
*/