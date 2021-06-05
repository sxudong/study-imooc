#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
1 ��̬����Ͷ�̬����
	1.1	��̬����
		1.1.1 ��̬��̬ -> ��������
		1.1.2 ��̬��̬ -> �麯����Ҫ�м̳й�ϵ��
	1.2	��̬����
		1.2.1 ��ַ��󶨣�����׶ΰ󶨺õ�ַ
	1.3	��̬����
		1.3.1 ��ַ��󶨣�����ʱ��󶨺õ�ַ
	1.4	��̬
		1.4.1 ����������á���ָ��ָ���������

2 ��̬ԭ�����
	2.1	�����������ˡ��麯�������ڲ��ṹ�ͷ����˸ı�
	2.2	�ڲ�����һ�� vfprt
		2.2.1 virtual  function pointer �麯����ָ��
		2.2.2 ָ�� vftable  �麯����
	2.3	�����нṹ  vfptr     &Animal::speak
	2.4	������ ���м̳� ��̳� vfptr  vftable
	2.5	���캯���� �Ὣ���麯����ָ�롱ָ���Լ��ġ��麯����
	2.6	�����������д�����滻���麯�����е�ԭ�е�speak����Ϊ &Cat::speak
	2.7	�����������ڲ�������ε���
	2.8	((void(*)())  (*(int*)*(int*)animal))();
	2.9	è����ĺ������ã��������ĵ��ã�
*/


/*
 Animal�ڲ��ṹ
   vfptr �ڲ�����ô��ָ��
   virtual function pointer
   �麯����ָ��
*/

/* ������
G:\VisualStudioWorkSpace> cl / d1 reportSingleClassLayoutAnimal test.cpp

class Animal    size(4) :
	+-- -
 0  | {vfptr}        //�麯����ָ��
    + -- -

Animal::$vftable@ :  //�麯����
	| &Animal_meta
	| 0
  0 | &Animal::speak
  1 | &Animal::eat

Animal::speak this adjustor: 0
Animal::eat this adjustor : 0
*/


class Animal
{
public:
    /*
    * ����ġ����⺯����
    */
	virtual void speak() //�ӡ�virtual���ؼ��֣�����Java������� adstract �ؼ���
	{
		cout << "������˵��" << endl;
	}

	virtual void eat()  //�ӡ�virtual���ؼ���
	{
		cout << "�����ڳԷ�" << endl;
	}

};

class Cat : public Animal
{
public:
	void speak()
	{
		cout << "Сè��˵��" << endl;
	}

	void eat()
	{
		cout << "Сè�ڳ���" << endl;
	}
};



/*
* ���� doSpeak ��speak �����ĵ�ַ��Ͱ󶨺��ˣ���� ��������̬���ࡱ������׶ξ�ȷ�����˵�ַ��
* ��������è��speak��������ǰ�󶨺ú����ĵ�ַ�ˣ�������Ҫ�ڡ�����ʱ����ȥȷ��������ַ��
* ����̬���ࡱд�� doSpeak ������Ϊ���麯����,�ڸ����������麯���������˶�̬��
* ����������á� ���� ָ��ָ��������󡱡�
*/
void doSpeak(Animal & animal) //Animal & animal = cat //����������á�ָ�����ࡱ
{
	animal.speak();
}


/*
* ��������˼̳еĹ�ϵ�������������������ת��
*/
void test01()
{
	Cat cat;
	doSpeak(cat); //Сè��˵��
}

/* è��
G:\VisualStudioWorkSpace> cl / d1 reportSingleClassLayoutCat test.cpp

class _s__CatchableType size(28) :
	+-- -
  0 | properties
  4 | pType
  8 | _PMD thisDisplacement
 20 | sizeOrOffset
 24 | copyFunction
	+ -- -

	class _s__CatchableTypeArray    size(4) :
	+-- -
  0 | nCatchableTypes
  4 | arrayOfCatchableTypes
	+ -- -

	class Cat       size(4) :
	+-- -
  0 | +-- - (base class Animal)
  0 | | {vfptr}    //�麯����ָ��
	| +-- -
	+-- -

Cat::$vftable@:    //�麯����
	| &Cat_meta
	| 0
  0 | &Cat::speak  //���Cat��дspeak������ͻ��Ǹ���� &Animal::speak
  1 | &Cat::eat

Cat::speak this adjustor: 0
Cat::eat this adjustor : 0
*/

void test02()
{
	//cout << sizeof(Animal) << endl;
	//����ָ��ָ��������� ��̬
	Animal * animal = new Cat;

	//animal->speak(); //Сè��˵��

	//��������Cat�ġ��麯����ƫ���ҵ���������ַ��
	// *(int*) *(int*) animal //������ַ
	((void(*)()) (*(int*) *(int*) animal))(); //������Ǹ��˿��ģ�����ǻ����ڲ�������

	// *((int*) *(int*) animal + 1) //è����ĵ�ַ
	((void(*)()) (*((int*) *(int*) animal + 1)))();
}

int main(){

	test01();
	cout << "--------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Сè��˵��
--------------
Сè��˵��
Сè�ڳ���
�밴���������. . .
*/