#include "circle.h"

/*
* ����������circle.hͷ�ļ���
*/

//���ð뾶
void Circle::setR(int r)
{
	m_R = r;
}

//��ȡ�뾶
int Circle::getR()
{
	return m_R;
}

//����Բ��
void Circle::setCenter(Point p)
{
	m_Center = p;
}

//��ȡԲ��
Point Circle::getCenter()
{
	return m_Center;
}

//���ó�Ա�����жϵ��Բ��ϵ
void Circle::isInCircleByClass(Point & p)
{
	//��ȡԲ�ĺ͵�ľ��루distance����ƽ��
	int distance = (m_Center.getX() - p.getX()) * (m_Center.getX() - p.getX())  +  (m_Center.getY() - p.getY()) * (m_Center.getY() - p.getY());
	int rDistance = m_R * m_R;

	if (rDistance == distance)
		cout << "��Ա������������Բ��" << endl;
	else if (rDistance > distance)
		cout << "��Ա������������Բ��" << endl;
	else
		cout << "��Ա������������Բ��" << endl;
}
