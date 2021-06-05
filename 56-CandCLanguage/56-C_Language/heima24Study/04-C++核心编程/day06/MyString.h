#pragma  once
#define  _CRT_SECURE_NO_WARNINGS
#include <iostream>
using namespace std;


class MyString
{
	friend ostream & operator<< (ostream & cout, MyString & str);
	friend istream & operator>> (istream & cin, MyString & str);

private:
	char * pString;  //ָ�������ָ��
	int m_Size;      //�ַ�����С

public:
	MyString(const char * str);
	MyString(const MyString & str);

	~MyString();

	//���� = �����
	MyString & operator= (const char * str);
	MyString & operator= (const MyString & str);

	//���� [] �����
	char & operator[](int index);

	//���� + �����
	MyString operator+ (const char * str);
	MyString operator+ (const MyString & str);

	//���� == �����
	bool operator== (const char * str);
	bool operator== (const MyString & str);

};