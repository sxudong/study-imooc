#pragma once 
#include <iostream>
#include "Weapon.h"
#include <string>
#include "Monster.h"
using namespace std;

class Monster; //����

/*
* Ӣ�۽ӿ�
*/
class Hero
{
public:
	Hero();         //���캯��

	string m_Name;   //����

	int m_Atk;       //������

	int m_Def;       //������

	int m_Hp;        //Ѫ��

	Weapon * weapon; //����

	//װ������
	void EquipWeapon(Weapon * weapon);

	//����
	void Attack( Monster * monster );
};