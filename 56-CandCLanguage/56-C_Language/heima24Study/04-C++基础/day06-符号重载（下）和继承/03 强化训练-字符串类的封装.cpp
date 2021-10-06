#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include "MyString.h"
using namespace std;


/*
4 强化训练 —— 字符串封装
	4.1	cout 输入 自定义的字符串
	4.2	cin 让用户输入字符串内容
	4.3	重载 = 运算符
	4.4	重载 + 运算符
	4.5	重载 [] 运算符
	4.6	重载 == 运算符
*/


//测试 MyString
void test01()
{
	MyString str = "abc";

	//调用全局函数 << 左移运算符重载
	cout << str << endl; //abc

	/*
	cout << "请输入str新的内容：" << endl;

	cin >> str;  //cin输入 调用全局函数 >> 右移运算符重载

	cout << "新内容为：" << str << endl;
	*/

	MyString str2(str);

	MyString str3 = "aaaaaa";

	str3 = str2;    //调用成员函数 重载 = 运算符
	str3 = "aaaa";  //调用成员函数 重载 = 运算符

	cout << "str3 = " << str3 << endl;  //str3 = aaaa

	str3[0] = 'w'; //调用成员函数 重载 [] 运算符

	cout << "str3 第一个位置为 = " << str3[0] << endl; //str3 第一个位置为 = w


	MyString str4 = "";
	//调用成员函数 重载 + 运算符
	str4 = str2 + str3; //字符串拼接
	cout << "str4 为 " << str4 << endl;


	//调用成员函数 重载 == 运算符
	if (str3 == str4)
		cout << "str3 与 str4相等" << endl;
	else
		cout << "str3 与 str4不相等" << endl;

	/* 系统自带的右移运算符运算
	int a = 10;
	cin >> a; //cin输入
	cout << "a = " << a << endl;
	*/

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
abc
str3 = aaaa
str3 第一个位置为 = w
str4 为 abcwaaa
str3 与 str4不相等
请按任意键继续. . .
*/