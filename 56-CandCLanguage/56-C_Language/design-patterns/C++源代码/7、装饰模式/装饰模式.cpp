#include <iostream>
using namespace std;

class Car
{
public:
	virtual void show() = 0;
protected:
private:
};

class RunCar : public Car
{
public:
	void run()
	{
		cout << "������" << endl;
	}
	virtual void show()
	{
		run();
	}
protected:
private:
};

class SwimCarDirector : public Car
{
public:
	SwimCarDirector(Car *p)
	{
		m_p = p;
	}

	void swim()
	{
		cout << "������" << endl;
	}

	virtual void show()
	{
		m_p->show();
		swim();
	}
private:
	Car *m_p;
};

class FlyCarDirector : public Car
{
public:
	FlyCarDirector(Car *p)
	{
		m_p = p;
	}

	void fly()
	{
		cout << "���Է�" << endl;
	}
	virtual void show()
	{
		m_p->show();
		fly();
	}
private:
	Car *m_p;
};

void main()
{
	Car *runcar = NULL;
	runcar = new RunCar;
	runcar->show();

	cout << "����ʼװ��swim" << endl;
	SwimCarDirector *swimCar = new SwimCarDirector(runcar);
	swimCar->show();

	cout << "����ʼװ��fly" << endl;
	FlyCarDirector *flyCar = new FlyCarDirector(swimCar);
	flyCar->show();

	delete flyCar;
	delete swimCar;
	delete runcar;

	return;
}