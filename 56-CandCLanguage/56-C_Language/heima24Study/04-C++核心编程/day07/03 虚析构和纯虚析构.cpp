#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 �������ʹ�������
	5.1	������
		5.1.1 virtual ~����() {}
		5.1.2 ������⣺ ͨ������ָ��ָ����������ͷ�ʱ�򲻸ɾ����µ�����
	5.2	������������
		5.2.1 д��  virtual ~����() = 0
		5.2.2 ��������  ����ʵ��
		5.2.3 ��������˴������������������Ҳ������࣬������ʵ��������
*/


class Animal
{
public:

	virtual void speak(){
		cout << "������˵��" << endl;
	}

	/*
	* ����ͨ�������ǲ����������������ģ����Կ��ܻᵼ���ͷŲ��ɾ���
	* ���á��������������������⡣
	*/

	/*
	* ������
	*/
	//virtual ~Animal()
	//{
	//	cout << "Animal����������" << endl;
	//}


	/*
	* ��������
	*
	* ������������Ҫ����������Ҫʵ�֣���������������ʵ�֡�
	* ��������г����� ����������������ô�����Ҳ������ࡣ������ -> ����ʵ��������
	*/
	virtual ~Animal() = 0;
};

/*
* ����������������ʵ��
*/
Animal::~Animal()
{
	cout << "Animal�Ĵ�����������" << endl;
}


void func()
{
    //������ִ�����������Ҳ������࣬����ʵ��������
	//Animal an;                     //err
	//Animal * animal = new Animal;  //err
}


class Cat : public Animal
{
public:
	char* m_Name;

	//���캯��
	Cat(const char * name){
		this->m_Name = new char[strlen(name) + 1]; //���ٶѿռ�
		strcpy(this->m_Name, name);                //����ֵ
	}

	virtual void speak(){
		cout << "Сè��˵��" << endl;
	}

	~Cat(){
		cout << "Cat����������" << endl;
		if (this->m_Name != NULL){
			delete[] this->m_Name; //�ͷŶ��ڴ�
			this->m_Name = NULL;   //ָ���ָ��
		}
	}
};


void test01()
{
	Animal * animal = new Cat("TOM");
	animal->speak();

	delete animal; //����animal
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Сè��˵��
Cat����������
Animal�Ĵ�����������
�밴���������. . .
*/