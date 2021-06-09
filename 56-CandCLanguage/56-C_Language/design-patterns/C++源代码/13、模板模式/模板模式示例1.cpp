#include <iostream>
using namespace std;

class MakeCar
{
public:
	virtual void makeHead() = 0;
	virtual void makeBody() = 0;
	virtual void makeTail() = 0;

public:   //��һ����Ϊ ��� һ��ģ��
	void make()
	{
		makeHead();
		makeBody();
		makeTail();
	}

protected:
private:
};

class MakeBus : public MakeCar
{
public:
	virtual void makeHead()
	{
		cout << "bus ��װ ��ͷ" << endl;
	}
	virtual void makeBody()
	{
		cout << "bus ��װ ����" << endl;
	}
	virtual void makeTail()
	{
		cout << "bus ��װ ��β" << endl;
	}
protected:
private:
};

class MakeJeep : public MakeCar
{
public:
	virtual void makeHead()
	{
		cout << "Jeep ��װ ��ͷ" << endl;
	}
	virtual void makeBody()
	{
		cout << "Jeep ��װ ����" << endl;
	}
	virtual void makeTail()
	{
		cout << "Jeep ��װ ��β" << endl;
	}
protected:
private:
};

void main()
{
	MakeCar *bus = new MakeBus;

	//bus->makeHead();
	//bus->makeBody();
	//bus->makeTail();
	bus->make();

	MakeCar *jeep = new MakeJeep;
	//jeep->makeHead();
	//jeep->makeBody();
	//jeep->makeTail();
	jeep->make();

	delete bus;
	delete jeep;

	cout << "hello..." << endl;
	system("pause");
	return;
}