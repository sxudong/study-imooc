#pragma once 
#include <iostream>
#include "Weapon.h"
#include <string>
#include "Hero.h"
using namespace std;

class Hero; //Ӣ��

/*
* ����ӿ�
*/
class Monster
{
public:
	Monster();      //���캯��

	string m_Name;  //������

	int m_Hp;       //Ѫ��

	int m_Atk;      //������

	int m_Def;      //������

	bool m_Hold;    //�Ƿ���

	//����
	void Attack(Hero * hero);
};