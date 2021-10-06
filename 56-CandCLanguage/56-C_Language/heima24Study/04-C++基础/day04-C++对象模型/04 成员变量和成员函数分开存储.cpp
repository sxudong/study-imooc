#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
4 C++对象模型初探
	4.1	成员变量和成员函数是分开存储的
	4.2	空类的大小 1
	4.3	只有非静态成员属性才属于对象身上
*/


class Person
{
public:
	/*
	* 结论：非静态成员变量，才属于对象身上。
	*/
	int m_A;                //非静态成员变量，属于对象身上   4个字节
	//void func(Person* this) {}; 编译器在调func()时会偷偷加上“Person* this”参数，所以普通成员函数里面都会加这么一个指针。
	void func() {};        //非静态成员函数，不属于对象身上
	static int m_B;         //静态成员变量，不属于对象身上
	static void  func2() {}; //静态成员函数，不属于对象身上
	double m_C;             //占16个字节                     8个字节   使用#pragma pack(1)修改对齐方式为1个字节，打印就是12个字节了
};


void test01()
{
	//Person空类的大小为“1”，每个“实例的对象”都有独一无二的地址，char维护这个地址。
	cout << "sizo of (Person) = " << sizeof(Person) << endl; //sizo of (Person) = 16

	// Person p[10]  p[0] p[1] //每个“实例的对象”都有独一无二的地址
}


void test02()
{
	/*
	* “this指针”指向被调用的成员函数所属的对象
	*/

	Person p1;
	p1.func(); //编译器会偷偷加入一个“this指针”Person * const this

	Person p2;
	p2.func(); //相当于把p2的指针做为参数扔进func()中，Person * this 这个“this”指向p2，说白了谁用它，this就指向谁。
}

int main() {
	test01();

	system("pause");
	return EXIT_SUCCESS;
}