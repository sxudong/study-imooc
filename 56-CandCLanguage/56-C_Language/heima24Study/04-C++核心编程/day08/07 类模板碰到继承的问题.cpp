#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
6 当类模板碰到继承
	6.1	基类如果是模板类，必须让子类告诉编译器 基类中的T到底是什么类型
	6.2	如果不告诉，那么无法分配内存，编译不过
	6.3	利用参数列表class Child : public Base<int>
*/


/*
* 类模板
*/
template <class T> //相当于Java泛型类指定类的泛型参数
class Base
{
public:
	T m_A; //double类型
};

/*
* child继承与 base必须告诉base中的T的类型，否则T无法分配内存
*/
class Child : public Base<int> //基类的类型写死了
{

};

/*
* child2 也是模板类
*/
template<class T1, class T2>   //相当于Java泛型类指定类的泛型参数列表
class Child2 : public Base<T2> //基类的类型没有写死，由用户来指定。
{
public:
	T1 m_B; //int类型

	Child2(){
		cout << typeid(T1).name() << endl;
		cout << typeid(T2).name() << endl;
	}
};

void test01()
{
	Child2<int, double>child; //类型由用户指定类型
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
int
double
请按任意键继续. . .
*/