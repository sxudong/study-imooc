#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
8 ��Ԫ
	8.1	ȫ�ֺ�������Ԫ����
		8.1.1 ��ȫ�ֺ�����д��������������������ǰ��д�ؼ��֡�friend��
	8.2	��������������Ԫ�ࡱ
		8.2.1 friend  class ����
		8.2.2 ��Ԫ�� �ǵ��򣬲��ɴ��ݵ�
	8.3	�ó�Ա��������Ԫ����
		8.3.1 friend void goodGay::visit();
*/


class Building
{
	/*
	* �á�ȫ�ֵĺû��Ѻ�������Ϊ�ҵĺ����� ���� ��Ԫ����
	*/
	friend void goodGay(Building * building);

public:
	Building()
	{
		this->m_SittingRoom = "����";
		this->m_BedRoom = "����";
	}

//����
public:
	string m_SittingRoom; //����

//����
private:
	string m_BedRoom; //����
};

//ȫ�ֺ���  �û���
void  goodGay( Building * building )
{
	cout << "�û������ڷ��� " << building->m_SittingRoom << endl;
	cout << "�û������ڷ��� " << building->m_BedRoom << endl;
}


void test01()
{
	Building * building = new Building;
	goodGay(building);
}


/*
* ���ۣ�����Ԫ������Ŀ�ķ������е�˽�г�Ա����
*/
int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/*
�û������ڷ��� ����
�û������ڷ��� ����
�밴���������. . .
*/