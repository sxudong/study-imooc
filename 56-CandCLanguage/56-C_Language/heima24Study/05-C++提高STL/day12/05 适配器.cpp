#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include <string>
using namespace std;


/*
* 总结：bind1st 和 bind2nd 区别?
*   bind1st：将参数“绑定”为“函数对象的第一个参数”
*   bind2nd：将参数“绑定”为“函数对象的第二个参数”
*   bind1st 和 bind2nd 用于将“二元函数对象”转为“一元函数对象”。
*
* 个人理解：其实就是绑定之后，两个参数，一个是bind绑定的固定的值，另一个不是固定的，其中一个是固定的就成一元的了。
*/


/*
* 函数适配器
*
* 现在我有这个需求：在遍历容器的时候，我希望将容器中的值全部加上100之后显示出来，怎么做？
*   我们直接给函数对象绑定参数 编译阶段就会报错
*   for_each(v.begin(), v.end(), bind2nd(myprint(),100));
*   如果我们想使用绑定适配器,需要我们自己的函数对象继承binary_function 或者 unary_function
*   根据我们函数对象是一元函数对象 还是二元函数对象
*/


/*
* 第一步 绑定 数据 bind2nd
*   继承类 binary_function<参数类型1 ，参数类型2 ，返回值类型>
*   加const修饰 operator()
*/
class MyPrint : public binary_function<int,int,void>
{
public:
	//()重写
	void operator()(int v ,int start) const{
		cout << "v = "<< v << " start = "<< start << " v+start = "<< v  + start<< endl;
	}
};

void test01()
{
	vector<int> v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	cout << "请输入起始值" << endl;

	int num;
	cin >> num;

	//bind1st 是将传入参数绑定到第一个参数
	//bind2nd 是将传入参数绑定到第二个参数
	//成员函数适配器
	//for_each(v.begin(), v.end(), bind2nd( MyPrint(),num) ); //绑定数组到 operator()(int v ,int start)第二个参数 start 上
	for_each(v.begin(), v.end(), bind1st(MyPrint(), num));    //绑定数组到 operator()(int v ,int start)第一个参数 v 上
}
/* Output:
请输入起始值
5
v = 5 start = 0 v+start = 5
v = 5 start = 1 v+start = 6
v = 5 start = 2 v+start = 7
v = 5 start = 3 v+start = 8
v = 5 start = 4 v+start = 9
v = 5 start = 5 v+start = 10
v = 5 start = 6 v+start = 11
v = 5 start = 7 v+start = 12
v = 5 start = 8 v+start = 13
v = 5 start = 9 v+start = 14
*/


/*
* 否定谓词 not1() not2()
* not1 是构造一个与谓词结果“相反”的一元函数对象。
* not2 是构造一个与谓词结果“相反”的二元函数对象。
*/

/*
* 一元取反适配器  not1
*   继承 unary_function <参数类型1，返回值类型>
*   const修饰
*/
class GreaterThenFive : public unary_function<int,bool>
{
public:
	//()重写
	bool operator()(int v) const{
		return v > 5;
	}
};


