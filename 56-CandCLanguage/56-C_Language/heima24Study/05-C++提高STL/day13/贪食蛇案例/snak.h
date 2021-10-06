#pragma  once
#include <iostream>
#include "wall.h"
#include "food.h"
using namespace std;

/*
* 蛇
*/
class Snake
{
public:
	//节点
	struct Point
	{
		//数据域
		int x;
		int y;
		//指针域
		Point* next;
	};

	Wall& wall;
	Food& food;
	bool isRool;  //判断循环标示
	Point* pHead;

	Snake(Wall & tempWall, Food & food );

	enum { UP = 'w', DOWN = 's', LEFT = 'a' , RIGHT = 'd'};

	//初始化蛇
	void initSnake();

	// 销毁节点
	void destroyPoint();

	// 添加节点
	void addPoint(int x,int y);

	// 删除节点
	void delPoint();

	//移动蛇操作
	bool move(char key); //返回值代表 移动是否成功

	//设定难度
	int getSleepTime();  //获取刷屏时间

	int countList();     //获取蛇身段

	int getScore();      //获取分数
};
