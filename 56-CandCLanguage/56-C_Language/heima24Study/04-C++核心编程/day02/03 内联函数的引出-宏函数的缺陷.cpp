#define _CRT_SECURE_NO_WARNINGS
#include<iostream>

using namespace std;

//定义一个加法
//#define  MyAdd(x,y) x + y
#define  MyAdd(x,y) ((x)+(y))

void test01()
{
	int ret = MyAdd(10, 20) * 20; //预期结果 600 ((10)+(20))*20

	cout << "ret = " << ret << endl; //ret = 600
}


#define MyCompare(a,b)  ((a) < (b)) ? (a) :(b)

inline void mycompare(int a, int b) //c++引入了内联函数(inline function).
{
	int ret = a < b ? a : b;
	cout << "ret :::::  " << ret << endl;
}

//1 内联函数注意事项
// 类内部的成员函数 默认前面会加“inline”关键字
inline void func();     //内联函数声明
inline void func() { }; //如果函数实现时候，没有加“inline”关键字 ，那么这个函数依然不算内联函数

void test02()
{
	int a = 10;
	int b = 20;

	//int ret =  MyCompare(++a, b); // 预期结果 11    ((++a) < (b)) ? (++a):(b)

	//cout << "ret = " << ret << endl; //ret = 12

	mycompare(++a, b); //ret :::::  11

}

/*
* 3 宏函数也没有作用域
*/


int main() {

	test01();

	test02();

	system("pause");
	return EXIT_SUCCESS;
}