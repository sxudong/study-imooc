#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
9 类对象作为成员的案例
    9.1	当类对象作为类的成员时候，构造顺序是先构造类对象的构造，然后构造自己，
    9.2	析构顺序与构造相反
*/


class Phone
{
public:
	Phone()
	{
		cout << "手机的默认构造函数调用" << endl;
	}

	Phone(string name)
	{
		cout << "手机的有参构造调用" << endl;
		m_PhoneName = name;
	}

	~Phone()
	{
		cout << "手机的析构函数调用" << endl;
	}

	string m_PhoneName;

};

class Game
{
public:
	Game()
	{
		cout << "Game的默认构造函数调用" << endl;
	}

	Game(string name)
	{
		cout << "Game的有参构造调用" << endl;
		m_GameName = name;
	}

	~Game()
	{
		cout << "Game的析构函数调用" << endl;
	}

	string m_GameName;

};

class Person
{
public:
	Person()
	{
		cout << "Person的默认构造函数调用" << endl;
	}

	//利用“初始化列表”初始化数据
	Person(string name, string phoneName, string gameName) : m_Name(name), m_Phone(phoneName), m_Game(gameName)
	{
		cout << "Person的有参构造调用" << endl;
		//m_Name = name;
	}

	void playGame()
	{
		cout << m_Name << " 拿着《" << m_Phone.m_PhoneName << "》牌手机 ，玩着《" << m_Game.m_GameName << "》游戏" << endl;
	}

	~Person()
	{
		cout << "Person的析构函数调用" << endl;
	}

	string m_Name; //姓名
	Phone m_Phone; //手机  //类对象做为成员
	Game m_Game;   //游戏  //类对象做为成员
};

/*
* “类对象”作为“类成员”时候，
*      “构造”顺序先将类对象一一构造，然后构造自己，
*      “析构”的顺序是相反的。
*/
void test01()
{
	Person p("狗蛋","苹果","切水果");
	p.playGame();
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
手机的有参构造调用
Game的有参构造调用
Person的有参构造调用
狗蛋 拿着《苹果》牌手机 ，玩着《切水果》游戏
Person的析构函数调用
Game的析构函数调用
手机的析构函数调用
请按任意键继续. . .
*/