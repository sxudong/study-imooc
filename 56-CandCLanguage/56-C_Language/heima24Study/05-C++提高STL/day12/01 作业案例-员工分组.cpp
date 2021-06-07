#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
#include <string>
#include <map>
#include <ctime>
using namespace std;

/*
* ����
*   ��˾������Ƹ��5��Ա����5��Ա�����빫˾֮����Ҫָ��Ա�����Ǹ����Ź���
*   ��Ա��Ϣ��: ���� ���� �绰 ���ʵ����
*   ͨ�� Multimap ������Ϣ�Ĳ��� ���� ��ʾ
*   �ֲ�����ʾԱ����Ϣ ��ʾȫ��Ա����Ϣ
*/

enum{ RENLI,YANFA,MEISHU };

class Worker
{
public:
	string m_Name;
	int m_Money;
};


void createWorker(vector<Worker>&v ){
	string nameSeed = "ABCDE";
	for (int i = 0; i < 5;i++){
		string name = "Ա��";
		name += nameSeed[i];

		int money = rand() % 10000 + 10000; // 10000~ 19999

		Worker w;
		w.m_Name = name;
		w.m_Money = money;

		v.push_back(w);
	}
}

void setGroup( vector<Worker> & v, multimap<int,Worker> & m ){
	for (vector<Worker>::iterator i = v.begin(); i != v.end(); i++){
		//����������ű��
		int departmentId = rand() % 3; // 0 1 2 
		//��Ա���ֵ� multimap������
		m.insert(make_pair(departmentId, *i));
	}
}

void showGroup( multimap<int,Worker> & m )
{
	//����������ʾ
	cout << "��������Ա�����£�" << endl;

	multimap<int,Worker>::iterator pos = m.find(RENLI); //ö���±� 0
	int index = 0;
	int num = m.count(RENLI); //ö���±� 0 ��������
	for (; pos != m.end(), index < num; pos++, index++) // 0  A  B  1  C  2  D E
		cout << "������" << pos->second.m_Name << " ���ʣ�" << pos->second.m_Money << endl;

	cout << "-------------------------" << endl;

	cout << "�з�����Ա�����£�" << endl;
	pos = m.find(YANFA); //ö���±� 1
	index = 0;
	num = m.count(YANFA); //ö���±� 1 ��������
	for (; pos != m.end(), index < num; pos++, index++) // 0  A  B  1  C  2  D E
		cout << "������" << pos->second.m_Name << " ���ʣ�" << pos->second.m_Money << endl;

	cout << "-------------------------" << endl;

	cout << "��������Ա�����£�" << endl;
	pos = m.find(MEISHU); //ö���±� 2
	index = 0;
	num = m.count(MEISHU); //ö���±� 2 ��������
	for (; pos != m.end(), index < num; pos++, index++) // 0  A  B  1  C  2  D E
		cout << "������" << pos->second.m_Name << " ���ʣ�" << pos->second.m_Money << endl;

}

int main(){

	srand((unsigned int)time(NULL));

	//����һ�����Ա��������
	vector<Worker> v;

	//����5��Ա��
	createWorker(v);
	
	//���÷���
	//�����multimap����
	multimap<int, Worker> m;
	setGroup(v,m);

	//�ֲ�����ʾԱ��
	showGroup(m);

	cout << "----------" << endl;

	////Ա����������
	for (vector<Worker>::iterator i = v.begin(); i != v.end(); i++)
		cout << "������ " << i->m_Name << " ���ʣ� " << i->m_Money << endl;

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��������Ա�����£�
������Ա��E ���ʣ�13136
-------------------------
�з�����Ա�����£�
������Ա��B ���ʣ�14911
������Ա��C ���ʣ�10230
-------------------------
��������Ա�����£�
������Ա��A ���ʣ�10490
������Ա��D ���ʣ�17100
----------
������ Ա��A ���ʣ� 10490
������ Ա��B ���ʣ� 14911
������ Ա��C ���ʣ� 10230
������ Ա��D ���ʣ� 17100
������ Ա��E ���ʣ� 13136
�밴���������. . .
*/