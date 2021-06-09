#include <iostream>
using namespace std;
#include "list"
#include "string"

class  ParkElement;

//��ͬ�ķ����� ���ʹ�԰��ɲ�ͬ�Ķ��� 
class Visitor
{
public:
	virtual void visit(ParkElement *park) = 0;
};

class ParkElement //ÿһ��
{
public:
	virtual void accept(Visitor *v) = 0;
};

class ParkA : public ParkElement
{
public:
	virtual void accept(Visitor *v)
	{
		v->visit(this);
	}
};

class ParkB : public ParkElement
{
public:
	virtual void accept(Visitor *v)
	{
		v->visit(this);
	}
};

class Park : public ParkElement
{
public:
	Park()
	{
		m_list.clear();
	}
	void setPart(ParkElement *e)
	{
		m_list.push_back(e);
	}
public:
	void accept(Visitor *v)
	{
		for (list<ParkElement *>::iterator it = m_list.begin(); it != m_list.end(); it++)
		{
			(*it)->accept(v);
		}
	}

private:
	list<ParkElement *> m_list;
};

class VisitorA : public Visitor
{
public:
	virtual void visit(ParkElement *park)
	{
		cout << "��๤A���ʹ�԰A���֣���ɨ�������" << endl;
	}
};

class VisitorB : public Visitor
{
public:
	virtual void visit(ParkElement *park)
	{
		cout << "��๤B ���� ��԰B ���֣���ɨ�������" << endl;
	}
};
class VisitorManager : public Visitor
{
public:
	virtual void visit(ParkElement *park)
	{
		cout << "����Ա ���������԰������ɨ���" << endl;
	}
};

void main()
{
	VisitorA *visitorA = new VisitorA;
	VisitorB *visitorB = new VisitorB;

	ParkA *partA = new ParkA;
	ParkB *partB = new ParkB;

	//��԰���ܷ�����a����
	partA->accept(visitorA);
	partB->accept(visitorB);

	VisitorManager *visitorManager = new VisitorManager;
	Park * park = new Park;
	park->setPart(partA);
	park->setPart(partB);
	park->accept(visitorManager);

	cout << "hello..." << endl;
	system("pause");
	return;
}