#include <iostream>
using namespace std;

class Fruit
{
public:
	virtual void getFruit() = 0;

protected:
private:
};


class Banana : public Fruit
{
public:
	virtual void getFruit()
	{
		cout << "Ïã½¶" << endl;

	}
protected:
private:
};


class Apple : public Fruit
{
public:
	virtual void getFruit()
	{
		cout << "Æ»¹û" << endl;

	}
protected:
private:
};

class Factory
{
public:
	static Fruit* Create(char *name)
	{
		if (strcmp(name, "apple") == 0)
		{
			return new Apple;
		}
		else if (strcmp(name, "banana") == 0)
		{
			return new Banana();
		}
		else
		{
			return nullptr;
		}
	}
protected:
private:
};

void main()
{
	Fruit *pear = Factory::Create("apple");
	if (pear == NULL)
	{
		cout << "´´½¨appleÊ§°Ü\n";
	}
	pear->getFruit();

	Fruit *banana = Factory::Create("banana");
	banana->getFruit();

	delete pear;
	delete banana;

	system("pause");
}