#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
3 模板局限性
	3.1	模板不能解决所有的类型
	3.2	如果出现不能解决的类型，可以通过第三地具体化来解决问题
	3.3	template<> 返回值 函数名<具体类型>（参数）
*/


class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;
		this->m_Age = age;
	}
};



template<class T> //模板（类似Java泛型方法）
bool myCompare( T & a , T & b )
{
	if ( a == b)
		return true;

	return false;
}


/*
* 通过第三代“具体化”自定义数据类型，解决上述问题。
* 如果具体化能够优先匹配，那么就选择“具体化”。
*
* 语法：template<> 返回值  函数名<具体类型>(参数)
*/
template<> bool myCompare<Person>(Person & a, Person & b)
{
	if ( a.m_Age  == b.m_Age)
		return true;

	return false;
}


void test01()
{
	int a = 10;
	int b = 20;

	int ret = myCompare(a, b);

	cout << "ret = " << ret << endl; //0

	Person p1("Tom", 10);
	Person p2("Jerry", 10);

	int ret2 = myCompare(p1, p2);

	cout << "ret2 = " << ret2 << endl; //1

}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 0
ret2 = 1
请按任意键继续. . .
*/