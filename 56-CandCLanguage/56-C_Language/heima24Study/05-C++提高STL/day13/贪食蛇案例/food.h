#pragma  once
#include <iostream>
#include "wall.h"
using namespace std; //ʹ�ÿռ�

/*
* ʳ��
*/
class Food
{
public:
	int foodX;
	int foodY;
	Wall& wall;

	Food(Wall & tempWall);

	//����ʳ��
	void setFood();
};
