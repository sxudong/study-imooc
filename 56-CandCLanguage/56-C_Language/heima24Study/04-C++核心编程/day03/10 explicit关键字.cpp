#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

class MyString
{
public:
	char* mStr;
	int mSize;

	MyString(const char * str)
	{
		//
	}

	/*
	* explicit�ؼ��� ����ֹ��ʽ����ת��
	*/
	explicit MyString(int a)
	{
		mSize = a;
	}
};

void test01()
{
	MyString str = "abc";
	MyString str2(10);//��ǳ���ȷ����Ҫ����int�����вι��캯��

	//MyString str3 = 10; //��ʲô��ͼ�� �п�����str2�ַ���Ϊ "10" ���п����ַ����ĳ���10������ȷ��
	//��ʽ����ת���� MyString str3 = MyString (10); ���������������ʽ����ת����ʹ��explicit�ؼ��֡�
	// explicit�ؼ��֣���ֹ��ʽ����ת��������explicit�ؼ��֣�MyString str3 = 10; �Ͳ�������д�ˡ�
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}