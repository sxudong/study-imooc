#include <iostream>
using namespace std;
#include "string"
#include "list"

//客户去银行办理业务
//m个客户
//n个柜员 

//将要 对象和要处理的操作分开，不同的柜员可以办理不同来访者的业务

class Element;

//访问者访问柜员 
class Visitor
{
public:
	virtual void visit(Element *element) = 0;
};


//柜员接受客户访问
class Element
{
public:
	virtual void accept(Visitor *v) = 0;
	virtual string getName() = 0;
};

//柜员A 员工
class EmployeeA : public Element
{
public:
	EmployeeA(string name)
	{
		m_name = name;
	}
	virtual void accept(Visitor *v)
	{
		v->visit(this);
	}
	virtual string getName()
	{
		return m_name;
	}
private:
	string m_name;
};

//柜员B 员工
class EmployeeB : public Element
{
public:
	EmployeeB(string name)
	{
		m_name = name;
	}
	virtual void accept(Visitor *v)
	{
		v->visit(this);
	}
	string getName()
	{
		return m_name;
	}
private:
	string m_name;
};

class VisitorA : public Visitor
{
public:
	virtual void visit(Element *element)
	{
		cout << "通过" << element->getName() << "做A业务" << endl;
	}
};

class VisitorB : public Visitor
{
public:
	virtual void visit(Element *element)
	{
		cout << "通过" << element->getName() << "做B业务" << endl;
	}
};

void main26_01()
{
	EmployeeA *eA = new EmployeeA("柜员A");

	VisitorA *vA = new VisitorA;
	VisitorB *vB = new VisitorB;

	eA->accept(vA);
	eA->accept(vB);

	delete eA;
	delete vA;
	delete vB;
	return;
}

//柜员B 员工
class Employees : public Element
{
public:
	Employees()
	{
		m_list = new list<Element *>;
	}
	virtual void accept(Visitor *v)
	{
		for (list<Element *>::iterator it = m_list->begin(); it != m_list->end(); it++)
		{
			(*it)->accept(v);
		}
	}
	string getName()
	{
		return m_name;
	}
public:
	void addElement(Element *e)
	{
		m_list->push_back(e);
	}
	void removeElement(Element *e)
	{
		m_list->remove(e);
	}
private:
	list<Element *> *m_list;
	string m_name;

};

void main26_02()
{
	EmployeeA *eA = new EmployeeA("柜员A");
	EmployeeA *eB = new EmployeeA("柜员B");

	Employees *es = new Employees;
	es->addElement(eA);
	es->addElement(eB);
	VisitorA *vA = new VisitorA;
	VisitorB *vB = new VisitorB;

	es->accept(vA);
	cout << "-------------" << endl;
	es->accept(vB);

	delete eA;
	delete eB
		;
	delete vA;
	delete vB;

	return;
}

void main()
{
	//main26_01();
	main26_02();
	system("pause");
}