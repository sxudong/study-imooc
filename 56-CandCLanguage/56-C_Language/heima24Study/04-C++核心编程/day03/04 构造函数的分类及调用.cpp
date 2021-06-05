#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
4 构造函数的分类及调用
    4.1	按照参数分类
        4.1.1 无参构造（默认构造）  有参构造
    4.2	按照类型分类
        4.2.1 普通构造函数  拷贝构造函数
    4.3	无参构造写法 和调用
        4.3.1 Person p1 ; 注意不能写 Person p1() ，因为编译器认为这个是函数声明
    4.4	有参构造写法 和调用
        4.4.1 Person p2(10)  或者 Person p2 = Person(10)
        4.4.2 Person(10) 匿名对象 ，执行当前行后就会释放这个对象
    4.5	拷贝构造函数
        4.5.1 Person( const Person & p )
        4.5.2 Perons p1( p2) 或者 Person p1 = Person(p2)
        4.5.3 不能用拷贝构造函数初始化匿名对象
            4.5.3.1	如果写成 Person (p1)  这种写法等价于 Person p1
            4.5.3.2	写到右值可以做拷贝构造函数
    4.6	Person P = 100 隐式类型转换 相当于调用 Person p = Person(100)
*/


/*
* 分类
* 按照参数进行分类  无参构造函数（默认构造函数）   有参构造函数
* 按照类型进行分类  普通构造函数  拷贝构造函数
*/
class Person
{
public: //构造和析构必须写在public下才可以调用到

	Person() //默认 、 无参构造函数
	{
		cout << "默认构造函数调用" << endl;
	}

	Person(int a)
	{
		cout << "有参构造函数调用" << endl;
	}

	//拷贝构造函数
	Person(const Person & p)
	{
		m_Age = p.m_Age;
		cout << "拷贝构造函数调用" << endl;
	}

	~Person()
	{
		cout << "析构函数调用" << endl;
	}

	int m_Age;
};

/*
* 构造函数调用方式
*/
//1.括号法调用
void test01()
{
	Person p1(1);  //调用“有参构造函数”
	p1.m_Age = 10;
	Person p2(p1); //调用“拷贝构造函数”
	cout << "p2的年龄" << p2.m_Age << endl; //p2的年龄10

	//调用“默认构造函数”创建对象，不要加()
	Person p3;
	//Person p3(); //编译器认为这行是函数的声明
}

//2.显示法调用
void test02() {

	Person p4 = Person(100);
	Person p5 = Person(p4);

	//调用“默认构造函数”创建对象
	//叫“匿名对象” ,匿名对象特点：如果编译器发现了对象是“匿名”的，
	//那么“在这行代码结束后”就释放这个对象。所以“析构函数调用”在
	//"aaaaaaa" 前面。
	Person(100);
	cout << "aaaaaaa" << endl;

	//不能用“拷贝构造函数”初始化匿名对象
	//Person(p5); //err 如果写成左值，编译器认为你写成 Person p5; 对象的声明,编译器报错重定义。
	Person p6 = Person(p5); //如果写成右值，那么可以，它会当你用“拷贝构造函数”给p6。
}

//3.隐式类型转换
void test03() {

	Person p7 = 100; //相当于调用了 Person p7 = Person(100) ，隐式类型转换
	Person p8 = p7;  // 相当于  Person p8 = Person(p7); //拷贝构造函数

}


int main(){

	test01();
	cout << "-------------" << endl;
	test02();
	cout << "-------------" << endl;
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
有参构造函数调用
拷贝构造函数调用
p2的年龄10
默认构造函数调用
析构函数调用
析构函数调用
析构函数调用
-------------
有参构造函数调用
拷贝构造函数调用
有参构造函数调用
析构函数调用
aaaaaaa
拷贝构造函数调用
析构函数调用
析构函数调用
析构函数调用
-------------
有参构造函数调用
拷贝构造函数调用
析构函数调用
析构函数调用
请按任意键继续. . .
*/