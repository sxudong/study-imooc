#define _CRT_SECURE_NO_WARNINGS
using namespace std;
#include<iostream>

/*
* 使用控制符的头文件
*/
#include <iomanip>


/*
4.4.2.1 使用流对象的有关成员函数 —— 标准输出流对象 cout

11 标准输出流
	11.1 流对象的成员函数
		11.1.1	int number = 99;
		11.1.2	cout.width(20);           //字符宽度
		11.1.3	cout.fill('*');           //填充
		11.1.4	cout.setf(ios::left);     //设置格式  输入内容做对齐
		11.1.5	cout.unsetf(ios::dec);    //卸载十进制
		11.1.6	cout.setf(ios::hex);      //安装16进制
		11.1.7	cout.setf(ios::showbase); //强制输出整数基数  0  0x
		11.1.8	cout.unsetf(ios::hex);
		11.1.9	cout.setf(ios::oct);
		11.1.10	cout << number << endl;

	11.2 控制符
		int number = 99;
		cout << setw(20)              //字符宽度
		<< setfill('~')               //填充
		<< setiosflags(ios::showbase) //强制输出整数的基数（八进制以0开头，十六进制以0x开头）
		<< setiosflags(ios::left)     //左对齐
		<< hex                        //十六进制
		<< number
		<< endl;
*/


/*
cout.put()   //向缓冲区写字符
cout.write() //从buffer中写num个字节到当前输出流中。
*/
void test01()
{
	//cout.put('a').put('b'); //输出：ab

	char buf[1024] = "hellowrold";

	cout.write(buf, strlen(buf));

	cout << "" << endl;
}
/* Output:
hellowrold
*/



/*
* 通过流成员函数
*/

void test02()
{
	int number = 99;
	cout.width(20);
	cout << number << endl;
}
/* Output:
                  99   //前面是18个空格
*/


void test03()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');  //填充
	cout << number << endl;
}
/* Output:
******************99
*/


void test04()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //填充
	cout.setf(ios::left);     //设置格式  输入内容做对齐
	cout << number << endl;
}
/* Output:
99******************
*/


void test05()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //填充
	cout.setf(ios::left);     //设置格式  输入内容做对齐
	cout.unsetf(ios::dec);    //卸载十进制
	cout.setf(ios::hex);      //设置整数的基数为16进制
	cout << number << endl;
}
/* Output:
63******************
*/


void test06()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //填充
	cout.setf(ios::left);     //设置格式  输入内容做对齐
	cout.unsetf(ios::dec);    //卸载十进制
	cout.setf(ios::hex);      //设置整数的基数为16进制
	cout.setf(ios::showbase); //强制输出整数基数  0  0x
	cout << number << endl;
}
/* Output:
0x63****************
*/


void test07()
{
	int number = 99;
	cout.width(20);
	cout.fill('*');           //填充
	cout.setf(ios::left);     //设置格式  输入内容做对齐
	cout.unsetf(ios::dec);    //卸载十进制
	cout.setf(ios::hex);      //设置整数的基数为16进制
	cout.setf(ios::showbase); //强制输出整数基数  0  0x
	cout.unsetf(ios::hex);    //卸载16进制
	cout.setf(ios::oct);      //设置整数的基数为8进制
	cout << number << endl;
}
/* Output:
0143****************
*/



/*
* 控制符的方式显示
*
* 首先必需要有 #include <iomanip> 头文件
*/
void test08(){
	int number = 99;
	cout << setw(20)
		<< number
		<< endl;
}
/* Output:
				  99    //前面是18个空格
*/


void test09() {
	int number = 99;
	cout << setw(20)
		<< setfill('~')  //填充
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
		<< setiosflags(ios::showbase) //强制输出整数的基数（八进制以0开头，十六进制以0x开头）
		<< setiosflags(ios::left)     //左对齐
		<< hex                        //十六进制
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
请按任意键继续. . .
*/