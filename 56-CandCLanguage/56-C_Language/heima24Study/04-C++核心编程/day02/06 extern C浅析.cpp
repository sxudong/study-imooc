#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "test.h"

/*
6 extern Cǳ��
    6.1	�����C++�ļ��е���C���ԵĴ���
    6.2	ifdef __cplusplus extern ��C�� {
    6.3	}
*/


/*
* C++�������C���Է���
*/
//�������һ��
//extern "C" void show();  //show���� ����C���Է�ʽ������

//�����������
//��test.hͷ�ļ��м��ϡ��������롱#ifdef __cplusplus

/*
* ������������ ��C++�е���C���Եĺ���
*/
int main(){

	//��C++��,�����ǿ��Է������صģ���������������������͵͵�ı�  _showv  void
	show(); //hello world

	system("pause");
	return EXIT_SUCCESS;
}