#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>

/*
8 ��Ԫ
	8.3	�ó�Ա��������Ԫ����
		8.3.1 friend void goodGay::visit();
*/



/*
* ����ֻ�� visit ������Building�ĺ�����  visit2 �����Է���˽������
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
	* �ó�Ա���� visit ��Ϊ����Ԫ������
	*/
	friend void goodGay::visit();

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

void goodGay::visit2()
{
	cout << "�û������ڷ��ʣ� " << this->building->m_SittingRoom << endl; //ֻ���Է��ʹ��з���
	//cout << "�û������ڷ��ʣ� " << this->building->m_BedRoom << endl;   //err ˽�з�������������
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
	gg.visit2();
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�û������ڷ��ʣ� ����
�û������ڷ��ʣ� ����
�û������ڷ��ʣ� ����
�밴���������. . .
*/
