#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
//文件读写头文件
#include <fstream>


/*
12 文件操作
	12.1 写文件
		12.1.1	ofstream  ofs
		12.1.2	open           //指定打开方式
		12.1.3	isopen         //判断是否打开成功
		12.1.4	ofs << “数据”
		12.1.5	ofs.close

	12.2 读操作
		12.2.1	ifstream  ifs
		12.2.2	指定打开方式 ios：：in
		12.2.3	isopen判断是否打开成功
		12.2.4	 三种方式读取数据
*/


/*
* 写文件
*/
void test01()
{
	//以输出的方式打开文件
	//ofstream ofs("./test.txt", ios::out | ios::trunc);

	//后期指定打开方式（参见：4.4.2 C++打开文件）
	ofstream ofs;
	//ios::out 以输出方式打开文件
	//ios::trunc 打开一个文件，如果文件已存在，则删除其中全部数据，如果文件不存在，则建立新文件。
	ofs.open("./test.txt", ios::out | ios::trunc);

	//判断是否打开成功
	if ( !ofs.is_open())
		cout << "打开失败" << endl;

	ofs << "姓名：abc" << endl;
	ofs << "年龄：100" << endl;
	ofs << "性别：男" << endl;

	ofs.close();
}

/*
* 读文件
*/
void test02()
{
	ifstream ifs;
	ifs.open("./test.txt", ios::in); //ios::in 以输入方式打开文件

	//判断是否打开成功
	if (!ifs.is_open())
		cout << "打开失败" << endl;

	/*
	* 第一种方式：按行读取 （推荐）
	*/
	char buf[1024];
	while (ifs >>buf) //按行读取
		cout << buf << endl;
	/* Output:
	  姓名：abc
	  年龄：100
	  性别：男
	*/

	/*
	* 第二种方式：eof读到文件尾
	*/
	//char buf2[1024];
	//while (!ifs.eof()){ //eof读到文件尾
	//	ifs.getline(buf2, sizeof(buf2));
	//	cout << buf2 << endl;
	//}
	/* Output:
	  姓名：abc
	  年龄：100
	  性别：男

	*/

	/*
	* 第三种 不推荐 按单个字符读取
	*/
	//char c;
	//while ( (c = ifs.get() ) != EOF) // EOF文件尾
	//	cout << c;
	/* Output:
	  姓名：abc
	  年龄：100
	  性别：男
	*/

	ifs.close();
}


int main(){
	//test01(); //写文件
	test02();   //读文件

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
姓名：abc
年龄：100
性别：男
请按任意键继续. . .
*/