#include "Knife.h"

/*
* С��ʵ��
*/
Knife::Knife(){
	this->m_BaseDamage = 10;

	this->m_WeaponName = "С��";
}

//��ȡ�����˺�
int Knife::getBaseDamage(){
	return this->m_BaseDamage;
}

//��ȡ��Ѫ
int Knife::getSuckBlood(){
	return 0;
}

//��ȡ�Ƿ���
bool Knife::getHold(){
	return false;
}

//��ȡ�Ƿ񱩻�
bool Knife::getCrit(){
	return false;
}