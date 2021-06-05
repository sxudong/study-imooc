#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
3 前置 后置 ++ 运算符重载
	3.1	自己实现int类型 MyInteger
	3.2	内部维护以int数据
	3.3	MyInteger myInt
	3.4	myInt++ 后置  ++myInt  前置
	3.5	重载++运算符 operator++() 前置   operator++(int) 后置
	3.6	前置理念 先++ 后返回自身。 后置理念 先保存住原有值  内部++ 返回临时数据
	3.7	练习  自己实现递减运算符重载--
*/



class MyInteger
{
	friend ostream & operator<< (ostream & cout, MyInteger & myInt);

public:
	MyInteger()
	{
		m_Num = 0;
	};

	//前置++ 重载
	MyInteger & operator++()
	{
		this->m_Num++;
		return *this;
	}

	//后置++ 重载
	MyInteger operator++(int)
	{
		//先保存目前数据
		MyInteger tmp = *this;
		m_Num++;
		return tmp;
	}

	int m_Num;
};

/*
* << 左移重载函数
* 第一个参数：cout  第二个参数：MyInteger
*/
ostream & operator<< ( ostream & cout ,MyInteger & myInt)
{
	cout << myInt.m_Num;
	return cout;
}

void test01()
{
	MyInteger myInt;
	// 前置++

	cout << ++(++myInt) << endl; //2   0 + 1 + 1 = 2
	cout << myInt << endl;       //2

	//后置++
	cout << myInt++ << endl; //2
	cout << myInt << endl;   //3
}

int main(){

	test01();

	int a = 10;
	cout << ++(++a) << endl; //12
	cout << a << endl;       //12

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
2
2
2
3
12
12
请按任意键继续. . .
*/