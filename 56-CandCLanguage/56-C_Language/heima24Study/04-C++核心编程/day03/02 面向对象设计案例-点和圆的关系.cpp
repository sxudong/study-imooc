#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "circle.h"
#include "point.h"

/*
����
  ���һ��Բ���ࣨAdvCircle������һ�����ࣨPoint����������Բ�Ĺ�ϵ��
  ����Բ������Ϊx0, y0, �뾶Ϊr���������Ϊx1, y1

   1������Բ�ϣ�(x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) == r*r
   2������Բ�ڣ�(x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) < r*r
   3������Բ�⣺(x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) > r*r
*/

//����ȫ�ֺ��� �жϵ��Բ�Ĺ�ϵ
void isInCircle(Circle & c,Point &p)
{
	//��ȡԲ�ĺ͵�ľ��루distance�� ��ƽ��
	int distance = (c.getCenter().getX() - p.getX()) * (c.getCenter().getX() - p.getX())    +    (c.getCenter().getY() - p.getY()) * (c.getCenter().getY() - p.getY());
	int rDistance = c.getR() * c.getR(); //Բ�����

	if (rDistance == distance)
		cout << "����Բ��" << endl;
	else if ( rDistance > distance)
		cout << "����Բ��" << endl;
	else
		cout << "����Բ��" << endl;
}

void test01()
{
	//��
	Point p1;
	p1.setX(10);
	p1.setY(11);

	//Բ��
	Point center;
	center.setX(10);
	center.setY(0);

	//Բ
	Circle c1;
	c1.setCenter(center);
	c1.setR(10);

	//���á�ȫ�ֺ������жϡ��㡱�͡�Բ���Ĺ�ϵ
	isInCircle(c1, p1);

	//���á���Ա�������жϡ��㡱�͡�Բ���Ĺ�ϵ
	c1.isInCircleByClass(p1);

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
����Բ��
��Ա������������Բ��
�밴���������. . .
*/
