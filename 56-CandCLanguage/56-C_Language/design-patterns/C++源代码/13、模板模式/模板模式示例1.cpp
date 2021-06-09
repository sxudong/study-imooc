#include <iostream>
using namespace std;

class MakeCar
{
public:
	virtual void makeHead() = 0;
	virtual void makeBody() = 0;
	virtual void makeTail() = 0;

public:   //把一组行为 变成 一个模板
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
		cout << "bus 组装 车头" << endl;
	}
	virtual void makeBody()
	{
		cout << "bus 组装 车身" << endl;
	}
	virtual void makeTail()
	{
		cout << "bus 组装 车尾" << endl;
	}
protected:
private:
};

class MakeJeep : public MakeCar
{
public:
	virtual void makeHead()
	{
		cout << "Jeep 组装 车头" << endl;
	}
	virtual void makeBody()
	{
		cout << "Jeep 组装 车身" << endl;
	}
	virtual void makeTail()
	{
		cout << "Jeep 组装 车尾" << endl;
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