#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "game1.h"
#include "game2.h"

/*
3 namespace 命名空间
    3.1	用途 解决名称冲突问题
    3.2	必须在全局作用域下声明
    3.3	命名空间下可以放入 函数、变量、结构体、类…
    3.4	命名空间可以嵌套命名空间
    3.5	命名空间是开放的，可以随时加入新的成员
    3.6	匿名命名空间 static
    3.7	可以起别名
*/


/*
* namespace命名空间主要用途 用来解决"命名冲突"的问题
*/
void test01()
{
	LOL::goAtk();
	KingGlory::goAtk();
}


//1、命名空间下,可以放函数、变量、结构体、类
namespace A
{
	void func();  //函数
	int m_A = 20; //变量

	struct Person //结构体
	{
	};

	class Animal{}; //类

	namespace B
	{
		int m_A = 10;
	}
}
//2、命名空间必须定义在全局作用域下
//3、命名空间可以嵌套命名空间

void test02()
{
	cout << "作用域B下的m_A为： " << A::B::m_A << endl;
}

//4、命名空间是开放的，可以随时往原先的命名空间添加内容
namespace A  //此A命名空间会和上面的命名空间A进行“合并”
{
	int m_B = 1000;
}

void test03()
{
	cout << "A::下的m_A为" << A::m_A << " m_B为： " << A::m_B << endl; //A::下的m_A为20 m_B为： 1000
}


//5、无名、匿名命名空间
//当写了无名命名空间，相当于写了 static int m_C ; static int m_D;
//只能在当前文件内使用
namespace
{
	int m_C = 0;
	int m_D = 0;
}


//6、命名空间可以“起别名”
namespace veryLongName
{
	int m_A = 30;
}

void test04()
{
	//起别名
	namespace veryShortName = veryLongName;
	cout << veryLongName::m_A << endl;  //30
	cout << veryShortName::m_A << endl; //30
}


int main(){

	test02();

	test03();

	test04();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
作用域B下的m_A为： 10
A::下的m_A为20 m_B为： 1000
30
30
请按任意键继续. . .
*/