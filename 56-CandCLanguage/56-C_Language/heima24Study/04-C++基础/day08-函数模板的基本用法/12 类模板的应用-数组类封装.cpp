#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "MyArray.hpp"
#include <string>


/*
* 《c++讲义 第二部分》1.8 类模板的应用 —— 数组封装
*/

//输出int类型数组
void printIntArray( MyArray<int> & array ) //引用的本质是指针
{
	for (int i = 0; i < array.getSize();i++)
		cout << array[i] << endl;
}

class Person
{
public:
	string m_Name;
	int m_Age;

	Person(){}; //默认构造

	Person(string name, int age){
		this->m_Name = name;
		this->m_Age = age;
	}
};



//输出Person类型数组
void printPersonArray( MyArray<Person> & array )
{
	for (int  i = 0; i < array.getSize(); i++)
		cout << "姓名： " << array[i].m_Name << " 年龄： " << array[i].m_Age << endl;
}



int main(){

	//创建int类型数组
	MyArray<int> arr(10);
	for (int i = 0; i < 10;i++)
		arr.push_Back(i + 100);

	printIntArray(arr);

	Person p1("MT", 10);
	Person p2("呆贼", 12);
	Person p3("傻馒", 14);
	Person p4("劣人", 15);

	//创建Person类型数组
	MyArray<Person> arr2(10);
	arr2.push_Back(p1);
	arr2.push_Back(p2);
	arr2.push_Back(p3);
	arr2.push_Back(p4);

	printPersonArray(arr2);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
100
101
102
103
104
105
106
107
108
109
姓名： MT 年龄： 10
姓名： 呆贼 年龄： 12
姓名： 傻馒 年龄： 14
姓名： 劣人 年龄： 15
请按任意键继续. . .
*/