#define _CRT_SECURE_NO_WARNINGS
using namespace std;
#include<iostream>

/*
* ʹ�ÿ��Ʒ���ͷ�ļ�
*/
#include <iomanip>


/*
4.4.2.1 ʹ����������йس�Ա���� ���� ��׼��������� cout

11 ��׼�����
	11.1 ������ĳ�Ա����
		11.1.1	int number = 99;
		11.1.2	cout.width(20);           //�ַ����
		11.1.3	cout.fill('*');           //���
		11.1.4	cout.setf(ios::left);     //���ø�ʽ  ��������������
		11.1.5	cout.unsetf(ios::dec);    //ж��ʮ����
		11.1.6	cout.setf(ios::hex);      //��װ16����
		11.1.7	cout.setf(ios::showbase); //ǿ�������������  0  0x
		11.1.8	cout.unsetf(ios::hex);
		11.1.9	cout.setf(ios::oct);
		11.1.10	cout << number << endl;

	11.2 ���Ʒ�
		int number = 99;
		cout << setw(20)              //�ַ����
		<< setfill('~')               //���
		<< setiosflags(ios::showbase) //ǿ����������Ļ������˽�����0��ͷ��ʮ��������0x��ͷ��
		<< setiosflags(ios::left)     //�����
		<< hex                        //ʮ������
		<< number
		<< endl;
*/


/*
cout.put()   //�򻺳���д�ַ�
cout.write() //��buffer��дnum���ֽڵ���ǰ������С�
*/
void test01()
{
	//cout.put('a').put('b'); //�����ab

	char buf[1024] = "hellowrold";

	cout.write(buf, strlen(buf));

	cout << "" << endl;
}
/* Output:
hellowrold
*/



/*
* ͨ������Ա����
*/

void test02()
{
	int number = 99;
	cout.width(20);
	cout << number << endl;
}
/* Output:
                  99   //ǰ����18���ո�
*/


void test03()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');  //���
	cout << number << endl;
}
/* Output:
******************99
*/


void test04()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //���
	cout.setf(ios::left);     //���ø�ʽ  ��������������
	cout << number << endl;
}
/* Output:
99******************
*/


void test05()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //���
	cout.setf(ios::left);     //���ø�ʽ  ��������������
	cout.unsetf(ios::dec);    //ж��ʮ����
	cout.setf(ios::hex);      //���������Ļ���Ϊ16����
	cout << number << endl;
}
/* Output:
63******************
*/


void test06()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //���
	cout.setf(ios::left);     //���ø�ʽ  ��������������
	cout.unsetf(ios::dec);    //ж��ʮ����
	cout.setf(ios::hex);      //���������Ļ���Ϊ16����
	cout.setf(ios::showbase); //ǿ�������������  0  0x
	cout << number << endl;
}
/* Output:
0x63****************
*/


void test07()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //���
	cout.setf(ios::left);     //���ø�ʽ  ��������������
	cout.unsetf(ios::dec);    //ж��ʮ����
	cout.setf(ios::hex);      //���������Ļ���Ϊ16����
	cout.setf(ios::showbase); //ǿ�������������  0  0x
	cout.unsetf(ios::hex);    //ж��16����
	cout.setf(ios::oct);      //���������Ļ���Ϊ8����
	cout << number << endl;
}
/* Output:
0143****************
*/



/*
* ���Ʒ��ķ�ʽ��ʾ
*
* ���ȱ���Ҫ�� #include <iomanip> ͷ�ļ�
*/
void test08(){
	int number = 99;
	cout << setw(20)
		<< number
		<< endl;
}
/* Output:
				  99    //ǰ����18���ո�
*/


void test09() {
	int number = 99;
	cout << setw(20)
		<< setfill('~')  //���
		<< number
		<< endl;
}
/* Output:
~~~~~~~~~~~~~~~~~~99
*/


void test10() {

	int number = 99;
	cout << setw(20)
		<< setfill('~')
		<< setiosflags(ios::showbase) //ǿ����������Ļ������˽�����0��ͷ��ʮ��������0x��ͷ��
		<< setiosflags(ios::left)     //�����
		<< hex                        //ʮ������
		<< number
		<< endl;
}
/* Output:
0x63~~~~~~~~~~~~~~~~
*/


int main(){

	//test01();
	//test02();
	//test03();
	//test04();
	//test05();
	//test06();
	//test07();
	//test08();
	//test09();
	test10();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
hellowrold
----------------------
0143****************
----------------------
0x63~~~~~~~~~~~~~~~~
�밴���������. . .
*/