#include <iostream>
using namespace std;
class CarHandle
{
public:
	virtual void HandleCar() = 0;

public:
	CarHandle *setNextHandle(CarHandle *carhandle)
	{
		this->carhandle = carhandle;
		return this->carhandle;
	}
protected:
	CarHandle *carhandle;
};

class CarHandleHead : public CarHandle
{
public:
	virtual void HandleCar()
	{
		cout << "����ͷ" << endl;
		if (this->carhandle != NULL)
		{
			carhandle->HandleCar();
		}
	}
};

class CarHandleBody : public CarHandle
{
public:
	virtual void HandleCar()
	{
		cout << "������" << endl;
		if (this->carhandle != NULL)
		{
			carhandle->HandleCar();
		}
	}
};

class CarHandleTail : public CarHandle
{
public:
	virtual void HandleCar()
	{
		cout << "����β" << endl;
		if (this->carhandle != NULL)
		{
			carhandle->HandleCar();
		}
	}
};

void main()
{
	CarHandleHead *head = new CarHandleHead;
	CarHandleBody *body = new CarHandleBody;
	CarHandleTail *tail = new CarHandleTail;

	head->setNextHandle(body);
	body->setNextHandle(tail);
	tail->setNextHandle(NULL);

	//����
	head->HandleCar();
	delete head;
	delete body;
	delete tail;
	system("pause");
	return;
}