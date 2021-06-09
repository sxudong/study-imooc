#include <iostream>
using namespace std;

class MyCar1
{
public:
	virtual void installEngine() = 0;
};

class BMW5 : public MyCar1
{
public:
	virtual void installEngine()
	{
		cout << "BMW5 3500CC" << endl;
	}
};

class BMW6 : public MyCar1
{
public:
	virtual void installEngine()
	{
		cout << "BMW6 4000CC" << endl;
	}
};


class Jeep11 : public MyCar1
{
public:
	virtual void installEngine()
	{
		cout << "Jeep11 1100CC" << endl;
	}
};


class Jeep12 : public MyCar1
{
public:
	virtual void installEngine()
	{
		cout << "Jeep12 1200CC" << endl;
	}
};

//不同的车型，不同型号，安装不同类型的发动机，会引起子类的泛滥
//问题引出
void main1601()
{
	Jeep12 *j12 = new Jeep12;
	j12->installEngine();
	delete j12;
	return;
}

class MyCar2
{

public:
	virtual void installEngine3500() = 0;
	virtual void installEngine4000() = 0;
	virtual void installEngine1100() = 0;
	virtual void installEngine1200() = 0;
};

class BMW : public MyCar2
{
public:
	virtual void installEngine3500()
	{
		cout << "3500CC" << endl;
	}
	virtual void installEngine4000()
	{
		cout << "4000CC" << endl;
	}
	virtual void installEngine1100()
	{
		cout << "1100CC" << endl;
	}
	virtual void installEngine1200()
	{
		cout << "1200CC" << endl;
	}
};

//这样的设计 不符合开闭原则
void main1602()
{
	BMW *bmw5 = new BMW;
	bmw5->installEngine3500();
}

//需要把“安装发动机”这个事，做很好的分解；把抽象 和 行为实现 分开
//发动机是一个名次，专门抽象成一个类；类中含有一个成员函数，安装发动机

class Engine
{
public:
	virtual void installEngine() = 0;
};

class Engine4000 : public Engine
{
public:
	virtual void installEngine()
	{
		cout << "安装发动机 Engine4000" << endl;
	}
};

class Engine3500 : public Engine
{
public:
	virtual void installEngine()
	{
		cout << "安装发动机 Engine 3500" << endl;
	}
};

class Car
{
public:
	Car(Engine *pengine)
	{
		m_engine = pengine;
	}
	virtual void installEngine() = 0;

protected:
	Engine *m_engine;
};

class BMW7 :public Car
{
public:
	BMW7(Engine *p) : Car(p)
	{

	}

	//注意车的安装  和 发动机的安装 不同之处
	virtual void installEngine()
	{
		cout << "BMW7 ";
		m_engine->installEngine();
	}
protected:
private:
};

void main163()
{
	Engine4000 *e4000 = new Engine4000;
	BMW7 *bmw7 = new BMW7(e4000);
	bmw7->installEngine();

	delete bmw7;
	delete e4000;
}
void main()
{
	//main1601();
	//main1602();
	main163();
	system("pause");
}