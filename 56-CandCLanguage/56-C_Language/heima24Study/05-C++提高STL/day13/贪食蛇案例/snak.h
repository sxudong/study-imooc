#pragma  once
#include <iostream>
#include "wall.h"
#include "food.h"
using namespace std;

/*
* ��
*/
class Snake
{
public:
	//�ڵ�
	struct Point
	{
		//������
		int x;
		int y;
		//ָ����
		Point* next;
	};

	Wall& wall;
	Food& food;
	bool isRool;  //�ж�ѭ����ʾ
	Point* pHead;

	Snake(Wall & tempWall, Food & food );

	enum { UP = 'w', DOWN = 's', LEFT = 'a' , RIGHT = 'd'};

	//��ʼ����
	void initSnake();

	// ���ٽڵ�
	void destroyPoint();

	// ��ӽڵ�
	void addPoint(int x,int y);

	// ɾ���ڵ�
	void delPoint();

	//�ƶ��߲���
	bool move(char key); //����ֵ���� �ƶ��Ƿ�ɹ�

	//�趨�Ѷ�
	int getSleepTime();  //��ȡˢ��ʱ��

	int countList();     //��ȡ�����

	int getScore();      //��ȡ����
};
