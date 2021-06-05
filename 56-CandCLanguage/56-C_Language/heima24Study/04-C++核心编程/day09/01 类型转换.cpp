#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;



/*
1 ����ת��
	1.1	��̬ת�� static_cast
	1.2	ʹ�÷�ʽ  static_cast<Ŀ������>��ԭʼ���ݣ�
	1.3	���Խ��л�����������ת��
	1.4	����������ת��
	1.5	û�и��ӹ�ϵ���Զ������Ͳ�����ת��
	1.6	��̬ת�� dynamic_cast
	1.7	������ת��������������
	1.8	����֮�����ת��
		1.8.1 ��ת�� ������
		1.8.2 ��ת�� ����
		1.8.3 ������̬ ������
	1.9	����ת�� const_cast
	1.10 ���ܶԷ�ָ����߷����ý���ת��
	1.11 ���½���ת�� reinterpret_cast
		1.11.1	���ȫ����� ���Ƽ�
*/



/*
* ��̬ת�� static_cast
* ��������
*
* static_castʹ�ã�static_cast<Ŀ������>(ԭʼ����)
*/
void test01()
{
	char a = 'a';

	//��һ��char����ת��Ϊdouble����
	//��������<>������дҪת�������
	double d = static_cast<double>(a);

	cout << "d = " << d <<endl; // d = 97
}

/*
* ��̬ת�� static_cast ���� ����֮��ת��
*/
class Base{};
class Child : public Base{};
class Other{};

void test02()
{
	Base * base = NULL;
	Child * child = NULL;

	//�� base תΪ Child* ���� ���� ����ȫ
	Child * child2 = static_cast<Child*>(base);

	//��child תΪ Base*  ����  ��ȫ
	Base * base2 = static_cast<Base*>(child);

	//תother���� ת����Ч������֮��û�и��ӹ�ϵ����
	//Other * other = static_cast<Other*>(base);
}



/*
* ��̬ת�� dynamic_cast
* �ڽ�������ת��ʱ��dynamic_cast �������ͼ��Ĺ��ܣ���static_cast����ȫ��
*/
void test03()
{
	//�������Ͳ�����ת��
	char c = 'a';

	//dynamic_cast�ǳ��ϸ񣬡�ʧȥ���ȡ����߲���ȫ��������ת��
	//double d = dynamic_cast<double>(c);

}

class Base2
{
	virtual void func(){};
};

class Child2 : public Base2
{
	virtual void func(){};
};

class Other2{};

void test04()
{
	Base2 * base = NULL;
	Child2 * child = NULL;

	// base ת Child2 * ����ȫ
	//Child2 * child2 = dynamic_cast<Child2*>(base);

	// child ת Base2 *  ��ȫ
	Base2* base2 = dynamic_cast<Base2*>(child);

	//������̬�����
	// dynamic_cast ��������˶�̬����ô�����û���תΪ�����࣬����ת��
	Base2 * base3 = new Child2; //����ָ������
	Child2 * child3 = dynamic_cast<Child2*>(base3); //����ָ������ת����
}


/*
* ����ת��  const_cast
*/
void test05()
{
	/*
	* ָ��
	*/
	const int * p = NULL;
	int * newp = const_cast<int *>(p); //ȡ��const

	int * p2 = NULL;
	const int * newP2 = const_cast<const int *>(p2);


	//���ܶԡ���ָ�롱�򡰷����á��ı�������ת��
	//const int a = 10;
	//int b = const_cast<int>(a);

	/*
	* ����
	*/
	int num = 10;
	int &numRef = num;

	const int &numRef2 = static_cast<const int &>(numRef);
}

/*
* ���½���ת��  reinterpret_cast
* �����ٷ�֮���ò�������
*/
void test06()
{
	int a = 10;
	int * p = reinterpret_cast<int *>(a);

	Base * base = NULL;
	Other * other = reinterpret_cast<Other*>(base);

	//���ȫ �����Ƽ�
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}