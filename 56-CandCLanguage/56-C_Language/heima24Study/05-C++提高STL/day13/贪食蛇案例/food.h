#pragma  once
#include <iostream>
#include "wall.h"
using namespace std; //使用空间

/*
* 食物
*/
class Food
{
public:
	int foodX;
	int foodY;
	Wall& wall;

	Food(Wall & tempWall);

	//设置食物
	void setFood();
};

