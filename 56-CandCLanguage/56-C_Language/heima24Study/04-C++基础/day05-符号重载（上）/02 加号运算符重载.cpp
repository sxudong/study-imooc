#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
1 加号运算符重载
	1.1	如果想让自定义数据类型 进行 + 运算，那么就需要重载 + 运算符
	1.2	在成员函数 或者 全局函数里 重写一个 + 运算符的函数
	1.3	函数名 operator+ () {}
	1.4	运算符重载 也可以提供多个版本
*/

/*
int a = 10;
int b = 10;
int c = a + b;     //对于内置数据类型，编译器知道如何运算（+）

Person p1(1, 1);
Person p2(1, 1);

Person p3 = p1 + p2 //编译器不知道如何让两个Person类型进行运算，自定义加号运算
p3.m_A = 2, p3.m_B = 2
*/


class Person
{
public:
	Person(){};
	Person(int a, int b) :m_A(a), m_B(b) //“初始化列表”初始化数据
	{}

	/*
	* +号运算符重载
	* 成员函数   二元
	* 无参函数   一元（有一个默认this参数）
	*/
	/*
	Person operator+ ( Person & p) //二元，成员函数要多加一个1，因为编译器会偷偷加一个“Person * this”做为参数。
	{
		Person tmp;
		tmp.m_A = this->m_A + p.m_A;
		tmp.m_B = this->m_B + p.m_B;
		return tmp;
	}
	*/

	int m_A;
	int m_B;
};

/*
* 利用“全局函数”进行 +号 运算符的重载
* 重载一个“加号”运算符，这个名字 operator+ 是由编译器来取的。
*/
Person operator+ ( Person & p1, Person & p2) //全局函数有2个参数的是“二元”  p1 + p2
{
	Person tmp;
	tmp.m_A = p1.m_A + p2.m_A;
	tmp.m_B = p1.m_B + p2.m_B;
	return tmp;
}

//加号运算符重载
Person operator+ (Person & p1, int a) //二元
{
	Person tmp;
	tmp.m_A = p1.m_A + a;
	tmp.m_B = p1.m_B + a;
	return tmp;
}


void test01()
{
	//创建2个对象
	Person p1(10, 10);
	Person p2(10, 10);

	//要运算，必需提供+号运算符重载
	Person p3 = p1 + p2; // p1 + p2  从什么表达式转变的？调用成员方法转变：p1.operator+(p2),全局方法转变：operator+(p1,p2)
	Person p4 = p1 + 10; //+号运算符的重载的版本
	cout << "p3 的 m_A: " << p3.m_A << "  m_B: " << p3.m_B << endl;
	cout << "p4 的 m_A: " << p4.m_A << "  m_B: " << p4.m_B << endl;

	//operator+(p1, p2);

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p3 的 m_A: 20  m_B: 20
p4 的 m_A: 20  m_B: 20
请按任意键继续. . .
*/