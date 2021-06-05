#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
8 友元
	8.1	全局函数做友元函数
		8.1.1 “全局函数”写到类中做声明，并且最前面写关键字“friend”
	8.2	让整个类做“友元类”
		8.2.1 friend  class 类名
		8.2.2 友元类 是单向，不可传递的
	8.3	让成员函数做友元函数
		8.3.1 friend void goodGay::visit();
*/


class Building
{
	/*
	* 让“全局的好基友函数”变为我的好朋友 —— 友元函数
	*/
	friend void goodGay(Building * building);

public:
	Building()
	{
		this->m_SittingRoom = "客厅";
		this->m_BedRoom = "卧室";
	}

//客厅
public:
	string m_SittingRoom; //客厅

//卧室
private:
	string m_BedRoom; //卧室
};

//全局函数  好基友
void  goodGay( Building * building )
{
	cout << "好基友正在访问 " << building->m_SittingRoom << endl;
	cout << "好基友正在访问 " << building->m_BedRoom << endl;
}


void test01()
{
	Building * building = new Building;
	goodGay(building);
}


/*
* 结论：“友元函数”目的访问类中的私有成员属性
*/
int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/*
好基友正在访问 客厅
好基友正在访问 卧室
请按任意键继续. . .
*/