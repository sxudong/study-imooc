#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
* 函数重载
* C++中 函数名称可以重复
* 必须在同一个作用域,函数名称相同
* 函数的参数 个数不同 或者 类型不同  或者 顺序不同
*/
void func()
{
	cout << "无参数的func" << endl;
}

void func(int a )
{
	cout << "有参数的func(int a)" << endl;
}

void func(double  a)
{
	cout << "有参数的func(double a)" << endl;
}

void func(double  a , int b)
{
	cout << "有参数的func(double a ,int b)" << endl;
}

void func(int a, double b)
{
	cout << "有参数的func(int a ,double b)" << endl;
}

/*
* “返回值”可以作为函数重载的条件吗？？？ —— 不可以
*/
//int func(int a, double b) //int类型返回值
//{
//	cout << "有参数的func(int a ,double b)" << endl;
//	return 1;
//}

void test01()
{
	func(1.1);     //有参数的func(double a)
	func(1.1,3);   //有参数的func(double a ,int b)
	func(1, 3.14); //有参数的func(int a ,double b)
}


/*
* 当函数重载 碰到了“默认参数”时候，要注意避免二义性问题
*/
void func2(int a,int b = 10)
{

}
void func2(int a)
{

}

void test02()
{
	//func2(10);  //err 编译器报警

}

/*
* 引用的重载版本
*/
void func3(int &a) //引用必须要引合法的内存空间
{
	cout << " int &a" << endl;
}
void func3(const int& a)  //const也是可以作为“重载”的条件  int tmp = 10; const int &a = tmp;
{
	cout << "const int &a" << endl;
}


void test03()
{
	int a = 10;
	func3(a);
	//func3(10); //err 编译器报警，加上“const”后，编译器才不报警。
	func3(10); //const int &a
}


int main(){
	test01();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}