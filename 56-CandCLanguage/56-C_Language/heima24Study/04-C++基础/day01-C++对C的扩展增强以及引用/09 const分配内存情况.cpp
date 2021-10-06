#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
* 1、const分配内存 取地址会分配“临时内存”
* 2、extern 编译器也会给const变量分配“内存”
*/
void test01()
{
	const int m_A = 10;
	int * p = (int*) &m_A; //会分配“临时内存”

	*p = 1000;

	//不能修改
	cout << "m_A = " << m_A << endl; //10
}

/*
* 3、用“普通变量”初始化 const 的变量
*/
void test02()
{
	int a = 10; //普通变量
	const int b = a; //会分配“内存”（普通变量地址赋值给const int b）

	int * p = (int *) &b;
	*p = 1000;

	//修改了内存值
	cout << "b = " << b << endl; //1000

}

/*
* 4、 自定义数据类型  加const也会分配“内存”
*/
struct Person
{
	string m_Name; //姓名
	int m_Age;
};

void test03()
{
	const Person p1 = {"bbb", 20}; //加const也会分配“内存”
	//p1.m_Name = "aaa"; //加了const不可以修改

	//绕过编译器检测进行修改，只要分配了内存的都可以修改
	Person * p = (Person*) &p1;
	p->m_Name = "德玛西亚";
	(*p).m_Age = 18;

	cout << "姓名： " << p1.m_Name << " 年龄： " << p1.m_Age << endl; //姓名： 德玛西亚 年龄： 18

}

int main(){

	test01();

	cout << "--------------" << endl;

	test02();

	cout << "--------------"<< endl;

	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
m_A = 10
--------------
b = 1000
--------------
姓名： 德玛西亚 年龄： 18
请按任意键继续. . .
*/