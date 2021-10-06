#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>
#include <stdexcept>
/*
string 构造函数
    string();                   //创建一个空的字符串 例如: string str;
    string(const string& str);  //使用一个string对象初始化另一个string对象
    string(const char* s);      //使用字符串s初始化
    string(int n, char c);      //使用n个字符c初始化

3.1.2.2 string基本赋值操作
    string& operator=(const char* s);     //char*类型字符串 赋值给当前的字符串
    string& operator=(const string &s);   //把字符串s赋给当前的字符串
    string& operator=(char c);            //字符赋值给当前的字符串
    string& assign(const char *s);        //把字符串s赋给当前的字符串
    string& assign(const char *s, int n); //把字符串s的前n个字符赋给当前的字符串
    string& assign(const string &s);      //把字符串s赋给当前字符串
    string& assign(int n, char c);        //用n个字符c赋给当前字符串
    string& assign(const string &s, int start, int n);  //将s从start开始n个字符赋值给字符串
*/

void test01()
{
	string str;       //默认构造
	string str2(str); //拷贝构造
	string str3 = str;

	string str4 = "abcd";
	string str5(10, 'a');

	cout << str4 << endl; //abcd
	cout << str5 << endl; //aaaaaaaaaa

	//基本赋值
	str = "hello";
	str2 = str4;

	//string& assign(const char *s, int n);
	//把字符串s的前n个字符赋给当前的字符串
	str3.assign("abcdef", 4);
	cout << str3 << endl; //abcd


	//string& assign(const string &s, int start, int n);
	//将s从start开始n个字符赋值给字符串
	string str6;
	str6.assign(str, 1, 3); //ell ? hel 从0索引

	cout << str6 << endl;  //ell
}
/* Output:
abcd
aaaaaaaaaa
abcd
ell
*/



/*
* string存取字符操作
* char& operator[](int n); //通过[]方式取字符
* char& at(int n);         //通过at方法获取字符
*/
void test02()
{
	string s = "hello world";

	/*
	* [] 和 at 区别？
	*    [] 访问越界，直接挂掉。 at 会抛出异常。
	*/
	for (int i = 0; i < s.size();i++){
		//cout << s[i] << endl;
		cout << s.at(i) << endl;
	}

	try{
		//cout << s[100] << endl;
		cout << s.at(100) << endl; //抛出异常
	}
	catch (out_of_range & e){
		cout << e.what() << endl;
	}
	catch (...){
		cout << "越界异常" << endl;
	}
}
/* Output:
h
e
l
l
o

w
o
r
l
d
invalid string position
*/



/*
*                                string拼接操作
*
* string& operator+=(const string& str);            //重载+=操作符
* string& operator+=(const char* str);              //重载+=操作符
* string& operator+=(const char c);                 //重载+=操作符
* string& append(const char *s);                    //把字符串s连接到当前字符串结尾
* string& append(const char *s, int n);             //把字符串s的前n个字符连接到当前字符串结尾
* string& append(const string &s);                  //同operator+=()
* string& append(const string &s, int pos, int n);  //把字符串s中从pos开始的n个字符连接到当前字符串结尾
* string& append(int n, char c);                    //在当前字符串结尾添加n个字符c
*/


/*
*                            3.1.2.5 string查找和替换
*
* int find(const string& str, int pos = 0) const;      //查找str第一次出现位置,从pos开始查找
* int find(const char* s, int pos = 0) const;          //查找s第一次出现位置,从pos开始查找
* int find(const char* s, int pos, int n) const;       //从pos位置查找s的前n个字符第一次位置
* int find(const char c, int pos = 0) const;           //查找字符c第一次出现位置
* int rfind(const string& str, int pos = npos) const;  //查找str最后一次位置,从pos开始查找
* int rfind(const char* s, int pos = npos) const;      //查找s最后一次出现位置,从pos开始查找
* int rfind(const char* s, int pos, int n) const;      //从pos查找s的前n个字符最后一次位置
* int rfind(const char c, int pos = 0) const;          //查找字符c最后一次出现位置
* string& replace(int pos, int n, const string& str);  //替换从pos开始n个字符为字符串str
* string& replace(int pos, int n, const char* s);      //替换从pos开始的n个字符为字符串s
*/
void test03()
{
	/*
	* 拼接
	*/
	string s1 = "我";
	string s2 = "爱北京";
	s1 += s2;
	cout << s1 << endl; //我爱北京
	s1.append("天安门");

	cout << s1 << endl; //我爱北京天安门

	/*
	* find查找
	*/
	string s = "abcdefg";
	int pos = s.find("bcf"); //找不到返回是 -1
	cout << "pos = " << pos << endl; //-1

	 //“rfind”和“find”结果一样，内部查找顺序相反
	int pos2 = s.rfind("bc");
	cout << "pos2 = " << pos2 << endl; // 4 2

	/*
	* 替换
	*/
	string s3 = "hello";
	s3.replace(1, 3, "1111"); //替换从pos开始n个字符为字符串str
	cout << s3 << endl;       // h1111o
}
/* Output:
我爱北京
我爱北京天安门
pos = -1
pos2 = 1
h1111o
*/