//取反适配器
void test02()
{
	//一元取反
	vector<int> v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	//查找大于5的数字
	//vector<int>::iterator pos1 =  find_if(v.begin(), v.end(), GreaterThenFive()); //返回第一个小于5迭代器
	//if (pos1 != v.end())
	//	cout << "找到大于5的数字为 " << *pos1 << endl; //找到小于5的数字为 6
	//else
	//	cout << "未找到" << endl;

	//需求改为 找小于5的数字
	//vector<int>::iterator pos1 =  find_if(v.begin(), v.end(), not1( GreaterThenFive())); //GreaterThenFive()大于5，not1 一元函数取反就是小于5
	//if (pos1 != v.end())
	//	cout << "找到小于5的数字为 " << *pos1 << endl; //找到小于5的数字为 0  //第一个小于5的数是0
	//else
	//	cout << "未找到" << endl;

	//需求改为 找小于5的数字
	vector<int>::iterator pos = find_if(v.begin(), v.end(), not1(bind2nd(greater<int>(),5) )); //greater内建函数对象 大于，取返就是小于5。（less内建函数对象 小于）
	if (pos != v.end())
		cout << "找到小于5的数字为 " << *pos << endl; //找到小于5的数字为 0 //第一个小于5的数是0
	else
		cout << "未找到" << endl;

	//vector<int>::iterator pos = find_if(v.begin(), v.end(), not1(bind2nd(less<int>(), 5))); //less内建函数对象 小于，not1 一元函数取反就是大于5
	//if (pos != v.end())
	//	cout << "找到大于5的数字为 " << *pos << endl; //找到大于5的数字为 5 // >= 5, 所以是5
	//else
	//	cout << "未找到" << endl;
}



void MyPrint03(int v,int start) {
	cout << v + start << endl;
}

/*
* 函数指针适配器 ptr_fun()
*/
void test03()
{
	vector<int> v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	//将函数指针 适配为 函数对象
	//ptr_fun( )把一个普通的函数指针适配成函数对象
	for_each(v.begin(), v.end(), bind2nd( ptr_fun( MyPrint03) ,100 ));
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
*/



/*
* 成员函数适配器 mem_fun_ref
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

	void showPerson(){
		cout << "成员函数中：姓名： " << m_Name << " 年龄：" << m_Age << endl;
	}

	void plusAge(){
		this->m_Age = this->m_Age + 100;
	}
};

void MyPrintPerson( Person & p){
	cout << "姓名： " << p.m_Name << " 年龄：" << p.m_Age << endl;
}

void test04()
{
	vector<Person>v;

	Person p1("aaa", 10);
	Person p2("bbb", 15);
	Person p3("ccc", 18);
	Person p4("ddd", 40);

	v.push_back(p1);
	v.push_back(p2);
	v.push_back(p3);
	v.push_back(p4);

	//成员函数适配器
	//利用 mem_fun_ref 将Person内部成员函数适配
	for_each(v.begin(), v.end(), mem_fun_ref(&Person::showPerson));
	for_each(v.begin(), v.end(), mem_fun_ref(&Person::plusAge));    //年龄加100
	for_each(v.begin(), v.end(), mem_fun_ref(&Person::showPerson));
}
/* Output:
成员函数中：姓名： aaa 年龄：10
成员函数中：姓名： bbb 年龄：15
成员函数中：姓名： ccc 年龄：18
成员函数中：姓名： ddd 年龄：40
成员函数中：姓名： aaa 年龄：110
成员函数中：姓名： bbb 年龄：115
成员函数中：姓名： ccc 年龄：118
成员函数中：姓名： ddd 年龄：140
*/


int main(){
	test01();
	cout << "---------------" << endl;
	test02();
	cout << "---------------" << endl;
	test03();
	cout << "---------------" << endl;
	test04();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
请输入起始值
5
v = 5 start = 0 v+start = 5
v = 5 start = 1 v+start = 6
v = 5 start = 2 v+start = 7
v = 5 start = 3 v+start = 8
v = 5 start = 4 v+start = 9
v = 5 start = 5 v+start = 10
v = 5 start = 6 v+start = 11
v = 5 start = 7 v+start = 12
v = 5 start = 8 v+start = 13
v = 5 start = 9 v+start = 14
---------------
找到小于5的数字为 0
---------------
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
---------------
成员函数中：姓名： aaa 年龄：10
成员函数中：姓名： bbb 年龄：15
成员函数中：姓名： ccc 年龄：18
成员函数中：姓名： ddd 年龄：40
成员函数中：姓名： aaa 年龄：110
成员函数中：姓名： bbb 年龄：115
成员函数中：姓名： ccc 年龄：118
成员函数中：姓名： ddd 年龄：140
请按任意键继续. . .
*/