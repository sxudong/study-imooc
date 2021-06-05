#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
2 函数模板与普通函数的区别以及调用规则
	2.1	区别 “普通函数”可以进行隐式类型转换。“模板”不可以。
	2.2	调用规则
		2.2.1 c++编译器优先考虑普通函数
		2.2.2 可以通过空模板实参列表的语法限定编译器只能通过模板匹配
		2.2.3 函数模板可以像普通函数那样可以被重载
		2.2.4 如果函数模板可以产生一个更好的匹配，那么选择模板
	2.3	模板的机制
		2.3.1 模板并不是万能的，不能通用所有的数据类型
		2.3.2 模板不能直接调用，生成后的模板函数才可以调用
		2.3.3 二次编译，第一次对模板进行编译，第二次对替换T类型后的代码进行二次编译
*/


/*
* 1、“普通函数”与“函数模板”区别
*
* 区别：“函数模板”不可以进行隐式类型转换。
*/
template<class T>         //相当于“Java泛型方法”指定泛型参数列表
T myPlus(T a, T b)        //函数模板（类似Java的泛型方法）
{
	return a + b;
}

int myPlus2(int a, int b) //普通函数
{
	return a + b;
}

void test01()
{
	int a = 10;
	int b = 20;
	char c = 'c'; // a = 97,b = 98,c = 99 ......

	/*
	* “函数模板”不可以进行隐式类型转换
	*/
	//myPlus(a, c); //err 类型推导不出来

	/*
	* “普通函数”可以进行隐式类型转换
	*/
	cout << myPlus2(a, c) <<endl; // 10 + 99
}


/*
* 2、“普通函数”和“函数模板”的调用规则
*/
template<class T>
void myPrint(T a ,T b)
{
	cout << "模板调用的myPrint" << endl;
}


template<class T>
void myPrint(T a, T b ,T c)  //myPrint()重载
{
	cout << "模板调用的myPrint(a,b,c)" << endl;
}
//void myPrint(int a, int b, int c)
//{
//
//}

void myPrint(int a, int  b) //普通函数
{
	cout << "普通函数调用 myPrint" << endl;
}



void test02()
{
	int a = 10;
	int b = 20;

	/*
	* 1、如果出现重载，“优先使用”普通函数调用，如果没有实现，出现错误。
	*/
	myPrint(a, b);       //普通函数调用 myPrint

	/*
	* 2、如果想“强制调用模板”，那么可以使用空参数列表
	*/
	myPrint<>(a, b);     //模板调用的myPrint

	/*
	* 3、函数模板可以发生重载
	*/
	int c = 30;
	myPrint(a, b, c);    //调用3个参数的 myPrint(a,b,c) 模板重载方法

	/*
	* 4、如果函数模板可以产生更好的“匹配”，那么“优先调用”函数模板。
	*/
	char c1 = 'c';
	char d = 'd';
	myPrint(c1, d);     //模板调用的myPrint

}


int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
109
----------------
普通函数调用 myPrint
模板调用的myPrint
模板调用的myPrint(a,b,c)
模板调用的myPrint
请按任意键继续. . .
*/