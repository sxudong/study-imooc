#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
8 友元
	8.2	让整个类做“友元类”
		8.2.1 friend  class 类名
		8.2.2 友元类 是单向，不可传递的
*/

class Building; //先声明，让goodGay类里不报错，后面再实现。

class goodGay
{
public:
	goodGay();
	void visit();

private:
	Building * building; //私有成员变量 维护了一个Building指针
};

class Building
{
	/*
	* 让“好基友类”作为 Building 的好朋友
	*/
	friend class goodGay;

public:
	Building();

public:
	string m_SittingRoom; //客厅

private:
	string m_BedRoom; //卧室
};

goodGay::goodGay()
{
	building = new Building;
}

void goodGay::visit()
{
	cout << "好基友正在访问： " << this->building->m_SittingRoom << endl;
	cout << "好基友正在访问： " << this->building->m_BedRoom << endl;
}

Building::Building()
{
	this->m_SittingRoom = "客厅";
	this->m_BedRoom = "卧室";
}

void test01()
{
	goodGay gg;
	gg.visit();
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
好基友正在访问： 客厅
好基友正在访问： 卧室
请按任意键继续. . .
*/