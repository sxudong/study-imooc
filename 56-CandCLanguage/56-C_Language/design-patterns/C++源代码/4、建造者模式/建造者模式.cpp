#include <iostream>
using namespace std;

#include <String>

class House
{
public:
	void setFloor(string floor)
	{
		this->m_floor = floor;
	}
	void setWall(string wall)
	{
		this->m_wall = wall;
	}
	void setDoor(string door)
	{
		this->m_door = door;
	}

	//
	string getFloor()
	{
		return m_floor;
	}
	string gettWall()
	{
		return  m_wall;
	}
	string getDoor()
	{
		return m_door;
	}

protected:
private:
	string	m_floor;
	string	m_wall;
	string	m_door;
};
// �����߻���
class Builder
{
public:
	virtual void makeFloor() = 0;
	virtual void makeWall() = 0;
	virtual void makeDoor() = 0;
	virtual House *GetHouse() = 0;
};
// ��Ԣ���̶�
//��Ԣ
class FlatBuild : public Builder
{
public:
	FlatBuild()
	{
		pHouse = new House;
	}
	virtual void makeFloor()
	{
		pHouse->setFloor("flat Door");
	}
	virtual void makeWall()
	{
		pHouse->setWall("flat Wall");
	}
	virtual void makeDoor()
	{
		pHouse->setDoor("flat Door");
	}
	virtual House *GetHouse()
	{
		return pHouse;
	}

private:
	House *pHouse;
};
// �������̶�
class VillaBuild : public Builder
{
public:
	VillaBuild()
	{
		pHouse = new House;
	}
	virtual void makeFloor()
	{
		pHouse->setFloor("villa floor");
	}
	virtual void makeWall()
	{
		pHouse->setWall("villa Wall");
	}
	virtual void makeDoor()
	{
		pHouse->setDoor("villa Door");
	}
	virtual House *GetHouse()
	{
		return pHouse;
	}
private:
	House *pHouse;
};

// ���ʦ�� ����ָ�ӽ����߼�
// �������� ����ȥ����
class Director
{
public:
	void Construct(Builder *builder)
	{
		builder->makeFloor();
		builder->makeWall();
		builder->makeDoor();
	}
protected:
private:
};

int main(){
	/*//�ͻ�ֱ���췿��
	House *pHose = new House;
	pHose->setDoor("wbm��");
	pHose->setFloor("wbmFloor");
	pHose->setWall("wbmWall");
	delete pHose;*/


	/* //���̶�ֱ���췿��
	Builder *builder = new FlatBuild;
	builder->makeFloor();
	builder->makeWall();
	builder->makeDoor();
	*/

	//ָ���ߣ����ʦ��ָ�� ���̶� �� ������
	Director *director = new Director;

	//����Ԣ
	Builder *builder = new FlatBuild;
	director->Construct(builder); //���ʦ ָ�� ���̶Ӹɻ�
	House *house = builder->GetHouse();
	cout << house->getFloor() << endl;
	delete house;
	delete builder;

	//������
	builder = new VillaBuild;
	director->Construct(builder); //���ʦ ָ�� ���̶Ӹɻ�
	house = builder->GetHouse();
	cout << house->getFloor() << endl;
	delete house;
	delete builder;

	delete director;

	system("pause");
	return 0;
}

