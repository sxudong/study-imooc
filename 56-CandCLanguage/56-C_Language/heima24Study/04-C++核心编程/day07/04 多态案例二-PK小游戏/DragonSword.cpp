#include "DragonSword.h"


/*
* 屠龙刀实现
*/
DragonSword::DragonSword(){
	this->m_BaseDamage = 20;
	this->m_WeaponName = "屠龙宝刀";
	this->suckRate = 20;
	this->holdRate = 30;
	this->critRate = 35;

}

//获取基础伤害
int DragonSword::getBaseDamage(){
	return this->m_BaseDamage;
}

//获取吸血
int DragonSword::getSuckBlood(){
	if (isTrigger(suckRate))
		return this->m_BaseDamage * 0.5;  //按照武器基础伤害一半吸血
	return 0;
}

//获取是否定身
bool DragonSword::getHold(){
	if (isTrigger(holdRate))
		return true;
	return false;
}

//获取是否暴击
bool DragonSword::getCrit(){
	if (isTrigger(critRate))
		return true;
	return false;
}

//传入概率 判断是否触发
bool DragonSword::isTrigger(int rate){

	//通过isTrigger判断是否触发特效
	//随机 1~100的数字

	int num = rand() % 100 + 1;
	if (num < rate)
		return true;
	return false;
}
