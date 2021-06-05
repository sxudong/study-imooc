#define _CRT_SECURE_NO_WARNINGS //传统的宏在C++上不支持，如printf()，strcpy()，它会报C4996不安全。
#include<iostream>
using namespace std;

/*
2 ::双冒号作用域运算符
    2.1	全局作用域 直接加：：
*/


int atk = 200; //全局变量
void test01()
{
	int atk = 100; //局部变量

	cout << "攻击力为 ： " << atk << endl; //100
	//双冒号“作用域运算符”  :: 不写作用域就是“全局作用域”
	cout << "全局攻击力为 ： " << ::atk << endl; //200
}

int main(){
	test01();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
攻击力为 ： 100
全局攻击力为 ： 200
请按任意键继续. . .
*/