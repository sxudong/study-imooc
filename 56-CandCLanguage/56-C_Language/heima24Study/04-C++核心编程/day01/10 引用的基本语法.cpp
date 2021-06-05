#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
* 《C++ Primer Plus》 8.2 引用变量
*/


/*
* 1、引用基本语法  Type &别名 = 原名
*    “引用”就是“取别名”
*    &写在左侧，叫“引用”。写到右侧，取地址。
*/
void test01()
{
	int a = 10;
	int &b = a;

	b = 20;

	cout << "a = " << a << endl; //a = 20
	cout << "b = " << b << endl; //b = 20
}


/*
* 2、引用必须初始化
*/
void test02()
{
	//int &a; 必须初始化
	int a = 10;
	int &b = a; //引用初始化后，“别名”不可以修改了
	int c = 20;

	b = c; //这里是赋值，不可以再修改“别名”
}

/*
* 3、对数组建立引用
*/
void test03()
{
	int arr[10];
	for (int i = 0; i < 10;i++)
		arr[i] = i;

	//给“数组”起别名
	int(&pArr)[10] = arr;
	for (int i = 0; i < 10;i++)
		cout << pArr[i] << " ";

	cout << endl;

	/*
	* 第二种方式 起别名
	*/
	typedef int(ARRAYREF)[10]; //一个具有10个元素的int类型的数组
	ARRAYREF &pArr2 = arr;

	for (int i = 0; i < 10; i++)
		cout << pArr2[i] << " ";

	cout << endl;

}


int main(){

	test01();

	cout << "--------------" << endl;

	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
a = 20
b = 20
--------------
0 1 2 3 4 5 6 7 8 9
0 1 2 3 4 5 6 7 8 9
请按任意键继续. . .
*/