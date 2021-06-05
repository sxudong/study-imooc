#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;



/*
1 函数模板基本使用
	1.1	template < class / typename  T> 告诉编译器紧跟的代码里出现T不要报错
	1.2	mySwap(T & a  T & b) 类型也需要传入，类型参数化
	1.3	myswap（a, b） 自动类型推导  按照a b的类型 来替换T
	1.4	myswap<int>(a, b) 显示指定类型
*/



/*
* 交换int类型两个数字
*/
void mySwapInt( int & a, int & b)
{
	int tmp = a;
	a = b;
	b = tmp;
}

/*
* 交换double数据
*/
void mySwapDouble(double & a, double & b)
{
	double tmp = a;
	a = b;
	b = tmp;
}


/*
* 模板技术：类型参数化，泛型编程。
*
* 类型，逻辑又非常相似
*/
template<class T> // 告诉编译器下面如果出现 T 不要报错，T是一个通用的类型（类似Java的泛型方法声明泛型列表）
void mySwap(T & a, T & b)
{
	T tmp = a;
	a = b;
	b = tmp;
}


/*
* template<typename T>  等价于 template<class T>
* 必须要指定出 T 才可以使用
*/
template<typename T>
void mySwap2(T& a, T& b){
	T tmp = a;
	a = b;
	b = tmp;
}

void test01()
{
	int a = 10;
	int b = 20;
	char c1 = 'c';

	//mySwapInt(a, b);

	/*
	* 1 “自动类型推导”必须有参数类型才可以推导
	*/
	//mySwap(a, c1); //推导不出来T，所以不能运行
	mySwap(a, b);

	/*
	* 2 显示的“指定类型”
	*   指定类型了，它就不需要推导了。
	*/
	mySwap<int>(a, b); //调用泛型方法

	cout << "a = " << a << endl; //10
	cout << "b = " << b << endl; //20

	double c = 3.14;
	double d = 1.1;
	//mySwapDouble(c, d);
	mySwap(c, d);     //调用泛型方法

	/*
	* 模板必须要指定出 T 才可以使用
	* template<typename T>
	*/
	mySwap2<double>(c, d);

	cout << "c = " << c << endl; //3.14
	cout << "d = " << d << endl; //1.1
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
a = 10
b = 20
c = 3.14
d = 1.1
请按任意键继续. . .
*/