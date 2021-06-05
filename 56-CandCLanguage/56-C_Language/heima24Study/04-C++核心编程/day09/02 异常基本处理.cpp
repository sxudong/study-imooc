#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
2 �쳣
	2.1	try ��ͼִ�� try {}�е�����
	2.2	�ڿ��ܳ����쳣�ĵط� �׳��쳣  throw
	2.3	try���� catch�����쳣
	2.4	catch (��������)  ������ ������������
	2.5	������봦���쳣�����������׳�  throw
	2.6	���û���κδ����쳣�ĵط�����ô��Ա����terminate�������жϳ���
	2.7	�Զ����쳣�࣬�����׳��Զ���Ķ��󣬲����Զ�����쳣

3 ջ����
	3.1	��try��ʼ  �� throw �׳��쳣֮ǰ  ����ջ�ϵĶ��� ���ᱻ�ͷ� ������̳�Ϊջ����
	3.2	ջ�϶�����˳��������˳���෴

4 �쳣�Ľӿ����� --> ���Դ�����QT��Ŀ��exception����
	4.1	������׳��ض��������쳣 �����������쳣�Ľӿ�����
	4.2	void func() throw ( int) ֻ���׳� int����
	4.3	throw() ���׳��κ������쳣

*/


/*
* �Զ����쳣��
* ��day09 06.���Զ����쳣���в���_.mp4��
*/
class myException
{
public:
	void printError(){
		cout << "�Զ�����쳣" << endl;
	}
};

class Person
{
public:
	Person(){
		cout << "Person����" << endl;
	}

	~Person(){
		cout << "Person����" << endl;
	}

};


//C�������ڵ�����
int A_MyDivide(int a, int b) {
	if (b == 0) {
		return -1; //�����������-1���޷����ֵ����ǽ�������쳣
	}
	return a / b;
}


/*
* ��������
*/
int myDevide(int a ,int b)
{
	if (b == 0){

		//���b���쳣���׳��쳣
		//throw 1;    //�׳� int �����쳣
		//throw 3.14; //�׳� double �����쳣  �쳣���봦����������� �͹ҵ�
		//throw 'a';

		/*
		* ջ����
		* ��try��ʼ  �� throw �׳��쳣֮ǰ������ջ�ϵĶ��󶼻ᱻ�ͷţ�������̳�Ϊ��ջ��������
		* ���������˳���෴
		*/
		Person p1;
		Person p2;

		throw myException(); //��������
		/* ջ����:�� try ��ʼ �� throw �׳��쳣֮ǰ������ջ�ϵĶ��󶼻ᱻ�ͷš�
		  Person����
		  Person����
		  Person����
		  Person����
		  �Զ�����쳣
		*/
	}
	return a / b;
}



void test01()
{
	int a = 10;
	int b = 0;

	//int ret = myDevide(a, b); //�����������-1 �޷����ֵ����ǽ�������쳣

	//C++���쳣����

	try{ //��һ��
		myDevide(a, b);
	}catch(int){ //�����쳣
		cout << "int�����쳣����" << endl;
	}catch(double){
		//������봦������쳣 �����Լ��������׳�
		throw;
		cout << "double�����쳣����" << endl;
	}catch (myException e){
		e.printError();
	}catch (...){ // ��...�������쳣
		cout << "���������쳣����" << endl;
	}
}


int main(){

	try{
		test01();
    //}catch (double){ //����test01()�׳��� double �쳣
	}catch (char){     //����쳣��û�д�����ô��Ա terminate ������ʹ�����ж�
		cout << "main ������ double�����쳣����" << endl;
	}catch (...){
		cout << "main������ ���������쳣����" << endl;
	}

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Person����
Person����
Person����
Person����
�Զ�����쳣
�밴���������. . .
*/