#include <iostream>
using namespace std;

class SystemA
{
public:
	void doThing()
	{
		cout << "systemA do...." << endl;
	}
};

class SystemB
{
public:
	void doThing()
	{
		cout << "systemA do...." << endl;
	}
};

class SystemC
{
public:
	void doThing()
	{
		cout << "systemA do...." << endl;
	}
};

class Facade
{
public:
	Facade()
	{
		a = new SystemA;
		b = new SystemB;
		c = new SystemC;
	}
	~Facade()
	{
		delete a;
		delete b;
		delete c;
	}

	void doThing()
	{
		a->doThing();
		b->doThing();
		c->doThing();
	}

protected:
private:
	SystemA *a;
	SystemB *b;
	SystemC *c;
};


void main()
{
	/*
	SystemA *a = new SystemA;
	SystemB *b = new SystemB;
	SystemC *c = new SystemC;

	a->doThing();
	b->doThing();
	c->doThing();

	delete a;
	delete b;
	delete c;
	*/

	Facade *f = new Facade;
	f->doThing();
	delete f;
	cout << "hello..." << endl;
	system("pause");
	return;
}