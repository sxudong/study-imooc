#include "MyString.h"


//�������������
ostream & operator<< (ostream & cout, MyString & str)
{
	cout << str.pString;
	return cout;
}

//�������������
istream & operator>> (istream & cin, MyString & str)
{
	//���ж� ԭʼ�Ƿ������ݣ������ ��գ�test1()������ԭʼ�����С�abc����
	if (str.pString != NULL){
		delete [] str.pString;
		str.pString = NULL;
	}

	//���û���������
	char buf[1024];
	cin >> buf;

	//���û�������ַ��� ��ֵ�� str

	str.pString = new char[strlen(buf) + 1]; //���ٿռ�
	strcpy(str.pString, buf);                //����ֵ
	str.m_Size = strlen(buf);
	return cin;
}


MyString::MyString(const char * str)
{
	//cout << "�вι������" << endl;
	this->pString = new char[strlen(str) + 1]; //���ٿռ�
	strcpy(this->pString, str);                //����ֵ
	this->m_Size = strlen(str);
}


MyString::MyString(const MyString & str)
{
	this->pString = new char[strlen(str.pString) + 1]; //���ٿռ�
	strcpy(this->pString, str.pString);                //����ֵ
	this->m_Size = str.m_Size;
}


MyString::~MyString()
{
	//cout << "������������" << endl;
	if (this->pString != NULL){
		delete[] this->pString;
		this->pString = NULL;
	}
}


char & MyString::operator[](int index)
{
	return this->pString[index];
}


MyString & MyString::operator=(const char * str) //����ֵ���ã����õı�����ָ�룩
{
	//���ж� ԭʼ�Ƿ������ݣ������ ���
	if (this->pString!=NULL){
		delete[] this->pString;
		this->pString = NULL;
	}

	this->pString = new char[strlen(str) + 1];
	strcpy(this->pString, str);

	return *this; //���ر���
}


MyString & MyString::operator=(const MyString & str) //����ֵ���ã����õı�����ָ�룩
{
	//���ж� ԭʼ�Ƿ������ݣ������ ���
	if (this->pString != NULL){
		delete[] this->pString;
		this->pString = NULL;
	}

	this->pString = new char[strlen(str.pString) + 1];
	strcpy(this->pString, str.pString);

	return *this; //���ر���
}


MyString MyString::operator+(const char * str)
{
	//���㷵�ص��ַ������ٵĴ�С
	int newSize = this->m_Size + strlen(str) + 1;

	char * tmp = new char[newSize]; //���ٿռ�

	memset(tmp, 0, newSize); //����Ϊ0

	//ƴ���ַ���
	strcat(tmp, this->pString);
	strcat(tmp, str);

	//���ù����������Լ�
	MyString newStr(tmp);
	delete[] tmp; //��ʱ��tmp�ͷŵ�
	return newStr;
}

MyString MyString::operator+(const MyString & str)
{

	int newSize = this->m_Size + strlen(str.pString) + 1;

	char * tmp = new char[newSize];

	memset(tmp, 0, newSize);

	//ƴ���ַ���
	strcat(tmp, this->pString);
	strcat(tmp, str.pString);

	MyString newStr(tmp);
	delete[] tmp;
	return newStr;
}

bool MyString::operator==(const char * str)
{
	if ( strcmp( this->pString , str) == 0  && this->m_Size == strlen(str) )
		return true;

	return false;

}


bool MyString::operator==(const MyString & str)
{
	if (strcmp(this->pString, str.pString) == 0 && this->m_Size == strlen(str.pString))
		return true;

	return false;
}