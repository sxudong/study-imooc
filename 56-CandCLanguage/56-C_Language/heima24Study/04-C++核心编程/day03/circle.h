#pragma  once
#include <iostream>
using namespace std;
#include "point.h"

/*
* Բ��
* ����ʵ����circle.cpp��
*/
class Circle
{
public:

	//���ð뾶
	void setR(int r);
	/*{
		m_R = r;
	}*/

	//��ȡ�뾶
	int getR();
	/*{
		return m_R;
	}*/

	//����Բ��
	void setCenter(Point p);
	/*{
		m_Center = p;
	}*/

	//��ȡԲ��
	Point getCenter();
	/*{
		return m_Center;
	}*/

	//���ó�Ա�����жϵ��Բ��ϵ
	void isInCircleByClass(Point & p);
	//{
	//	//��ȡԲ�ĺ͵�ľ��� ��ƽ��
	//	int distance = (m_Center.getX() - p.getX()) * (m_Center.getX() - p.getX()) + (m_Center.getY() - p.getY()) * (m_Center.getY() - p.getY());
	//	int rDistance = m_R* m_R;
	//	if (rDistance == distance)
	//	{
	//		cout << "��Ա������������Բ��" << endl;
	//	}
	//	else if (rDistance > distance)
	//	{
	//		cout << "��Ա������������Բ��" << endl;
	//	}
	//	else
	//	{
	//		cout << "��Ա������������Բ��" << endl;
	//	}
	//}

private:
	int m_R; //�뾶
	Point m_Center; //Բ��
};