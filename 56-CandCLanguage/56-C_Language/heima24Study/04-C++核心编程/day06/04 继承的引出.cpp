#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 �̳е�����
	5.1	��ҳ �ܶ๫������
	5.2	����ʵ��ʱ���кܶ��ظ��Ĵ���
	5.3	�����̳У����� �����ࣩ ������ҳ
	5.4	�������� ʵ�ֲ�ͬ������
	5.5	�﷨  class ���� :�̳з�ʽ ����
*/


/*
�����ඨ���ʽ��
	Class �������� : �̳з�ʽ ������{
		//���������������ݳ�Ա�ͳ�Ա����
	}

���ּ̳з�ʽ��
?	public ��    ���м̳�
?	private ��   ˽�м̳�
?	protected �� �����̳�
*/



//class News
//{
//public:
//	void header()
//	{
//		cout << "����ͷ��" << endl;
//	}
//	void footer()
//	{
//		cout << "�����ײ�" << endl;
//	}
//	void left()
//	{
//		cout << "����б�" << endl;
//	}
//
//	void content()
//	{
//		cout << "���Ų���" << endl;
//	}
//
//};
//
//class YULE
//{
//public:
//	void header()
//	{
//		cout << "����ͷ��" << endl;
//	}
//	void footer()
//	{
//		cout << "�����ײ�" << endl;
//	}
//	void left()
//	{
//		cout << "����б�" << endl;
//	}
//
//	void content()
//	{
//		cout << "�װٺϡ�����" << endl;
//	}
//
//};
//
//void test01()
//{
//	News news;
//	news.header();
//	news.footer();
//	news.left();
//	news.content();
//
//	//����ҳ
//	YULE yl;
//	yl.header();
//	yl.footer();
//	yl.left();
//	yl.content();
//
//}


/*
* �̳�д��
* ����һ�����������ҳ�������ظ��Ĵ��롱��д�������ҳ�ϡ�
*/
class BasePage
{
public:
	void header()
	{
		cout << "����ͷ��" << endl;
	}
	void footer()
	{
		cout << "�����ײ�" << endl;
	}
	void left()
	{
		cout << "����б�" << endl;
	}
};


/*
* �̳�  News�� �̳��� BasePage��
* ð��ָ��News��Ļ�����BasePage�ࡣ
*/
//����
class News : public BasePage
{
public:
	void content()
	{
		cout << "���Ų���" << endl;
	}
};


//����
class YULE : public BasePage
{
public:
	void content()
	{
		cout << "�װٺϡ�����" << endl;
	}
};


//��Ϸ
class Game : public BasePage
{
public:
	void content()
	{
		cout << "KPLֱ��" << endl;
	}
};


void test02()
{
	cout << " ������ҳ���ݣ� " << endl;
	News news;
	news.header();   //����ͷ��
	news.footer();   //�����ײ�
	news.left();     //��������б�
	news.content();  //News���������

	cout << " ������ҳ���ݣ� " << endl;
	YULE yl;
	yl.header();     //����ͷ��
	yl.footer();     //�����ײ�
	yl.left();       //��������б�
	yl.content();    //YULE���������

	cout << " ��Ϸ��ҳ���ݣ� " << endl;
	Game game;
	game.header();
	game.footer();
	game.left();
	game.content();
}


/*
* �̳� ���ٴ����ظ�����
* רҵ���BasePage  ���� (����)   News ������ �����ࣩ
*/
int main(){

	//test01();

	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
 ������ҳ���ݣ�
����ͷ��
�����ײ�
����б�
���Ų���
 ������ҳ���ݣ�
����ͷ��
�����ײ�
����б�
�װٺϡ�����
 ��Ϸ��ҳ���ݣ�
����ͷ��
�����ײ�
����б�
KPLֱ��
�밴���������. . .
*/