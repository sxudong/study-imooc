#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
5 thisָ��ʹ��
	5.1	ָ����Զָ��ǰ����
	5.2	���������ͻ
	5.3 * this ָ�������
	5.4	�Ǿ�̬�ĳ�Ա��������thisָ��
*/


/*
* this���Խ��������ͻ
*/
class Person
{
public:
	//Person(Person * this, int age) //��������͵͵���롰Person * this����this����Ϊ���ز������ݸ�������
	Person(int age)
	{
		this->age = age;
		//(*this).age = age; //����һ��
	}

	//�Ա�����
	void compareAge( Person & p)
	{
		if (this->age == p.age )
			cout << "�������" << endl;
		else
			cout << "���䲻���" << endl;
	}

	//�������
	//Person& PlusAge(Person * this, Person & p)
	 Person & PlusAge(Person & p) //��������Ϊ�����á�,��˼�߷��ص��ǵ��ö�����
	{
		 this->age += p.age;
		 //ÿ����Ա����(�������Ա)����һ��thisָ�롣��this��ָ��ָ����ö������������Ҫ���á��������ö��󡱣������ʹ�ñ��ʽ��*this����
		 //Ҫ���صĲ�����this����Ϊthis�Ƕ����ַ�������Ƕ������� *this��(��������������)
		 //���Խ� *this ��Ϊ���ö���ı��������ǰ��ķ������塣
		 return *this;
	}

	int age;
};

void test01()
{
	Person p1(10);

	cout << "p1������" << p1.age << endl;

	Person p2(10);

	p1.compareAge(p2);

	p1.PlusAge(p2).PlusAge(p2).PlusAge(p2); //��ʽ���

	cout << "p1������" << p1.age << endl;
}



int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1������10
�������
p1������40
�밴���������. . .
*/