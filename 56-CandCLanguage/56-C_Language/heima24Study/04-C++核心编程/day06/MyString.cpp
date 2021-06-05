#include "MyString.h"


//左移运算符重载
ostream & operator<< (ostream & cout, MyString & str)
{
	cout << str.pString;
	return cout;
}

//右移运算符重载
istream & operator>> (istream & cin, MyString & str)
{
	//先判断 原始是否有内容，如果有 清空（test1()函数中原始里面有“abc”）
	if (str.pString != NULL){
		delete [] str.pString;
		str.pString = NULL;
	}

	//让用户输入内容
	char buf[1024];
	cin >> buf;

	//把用户输入的字符串 赋值给 str

	str.pString = new char[strlen(buf) + 1]; //开辟空间
	strcpy(str.pString, buf);                //复制值
	str.m_Size = strlen(buf);
	return cin;
}


MyString::MyString(const char * str)
{
	//cout << "有参构造调用" << endl;
	this->pString = new char[strlen(str) + 1]; //开辟空间
	strcpy(this->pString, str);                //复制值
	this->m_Size = strlen(str);
}


MyString::MyString(const MyString & str)
{
	this->pString = new char[strlen(str.pString) + 1]; //开辟空间
	strcpy(this->pString, str.pString);                //复制值
	this->m_Size = str.m_Size;
}


MyString::~MyString()
{
	//cout << "析构函数调用" << endl;
	if (this->pString != NULL){
		delete[] this->pString;
		this->pString = NULL;
	}
}


char & MyString::operator[](int index)
{
	return this->pString[index];
}


MyString & MyString::operator=(const char * str) //返回值引用（引用的本质是指针）
{
	//先判断 原始是否有内容，如果有 清空
	if (this->pString!=NULL){
		delete[] this->pString;
		this->pString = NULL;
	}

	this->pString = new char[strlen(str) + 1];
	strcpy(this->pString, str);

	return *this; //返回本身
}


MyString & MyString::operator=(const MyString & str) //返回值引用（引用的本质是指针）
{
	//先判断 原始是否有内容，如果有 清空
	if (this->pString != NULL){
		delete[] this->pString;
		this->pString = NULL;
	}

	this->pString = new char[strlen(str.pString) + 1];
	strcpy(this->pString, str.pString);

	return *this; //返回本身
}


MyString MyString::operator+(const char * str)
{
	//计算返回的字符串开辟的大小
	int newSize = this->m_Size + strlen(str) + 1;

	char * tmp = new char[newSize]; //开辟空间

	memset(tmp, 0, newSize); //重置为0

	//拼接字符串
	strcat(tmp, this->pString);
	strcat(tmp, str);

	//调用构造器构造自己
	MyString newStr(tmp);
	delete[] tmp; //临时的tmp释放掉
	return newStr;
}

MyString MyString::operator+(const MyString & str)
{

	int newSize = this->m_Size + strlen(str.pString) + 1;

	char * tmp = new char[newSize];

	memset(tmp, 0, newSize);

	//拼接字符串
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