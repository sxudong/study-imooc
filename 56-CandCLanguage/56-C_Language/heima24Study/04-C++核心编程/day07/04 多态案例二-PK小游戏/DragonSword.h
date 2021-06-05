#pragma once 
#include <iostream>
#include "Weapon.h"
#include <string>
using namespace std;

/*
* 屠龙刀
*/
class DragonSword : public Weapon //继承自武器
{
public:
	DragonSword();

	//获取基础伤害
	virtual int getBaseDamage() ;

	//获取吸血
	virtual int getSuckBlood();

	//获取是否定身
	virtual bool getHold();

	//获取是否暴击
	virtual bool getCrit();

	//  吸血率  定身率 暴力率
	int suckRate;
	int holdRate;
	int critRate;

	//传入概率 判断是否触发
	bool isTrigger(int rate);
};