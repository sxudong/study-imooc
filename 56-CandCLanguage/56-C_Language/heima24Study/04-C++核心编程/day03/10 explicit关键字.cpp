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
	* explicit关键字 ，防止隐式类型转换
	*/
	explicit MyString(int a)
	{
		mSize = a;
	}
};

void test01()
{
	MyString str = "abc";
	MyString str2(10);//这非常明确，是要调用int类型有参构造函数

	//MyString str3 = 10; //做什么用图？ 有可能是str2字符串为 "10" ，有可能字符串的长度10，不明确。
	//隐式类型转换： MyString str3 = MyString (10); 如果不想它进行隐式类型转换，使用explicit关键字。
	// explicit关键字，防止隐式类型转换。有了explicit关键字，MyString str3 = 10; 就不能这样写了。
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}