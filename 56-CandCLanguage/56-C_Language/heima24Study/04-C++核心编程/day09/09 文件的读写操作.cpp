#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
//�ļ���дͷ�ļ�
#include <fstream>


/*
12 �ļ�����
	12.1 д�ļ�
		12.1.1	ofstream  ofs
		12.1.2	open           //ָ���򿪷�ʽ
		12.1.3	isopen         //�ж��Ƿ�򿪳ɹ�
		12.1.4	ofs << �����ݡ�
		12.1.5	ofs.close

	12.2 ������
		12.2.1	ifstream  ifs
		12.2.2	ָ���򿪷�ʽ ios����in
		12.2.3	isopen�ж��Ƿ�򿪳ɹ�
		12.2.4	 ���ַ�ʽ��ȡ����
*/


/*
* д�ļ�
*/
void test01()
{
	//������ķ�ʽ���ļ�
	//ofstream ofs("./test.txt", ios::out | ios::trunc);

	//����ָ���򿪷�ʽ���μ���4.4.2 C++���ļ���
	ofstream ofs;
	//ios::out �������ʽ���ļ�
	//ios::trunc ��һ���ļ�������ļ��Ѵ��ڣ���ɾ������ȫ�����ݣ�����ļ������ڣ��������ļ���
	ofs.open("./test.txt", ios::out | ios::trunc);

	//�ж��Ƿ�򿪳ɹ�
	if ( !ofs.is_open())
		cout << "��ʧ��" << endl;

	ofs << "������abc" << endl;
	ofs << "���䣺100" << endl;
	ofs << "�Ա���" << endl;

	ofs.close();
}

/*
* ���ļ�
*/
void test02()
{
	ifstream ifs;
	ifs.open("./test.txt", ios::in); //ios::in �����뷽ʽ���ļ�

	//�ж��Ƿ�򿪳ɹ�
	if (!ifs.is_open())
		cout << "��ʧ��" << endl;

	/*
	* ��һ�ַ�ʽ�����ж�ȡ ���Ƽ���
	*/
	char buf[1024];
	while (ifs >>buf) //���ж�ȡ
		cout << buf << endl;
	/* Output:
	  ������abc
	  ���䣺100
	  �Ա���
	*/

	/*
	* �ڶ��ַ�ʽ��eof�����ļ�β
	*/
	//char buf2[1024];
	//while (!ifs.eof()){ //eof�����ļ�β
	//	ifs.getline(buf2, sizeof(buf2));
	//	cout << buf2 << endl;
	//}
	/* Output:
	  ������abc
	  ���䣺100
	  �Ա���

	*/

	/*
	* ������ ���Ƽ� �������ַ���ȡ
	*/
	//char c;
	//while ( (c = ifs.get() ) != EOF) // EOF�ļ�β
	//	cout << c;
	/* Output:
	  ������abc
	  ���䣺100
	  �Ա���
	*/

	ifs.close();
}


int main(){
	//test01(); //д�ļ�
	test02();   //���ļ�

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������abc
���䣺100
�Ա���
�밴���������. . .
*/