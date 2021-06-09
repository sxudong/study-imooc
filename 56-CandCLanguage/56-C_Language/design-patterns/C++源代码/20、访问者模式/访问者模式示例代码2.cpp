#include <iostream>
using namespace std;
#include "string"
#include "list"

//�ͻ�ȥ���а���ҵ��
//m���ͻ�
//n����Ա 

//��Ҫ �����Ҫ����Ĳ����ֿ�����ͬ�Ĺ�Ա���԰���ͬ�����ߵ�ҵ��

class Element;

//�����߷��ʹ�Ա 
class Visitor
{
public:
	virtual void visit(Element *element) = 0;
};


//��Ա���ܿͻ�����
class Element
{
public:
	virtual void accept(Visitor *v) = 0;
	virtual string getName() = 0;
};

//��ԱA Ա��
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

//��ԱB Ա��
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
		cout << "ͨ��" << element->getName() << "��Aҵ��" << endl;
	}
};

class VisitorB : public Visitor
{
public:
	virtual void visit(Element *element)
	{
		cout << "ͨ��" << element->getName() << "��Bҵ��" << endl;
	}
};

void main26_01()
{
	EmployeeA *eA = new EmployeeA("��ԱA");

	VisitorA *vA = new VisitorA;
	VisitorB *vB = new VisitorB;

	eA->accept(vA);
	eA->accept(vB);

	delete eA;
	delete vA;
	delete vB;
	return;
}

//��ԱB Ա��
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
	EmployeeA *eA = new EmployeeA("��ԱA");
	EmployeeA *eB = new EmployeeA("��ԱB");

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