#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
3 ��̬���� �C ����������
	3.1	���ڷ��� �ǲ�������չ
	3.2	������ԭ�򡶿���ԭ��  --  ����չ����,���޸Ĺرա�
	3.3	���ö�̬ʵ�� -> ���ں�����չ���ṹ�Էǳ��ã��ɶ��Ըߣ�Ч�ʱ�C������΢�ͣ�������̬�ڲ��ṹ���ӡ�

4 ������ �� ���麯��
	4.1	�����麯����д��  virtual void func() = 0;
	4.2	��������
	4.3	������ ������ʵ��������
	4.4	����� �̳��˳����࣬ ������д�������еĴ��麯��
*/



class Calculator
{
private:
	int val1;
	int val2;

public:

	void setv1(int v)
	{
		this->val1 = v;
	}

	void setv2(int v)
	{
		this->val2 = v;
	}

	int getResult(string oper)
	{
		if (oper == "+")
			return val1 + val2;
		else if (oper == "-")
			return val1 - val2;
	}
};

void test01()
{
	Calculator cal;
	cal.setv1(10);
	cal.setv2(10);
	cout << cal.getResult("+") << endl; //20
	cout << cal.getResult("-") << endl; //0
}


/*
* �����Ŀ����У��и�����ԭ�򡶿���ԭ�򡷣�����չ���ţ����޸Ĺرա�
*/



/*
* ���ö�̬ʵ�ּ�����
*/
class abstractCalculator
{
public:
	int val1;
	int val2;

public:

	/*
	* �麯��
	*/
	//virtual int getResult(){ return 0; };

	/*
	* ���麯��
	*
	* ������������ˡ����麯��������̳и��࣬�ͱ���Ҫʵ�� ���麯�������� Java �е� interface�ӿ���
	* ��������� ���ˡ����麯���������������޷�ʵ���������ˡ�
	* ��������˴��麯����ͨ���ֳ�Ϊ�������ࡱ
	*/
	virtual int getResult() = 0; //�ӡ�virtual���ؼ��֣�����Java������� adstract �ؼ���

	void setv1(int v)
	{
		this->val1 = v;
	}

	void setv2(int v)
	{
		this->val2 = v;
	}
};

/*
* ������������ˡ����麯�� ��������̳� -> ���࣬�ͱ���Ҫʵ�֡����麯����
*/
class A : public abstractCalculator
{
public:
	//ʵ�ָ���ġ����⺯����
	virtual int getResult() //��virtual���ؼ��ֿ�д�ɲ�д
	{
		return 0;
	}
};

/*
* �ӷ�������
*/
class PlusCalculator : public abstractCalculator
{
public:
	//ʵ�ָ���ġ����⺯����
	virtual int getResult() //��virtual���ؼ��ֿ�д�ɲ�д
	{
		return val1 + val2;
	};
};


/*
* ����������
*/
class SubCalculator : public abstractCalculator
{
public:
	//ʵ�ָ���ġ����⺯����
	virtual int getResult() //��virtual���ؼ��ֿ�д�ɲ�д
	{
		return val1 - val2;
	};
};


/*
* �˷�������
*/
class ChengCalculator :public abstractCalculator
{
public:
	//ʵ�ָ���ġ����⺯����
	virtual int getResult()
	{
		return val1 * val2;
	};

};


void test02()
{
	abstractCalculator * abc ;
	//�ӷ�������
	abc =  new PlusCalculator;

	abc->setv1(10);
	abc->setv2(20);

	cout << abc->getResult() << endl; //30

	delete abc; //����abc

	//����������
	abc = new SubCalculator;
	abc->setv1(10);
	abc->setv2(20);
	cout << abc->getResult() << endl; //-10

	delete abc; //����abc

	//�˷�������
	abc = new ChengCalculator;
	abc->setv1(10);
	abc->setv2(20);
	cout << abc->getResult() << endl; //200


	/*
	* ����������ˡ����麯����������ʵ���������ˡ�
	*/
	/* error
	abstractCalculator aaa;
	abstractCalculator * abc = new abstractCalculator;
	*/

}

int main(){

	test01();
	cout << "--------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
0
--------------
30
-10
200
�밴���������. . .
*/