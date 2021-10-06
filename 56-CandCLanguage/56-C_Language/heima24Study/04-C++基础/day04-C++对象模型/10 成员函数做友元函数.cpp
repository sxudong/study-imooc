#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>

/*
8 友元
	8.3	让成员函数做友元函数
		8.3.1 friend void goodGay::visit();
*/



/*
* 需求：只让 visit 可以作Building的好朋友  visit2 不可以访问私有属性
*/
class Building;

class goodGay
{
public:
	goodGay();

	void visit();
	void visit2();
private:
	Building * building;
};

class Building
{
	/*
	* 让成员函数 visit 作为“友元函数”
	*/
	friend void goodGay::visit();

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

void goodGay::visit2()
{
	cout << "好基友正在访问： " << this->building->m_SittingRoom << endl; //只可以访问公有方法
	//cout << "好基友正在访问： " << this->building->m_BedRoom << endl;   //err 私有方法编译器报错
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
	gg.visit2();
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
好基友正在访问： 客厅
好基友正在访问： 卧室
好基友正在访问： 客厅
请按任意键继续. . .
*/
