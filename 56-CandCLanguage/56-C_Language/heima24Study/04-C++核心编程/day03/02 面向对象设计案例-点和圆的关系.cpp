#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "circle.h"
#include "point.h"

/*
需求：
  设计一个圆形类（AdvCircle），和一个点类（Point），计算点和圆的关系。
  假如圆心坐标为x0, y0, 半径为r，点的坐标为x1, y1

   1）点在圆上：(x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) == r*r
   2）点在圆内：(x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) < r*r
   3）点在圆外：(x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) > r*r
*/

//利用全局函数 判断点和圆的关系
void isInCircle(Circle & c,Point &p)
{
	//获取圆心和点的距离（distance） 的平方
	int distance = (c.getCenter().getX() - p.getX()) * (c.getCenter().getX() - p.getX())    +    (c.getCenter().getY() - p.getY()) * (c.getCenter().getY() - p.getY());
	int rDistance = c.getR() * c.getR(); //圆的面积

	if (rDistance == distance)
		cout << "点在圆上" << endl;
	else if ( rDistance > distance)
		cout << "点在圆内" << endl;
	else
		cout << "点在圆外" << endl;
}

void test01()
{
	//点
	Point p1;
	p1.setX(10);
	p1.setY(11);

	//圆心
	Point center;
	center.setX(10);
	center.setY(0);

	//圆
	Circle c1;
	c1.setCenter(center);
	c1.setR(10);

	//利用“全局函数”判断“点”和“圆”的关系
	isInCircle(c1, p1);

	//利用“成员函数”判断“点”和“圆”的关系
	c1.isInCircleByClass(p1);

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
点在圆外
成员函数：：点在圆外
请按任意键继续. . .
*/
