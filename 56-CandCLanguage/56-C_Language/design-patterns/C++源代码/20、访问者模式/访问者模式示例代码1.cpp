#include <iostream>
using namespace std;
#include "list"
#include "string"

class  ParkElement;

//不同的访问者 访问公园完成不同的动作 
class Visitor
{
public:
	virtual void visit(ParkElement *park) = 0;
};

class ParkElement //每一个
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
		cout << "清洁工A访问公园A部分，打扫卫生完毕" << endl;
	}
};

class VisitorB : public Visitor
{
public:
	virtual void visit(ParkElement *park)
	{
		cout << "清洁工B 访问 公园B 部分，打扫卫生完毕" << endl;
	}
};
class VisitorManager : public Visitor
{
public:
	virtual void visit(ParkElement *park)
	{
		cout << "管理员 检查整个公园卫生打扫情况" << endl;
	}
};

void main()
{
	VisitorA *visitorA = new VisitorA;
	VisitorB *visitorB = new VisitorB;

	ParkA *partA = new ParkA;
	ParkB *partB = new ParkB;

	//公园接受访问者a访问
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