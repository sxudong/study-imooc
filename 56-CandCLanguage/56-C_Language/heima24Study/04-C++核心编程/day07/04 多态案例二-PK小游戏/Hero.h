#pragma once 
#include <iostream>
#include "Weapon.h"
#include <string>
#include "Monster.h"
using namespace std;

class Monster; //怪物

/*
* 英雄接口
*/
class Hero
{
public:
	Hero();         //构造函数

	string m_Name;   //人名

	int m_Atk;       //攻击力

	int m_Def;       //防御力

	int m_Hp;        //血量

	Weapon * weapon; //武器

	//装备武器
	void EquipWeapon(Weapon * weapon);

	//攻击
	void Attack( Monster * monster );
};