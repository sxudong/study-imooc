#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
* 2.���һ��ѧ���࣬������������ѧ�ţ����Ը�������ѧ�Ÿ�ֵ��������ʾѧ������   ����ѧ��
*/

class Student {
	public: //����Ȩ��

		string m_Name; //����
		int m_Id;      //ѧ��

		//��������
		void setName(string name){
			m_Name = name;
		}

		//����ѧ��
		void setId(int id){
			m_Id = id;
		}

		//��ӡ��Ϣ
		void showInfo(){
			cout << "������" << m_Name << " ѧ�ţ� " << m_Id << endl;
		}
};

void test01()
{
	//����һ��ѧ�� ʵ���� --  ͨ��������������Ĺ���
	Student st; //�൱��Java��new��һ������
	st.setName("����");
	st.setId(1);

	//ͨ��st�����Դ�ӡ�� st��Ϣ
	cout << "st������Ϊ�� " << st.m_Name << " st��ѧ�ţ�" << st.m_Id << endl; //st������Ϊ�� ���� st��ѧ�ţ�1

	//ͨ����Ա���� ����ӡst����Ϣ
	st.showInfo(); //���������� ѧ�ţ� 1
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}