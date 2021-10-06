#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
5 C++对C语言增强
    5.1	全局变量检测增强
    5.2	函数检测增强
        5.2.1 参数类型检测
        5.2.2 返回值检测
        5.2.3 传参个数检测
    5.3	类型转换检测增强
        5.3.1 malloc返回void* ，C中可以不用强转，C++必须强转
    5.4	struct增强
        5.4.1 C中不许有函数 C++可以
        5.4.2 使用C必须加关键字 struct ，C++可以不加
    5.5	bool数据类型增强
        5.5.1 C没有 C++有
        5.5.2 true 真  false假
        5.5.3 sizeof  1
    5.6	三目运算符增强
        5.6.1 C中返回的是值
        5.6.2 C++中返回的是变量
    5.7	const增强
        5.7.1 C语言中const是伪常量，可以通过指针修改
        5.7.2 C++中const会放入到符号表中
        5.7.3 C语言中const默认是外部链接，C++中const默认是内部链接
        5.7.4 const分配内存情况
            5.7.4.1	对变量取地址，会分配临时内存
            5.7.4.2	extern关键字下的const会分配内存
            5.7.4.3	用普通变量初始化const变量
            5.7.4.4	自定义数据类型会分配内存
        5.7.5	尽量用const代替define
            5.7.5.1	define宏没有作用域概念
            5.7.5.2	define宏常量没有类型
*/


/*
* 1、全局变量检测增强
*/
//int a;
int a = 10;

/*
* 2、函数检测增强 ,参数类型增强,返回值检测增强,函数调用参数检测增强
*/
int getRectS(int w, int h)
{
	return w*h;
}
void test02()
{
	getRectS(10, 10);
}


/*
* 3、类型转换检测增强
*/
void test03()
{
	char * p = (char*) malloc(sizeof(64)); //malloc返回值是void*
}


/*
* 4、struct 增强
*/
struct Person
{
	int m_Age;
	void plusAge(){ m_Age++; }; //c++中struct可以加函数
};

void test04()
{
	Person p1; //使用时候可以不加“struct”关键字
	p1.m_Age = 10;
	p1.plusAge();
	cout << p1.m_Age << endl; //11
}

/*
* 5、 bool类型增强 C语言中没有bool类型
*/
bool flag = true; //只有真或假 true代表 真（非0）  false 代表假（0）

void test05()
{
	cout << sizeof(bool) << endl; //1

	flag = 100;
	//bool类型 非0的值 转为 1  ，0就转为0
	cout << flag << endl; //1
}

/*
* 6、三目运算符增强
*/
void test06()
{
	int a = 10;
	int b = 20;

	cout << "ret = " << (a < b ? a : b) << endl; //ret = 10

	a < b ? a : b = 100; //b = 100  C++中返回的是变量
	cout << "a = " << a << endl; //a = 10
	cout << "b = " << b << endl; //b = 20

	(a < b ? a : b) = 100;
	cout << "a = " << a << endl; //a = 100
	cout << "b = " << b << endl; //b = 20
}


/*
* 7、 const增强
* C语言中，const修饰的变量，是伪常量，编译器是会分配内存的
* C++中，const不会分配内存,const int m_B = 20;
*/
const int m_A = 10; //收到保护，不可以改
void test07()
{
	const int m_B = 20; //真正的“常量”
	//m_B = 100;  //编译器报错

	/*
	* 编译器会临时开辟一块内存空间
	*   int tmp = m_B //tmp有内存
	*   int *p = (int *) &tmp  //*p指向的是临时那块空间
	*   临时空间看不到
	*/
	int * p = (int *) &m_B;
	*p = 200;
	cout << "*p = " << *p << endl;   //*p = 200
	cout << "m_B = " << m_B << endl; //m_B = 20

	int arr[m_B]; //可以初始化数组
}


int main(){

	test04();
	cout << "------------------" << endl;
	test05();
	cout << "------------------" << endl;
	test06();
	cout << "------------------" << endl;
	test07();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
11
------------------
1
1
------------------
ret = 10
a = 10
b = 20
a = 100
b = 20
------------------
*p = 200
m_B = 20
请按任意键继续. . .
*/