#include "DragonSword.h"


/*
* ������ʵ��
*/
DragonSword::DragonSword(){
	this->m_BaseDamage = 20;
	this->m_WeaponName = "��������";
	this->suckRate = 20;
	this->holdRate = 30;
	this->critRate = 35;

}

//��ȡ�����˺�
int DragonSword::getBaseDamage(){
	return this->m_BaseDamage;
}

//��ȡ��Ѫ
int DragonSword::getSuckBlood(){
	if (isTrigger(suckRate))
		return this->m_BaseDamage * 0.5;  //�������������˺�һ����Ѫ
	return 0;
}

//��ȡ�Ƿ���
bool DragonSword::getHold(){
	if (isTrigger(holdRate))
		return true;
	return false;
}

//��ȡ�Ƿ񱩻�
bool DragonSword::getCrit(){
	if (isTrigger(critRate))
		return true;
	return false;
}

//������� �ж��Ƿ񴥷�
bool DragonSword::isTrigger(int rate){

	//ͨ��isTrigger�ж��Ƿ񴥷���Ч
	//��� 1~100������

	int num = rand() % 100 + 1;
	if (num < rate)
		return true;
	return false;
}