/*
* string 比较操作
*
* compare 函数在 > 时返回 1，< 时返回 -1，== 时返回 0。
* 比较区分大小写，比较时参考字典顺序，排越前面的越小。
* 大写的A比小写的a小。
*
* int compare(const string &s) const; //与字符串 s 比较
* int compare(const char *s) const;   //与字符串 s 比较
*/

void test04()
{
	string s1 = "abc";
	string s2 = "abcd";

	if (s1.compare(s2) == 0){
		cout << "s1 等于 s2" << endl;
	}
	else if (s1.compare(s2) == 1){
		cout << "s1 大于 s2" << endl;
	}
	else{
		cout << "s1 小于 s2" << endl;
	}
}
/* Output:
s1 小于 s2
*/



/*
* string 子串
*
* string substr(int pos = 0, int n = npos) const; //返回由pos开始的n个字符组成的字符串
*/
void test05()
{
	string s1 = "abcde";

	string s2 = s1.substr(1, 3);
	cout << "s2 = " << s2 << endl; //bcd

	//需求：查找一个右键的 用户名
	string email = "zhangtao@sina.com";

	int pos = email.find("@");
	cout << "pos " << pos << endl; //8

	string usrName = email.substr(0, pos);
	cout << "用户名为：" << usrName << endl; //zhangtao
}
/* Output:
s2 = bcd
pos 8
用户名为：zhangtao
*/



/*
* string “插入”和“删除”操作
*
* string& insert(int pos, const char* s);     //插入字符串
* string& insert(int pos, const string& str); //插入字符串
* string& insert(int pos, int n, char c);     //在指定位置插入n个字符c
* string& erase(int pos, int n = npos);       //删除从Pos开始的n个字符
*/
void test06()
{
	string s1 = "hello";
	s1.insert(1, "111");
	cout << s1 << endl; //h111ello

	//删除 111
	s1.erase(1, 3);
	cout << s1 << endl; //hello
}
/* Output:
h111ello
hello
*/



/*
* string 和 c-style 字符串转换
*/
void func(string s)
{
	cout << s << endl;
}

void func2(const char * s)
{
	cout << s << endl;
}

void test07()
{
	string s = "abc";
	//string -> const char *

	//c_str()函数返回一个指向正规C字符串的指针常量,内容与本string串相同.
	//c_str是一个内容为字符串指向字符数组的临时指针；
	//c_str返回的是一个可读不可改的常指针；
	const char * p = s.c_str();

	func(p); //const char * 隐式类型转换为 string
	//const char * -> string


	string s2(p);
	//func2(s2); //string 不能隐式类型转换为 char *
	func2(p);
}
/* Output:
abc
abc
*/



void test08()
{
	string s = "abcdefg";
	char& a = s[2];
	char& b = s[3];

	a = '1';
	b = '2';

	cout << s << endl;                //ab12efg
	cout << (int*) s.c_str() << endl; //006FF7EC

	s = "pppppppppppppp";

	//a = '1';
	//b = '2';

	cout << s << endl;                //pppppppppppppp
	cout << (int*) s.c_str() << endl; //006FF7EC
}
/* Output:
ab12efg
006FF7EC
pppppppppppppp
006FF7EC
*/



/*
* 写一个函数，函数内部将 string字符串 中的所有小写字母都变为大写字母。
*/
void test09()
{
	string s = "abCdEfg";

	for (int i = 0; i < s.size();i++){
		//全变大写
		s[i] = toupper(s[i]); //ABCDEFG

		//全变小写
		//s[i] = tolower(s[i]); //abcdefg
	}
	cout << s << endl;
}
/* Output:
ABCDEFG
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

	test09();

	system("pause");
	return EXIT_SUCCESS;
}