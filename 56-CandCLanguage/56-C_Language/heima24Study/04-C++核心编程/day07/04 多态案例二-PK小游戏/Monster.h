#pragma once 
#include <iostream>
#include "Weapon.h"
#include <string>
#include "Hero.h"
using namespace std;

class Hero; //英雄

/*
* 怪物接口
*/
class Monster
{
public:
	Monster();      //构造函数

	string m_Name;  //怪物名

	int m_Hp;       //血量

	int m_Atk;      //攻击力

	int m_Def;      //防御力

	bool m_Hold;    //是否定身

	//攻击
	void Attack(Hero * hero);
};