#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
* 容器 vector，也叫「动态数组」
* Vector 这个名字应该来源自线性代数里「向量」的概念。
* 用法类似 Java 的 ArrayList
*/
#include <vector> 

//使用系统算法的头文件
#include <algorithm>



// 迭代器 遍历功能  用指针理解
/*
* 普通指针也算一种迭代器
*/
void test01()
{
	int array[5] = { 1, 3, 5, 6, 8 };

	int * p = array; //指针指向数组首地址  &array[0]

	for (int i = 0; i < 5;i ++){
		//cout << array[i] << endl;
		cout << *(p++) << endl;
	}
}
/* Output:
1
3
5
6
8
*/

void myPrint(int v){
	cout << v << endl;
}


/*
* 遍历容器中的数据 —— 利用迭代器
*/
void test02()
{
	//声明容器
	vector<int> v; //声明一个容器  这个容器中存放int类型数据 对象名称v
	//向容器中加入数据

	v.push_back(10);
	v.push_back(20);
	v.push_back(30);
	v.push_back(40);

	/*
	* 第一种遍历方式
	*/
	//vector<int>::iterator itBegin = v.begin(); //itBegin 指向的是v容器中的“起始位置”
	//vector<int>::iterator itEnd = v.end();     //itEnd 指向v容器中“最后一个位置”的“下一个地址”

	//while (itBegin != itEnd){
	//	cout << *itBegin << endl;
	//	itBegin++;
	//}


	/*
	* 第二种遍历方式
	*/
	//for (vector<int>::iterator i = v.begin(); i != v.end();i++)
	//	cout << *i << endl;

	/*
	* 第三种方式 利用算法
	*/
	for_each(v.begin(), v.end(), myPrint);
}
/* Output:
10
20
30
40
*/


/*
* 操作自定义数据类型
*/
class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;
		this->m_Age = age;
	}
};

void test03()
{
	vector<Person> v;
	Person p1("大头儿子", 10);
	Person p2("小头爸爸", 32);
	Person p3("隔壁王叔叔", 30);
	Person p4("围裙妈妈", 28);

	v.push_back(p1);
	v.push_back(p2);
	v.push_back(p3);
	v.push_back(p4);

	//遍历
	for (vector<Person>::iterator it = v.begin(); it != v.end();it++)
		cout << "姓名: " << (*it).m_Name << " 年龄：" << it->m_Age << endl;
}
/* Output:
姓名: 大头儿子 年龄：10
姓名: 小头爸爸 年龄：32
姓名: 隔壁王叔叔 年龄：30
姓名: 围裙妈妈 年龄：28
*/



/*
* 存放自定义数据类型的“指针”
*/
void test04()
{
	vector<Person *> v;
	Person p1("大头儿子", 10);
	Person p2("小头爸爸", 32);
	Person p3("隔壁王叔叔", 30);
	Person p4("围裙妈妈", 28);

	v.push_back(&p1);
	v.push_back(&p2);
	v.push_back(&p3);
	v.push_back(&p4);

	for (vector<Person*>::iterator i = v.begin(); i != v.end();i++)
		cout << "姓名：： " << (*i)->m_Name << " 年龄： " << (*i)->m_Age << endl;
}
/* Output:
姓名：： 大头儿子 年龄： 10
姓名：： 小头爸爸 年龄： 32
姓名：： 隔壁王叔叔 年龄： 30
姓名：： 围裙妈妈 年龄： 28
*/



/*
* 容器嵌套容器
*/
void test05()
{
	vector<vector<int>> v;

	vector<int>v1;
	vector<int>v2;
	vector<int>v3;


	for (int i = 0; i < 5;i++){
		v1.push_back(i);
		v2.push_back(i + 10);
		v3.push_back(i + 100);
	}

	//将小容器放入到大容器中
	v.push_back(v1);
	v.push_back(v2);
	v.push_back(v3);

	//遍历所有数据
	for (vector<vector<int>>::iterator i = v.begin(); i != v.end();i++){
		for (vector<int>::iterator j = (*i).begin(); j != (*i).end();j++)
			cout << *j << " ";

		cout << endl; 
	}
}
/* Output:
0 1 2 3 4
10 11 12 13 14
100 101 102 103 104
*/


int main(){

	test01();
	cout << "------------------------" << endl;
	test02();
	cout << "------------------------" << endl;
	test03();
	cout << "------------------------" << endl;
	test04();
	cout << "------------------------" << endl;
	test05();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1
3
5
6
8
------------------------
10
20
30
40
------------------------
姓名: 大头儿子 年龄：10
姓名: 小头爸爸 年龄：32
姓名: 隔壁王叔叔 年龄：30
姓名: 围裙妈妈 年龄：28
------------------------
姓名：： 大头儿子 年龄： 10
姓名：： 小头爸爸 年龄： 32
姓名：： 隔壁王叔叔 年龄： 30
姓名：： 围裙妈妈 年龄： 28
------------------------
0 1 2 3 4
10 11 12 13 14
100 101 102 103 104
*/