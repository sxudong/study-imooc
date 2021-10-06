#include "Knife.h"

/*
* 小刀实现
*/
Knife::Knife(){
	this->m_BaseDamage = 10;

	this->m_WeaponName = "小刀";
}

//获取基础伤害
int Knife::getBaseDamage(){
	return this->m_BaseDamage;
}

//获取吸血
int Knife::getSuckBlood(){
	return 0;
}

//获取是否定身
bool Knife::getHold(){
	return false;
}

//获取是否暴击
bool Knife::getCrit(){
	return false;
}