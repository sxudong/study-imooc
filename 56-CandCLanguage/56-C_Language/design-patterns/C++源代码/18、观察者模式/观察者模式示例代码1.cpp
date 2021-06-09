#include <iostream>
using namespace std;
#include "vector"
#include "string"

class Secretary;

//玩游戏的同事类（观察者）
class PlayserObserver
{
public:
	PlayserObserver(string name, Secretary *secretary)
	{
		m_name = name;
		m_secretary = secretary;
	}
	void update(string action)
	{
		cout << "观察者收到action:" << action << endl;
	}
private:
	string		m_name;
	Secretary	*m_secretary;
};

//秘书类（主题对象，通知者）
class Secretary
{
public:
	void addObserver(PlayserObserver *o)
	{
		v.push_back(o);
	}
	void Notify(string action)
	{
		for (vector<PlayserObserver *>::iterator it = v.begin(); it != v.end(); it++)
		{
			(*it)->update(action);
		}
	}
	void setAction(string action)
	{
		m_action = action;
		Notify(m_action);
	}
private:
	string m_action;
	vector<PlayserObserver *> v;
};

void main()
{
	//subject 被观察者
	Secretary *s1 = new Secretary;

	//具体的观察者 被通知对象
	PlayserObserver *po1 = new PlayserObserver("小张", s1);
	//PlayserObserver *po2 = new PlayserObserver("小李", s1);
	s1->addObserver(po1);
	//s1->addObserver(po2);
	s1->setAction("老板来了");
	s1->setAction("老板走了");
	cout << "hello..." << endl;
	system("pause");
	return;
}