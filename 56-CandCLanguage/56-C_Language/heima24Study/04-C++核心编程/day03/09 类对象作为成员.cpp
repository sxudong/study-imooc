#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
9 �������Ϊ��Ա�İ���
    9.1	���������Ϊ��ĳ�Աʱ�򣬹���˳�����ȹ��������Ĺ��죬Ȼ�����Լ���
    9.2	����˳���빹���෴
*/


class Phone
{
public:
	Phone()
	{
		cout << "�ֻ���Ĭ�Ϲ��캯������" << endl;
	}

	Phone(string name)
	{
		cout << "�ֻ����вι������" << endl;
		m_PhoneName = name;
	}

	~Phone()
	{
		cout << "�ֻ���������������" << endl;
	}

	string m_PhoneName;

};

class Game
{
public:
	Game()
	{
		cout << "Game��Ĭ�Ϲ��캯������" << endl;
	}

	Game(string name)
	{
		cout << "Game���вι������" << endl;
		m_GameName = name;
	}

	~Game()
	{
		cout << "Game��������������" << endl;
	}

	string m_GameName;

};

class Person
{
public:
	Person()
	{
		cout << "Person��Ĭ�Ϲ��캯������" << endl;
	}

	//���á���ʼ���б���ʼ������
	Person(string name, string phoneName, string gameName) : m_Name(name), m_Phone(phoneName), m_Game(gameName)
	{
		cout << "Person���вι������" << endl;
		//m_Name = name;
	}

	void playGame()
	{
		cout << m_Name << " ���š�" << m_Phone.m_PhoneName << "�����ֻ� �����š�" << m_Game.m_GameName << "����Ϸ" << endl;
	}

	~Person()
	{
		cout << "Person��������������" << endl;
	}

	string m_Name; //����
	Phone m_Phone; //�ֻ�  //�������Ϊ��Ա
	Game m_Game;   //��Ϸ  //�������Ϊ��Ա
};

/*
* ���������Ϊ�����Ա��ʱ��
*      �����족˳���Ƚ������һһ���죬Ȼ�����Լ���
*      ����������˳�����෴�ġ�
*/
void test01()
{
	Person p("����","ƻ��","��ˮ��");
	p.playGame();
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�ֻ����вι������
Game���вι������
Person���вι������
���� ���š�ƻ�������ֻ� �����š���ˮ������Ϸ
Person��������������
Game��������������
�ֻ���������������
�밴���������. . .
*/