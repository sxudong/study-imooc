#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
4 ����ָ��ʵ��
	4.1	Person����showAge ��Ա����
	4.2	���new������Person���󣬾�Ҫ�ó���Ա�Ծ���ȥ�ͷ�  delete
	4.3	��������ָ�룬������ָ���й����Person���󣬶�����ͷžͲ��ò����ˣ�������ָ�����
	4.4	Ϊ��������ָ������ͨ��Person * ָ��һ��ʹ�� ��Ҫ���� -> �� *
*/


class Person
{
public:
	Person(int age)
	{
		this->m_Age = age;
	}

	void showAge()
	{
		cout << "����Ϊ��" << this->m_Age << endl;
	}

	~Person()
	{
		cout << "Person����������" << endl;
	}

	int m_Age;
};



/*
* ����ָ��
* �����й��Զ������͵Ķ����ö�������Զ����ͷš�
*/
class SmartPointer
{
private:
	Person* person;

public:
	SmartPointer(Person * person)
	{
		this->person = person;
	}

	/*
	* ���� -> ������ָ����� �� Person *p һ��ȥʹ��
	*/
	Person * operator-> ()
	{
		return this->person; //����ָ��
	}

	/*
	* ���� *
	*/
	Person & operator* ()
	{
		return *this->person; //��ά��ָ��ı��巵��ȥ
	}

	/*
	* SmartPointer����������
	* ����ָ��������ʱ��˳���� Person �ͷš�
	*/
	~SmartPointer()
	{
		cout << "����ָ��������" << endl;
		if (this->person != NULL){
			delete this->person;
			this->person = NULL;
		}
	}
};

void test01()
{
	//1.�Զ�����
	//Person p1(10);

	//2.Person����������
	//new������Person���󣬾�Ҫ�ó���Ա�Ծ���ȥ�ͷ� delete
	//Person * p1 = new Person(10);
	//p1->showAge();
	//delete p1;

	//3.����ָ��
	//����ָ���й����Person���󣬶�����ͷžͲ��ò�����
	SmartPointer sp(new Person(10)); //sp���ٵ���ջ�ϣ�������ջ�ϻ��Զ��ͷ�
	sp->showAge();                   //sp->->showAge(); �������Ż���д����ʹ�����ص�->
	(*sp).showAge();                 //ʹ������ *

}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
����Ϊ��10
����Ϊ��10
����ָ��������
Person����������
�밴���������. . .
*/
