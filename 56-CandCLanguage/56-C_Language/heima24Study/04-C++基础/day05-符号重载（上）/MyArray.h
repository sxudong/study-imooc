#pragma  once
#include <iostream>
using namespace std;

class MyArray
{
public:
	MyArray(); //默认构造  默认100容量
	MyArray(int capacity);
	MyArray(const MyArray & array); //MyArray & array = * array;  别名本质上是指针

	~MyArray();


	//尾插法
	void push_Back(int val);

	//根据索引获取值
	int getData(int index);

	//根据索引设置值
	void setData(int index, int val);

	//获取数组大小
	int getSize();

	//获取数组容量
	int getCapacity();

	//[]运算符重载
	int& operator[](int index );

private:
	int * pAddress; //指向真正存储数据的指针（数组指针 pAddress = new int[this->m_Capacity];）
	int m_Size;     //数组大小
	int m_Capacity; //数组容量
};