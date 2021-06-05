#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


class Person
{
public:

	Person(){

	}

	//��ʼ������
	Person(char * name,int age)
	{
		m_Name = (char*)malloc(strlen(name) + 1);
		strcpy(m_Name, name);

		m_age = age;
	}

	/*
	* ��������
	* ϵͳ���ṩ��Ĭ�Ͽ������족�������Ǽ򵥵�ֵ��������ǳ����
	* ����ʹ�á�Ĭ�Ͽ������족�ᵼ�¹ҵ���
	*
	* ԭ�򣺼򵥵�ǳ�������ͷŶ����ռ䡰���Ρ������¹ҵ���
	*
	* ����취��������Լ��ṩ�������졣
	*/
	Person(const Person &p)
	{
		//���
		m_age = p.m_age;
		m_Name = (char*) malloc(strlen(p.m_Name) + 1); //���ٶѿռ�
		strcpy(m_Name, p.m_Name);
	}

	//���ֱ�ӵ���������������Ѷ�����ͷ��ˡ��� p.m_Name �ǿ����ڶ��ϵģ���Ҫ���������ͷ�
	~Person()
	{
		cout << "������������" << endl;
		if (m_Name!=NULL)
		{
			free(m_Name);  //�ͷŶѿռ�
			m_Name = NULL; //ָ��ָ���ָ��
		}
	}

	//����
	char * m_Name;
	//����
	int m_age;
};


void test01()
{
	Person p1("�з�",10);
	Person p2(p1); //���ÿ�������
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������������
������������
�밴���������. . .
*/