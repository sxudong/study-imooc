#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
* ϵͳ�ṩ��׼�쳣 Ҫ����ͷ�ļ�
*/
#include <stdexcept>


/* 3.3 C++��׼�쳣��
7 ʹ��ϵͳ��׼�쳣
	7.1	#incldue < stdexcept>
	7.2	throw out_of_range����aaa���� ������
	7.3	catch (out_of_range& e)  cout << e.what();
*/


class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;

		//���������
		if (age < 0 || age > 200) {
			//�׳�Խ���쳣
			throw out_of_range("����Խ���ˣ�");
		}

		//���ֳ��ȼ��
		if (name.length() > 4) {
			throw length_error("����Խ��");
		}
	}
};

void test01()
{
	try{
		Person p("����",300);
	}
	catch (out_of_range & e){  //������Ч��Χ�쳣
		cout << e.what() << endl;
	}
	catch (length_error & e){  //������������󳤶ȵ�
		cout << e.what() << endl;
	}
}

void test02()
{
	try {
		Person p("������", 80);
	}
	catch (out_of_range & e){  //������Ч��Χ�쳣
		cout << e.what() << endl;
	}
	catch (length_error & e){  //������������󳤶ȵ�
		cout << e.what() << endl;
	}
}


int main(){

	test01();
	cout << "------------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
����Խ���ˣ�
------------------
����Խ��
�밴���������. . .
*/