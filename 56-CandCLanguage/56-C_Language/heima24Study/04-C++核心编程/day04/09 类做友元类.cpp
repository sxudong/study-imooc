#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
8 ��Ԫ
	8.2	��������������Ԫ�ࡱ
		8.2.1 friend  class ����
		8.2.2 ��Ԫ�� �ǵ��򣬲��ɴ��ݵ�
*/

class Building; //����������goodGay���ﲻ����������ʵ�֡�

class goodGay
{
public:
	goodGay();
	void visit();

private:
	Building * building; //˽�г�Ա���� ά����һ��Buildingָ��
};

class Building
{
	/*
	* �á��û����ࡱ��Ϊ Building �ĺ�����
	*/
	friend class goodGay;

public:
	Building();

public:
	string m_SittingRoom; //����

private:
	string m_BedRoom; //����
};

goodGay::goodGay()
{
	building = new Building;
}

void goodGay::visit()
{
	cout << "�û������ڷ��ʣ� " << this->building->m_SittingRoom << endl;
	cout << "�û������ڷ��ʣ� " << this->building->m_BedRoom << endl;
}

Building::Building()
{
	this->m_SittingRoom = "����";
	this->m_BedRoom = "����";
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
�û������ڷ��ʣ� ����
�û������ڷ��ʣ� ����
�밴���������. . .
*/