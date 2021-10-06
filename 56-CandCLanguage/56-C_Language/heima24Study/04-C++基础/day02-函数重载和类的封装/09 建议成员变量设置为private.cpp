#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
8 建议将所有成员属性设置为私有
    8.1	自己提供公共的对外接口来进行 set或者get方法访问
*/

class Person
{

//类外不可访问，类内可以访问
private:
	int m_Age = 0;  //年龄 读写
	string m_Name;  //公有权限  读写
	string m_lover; //情人  只写

public:
	//设置年龄
	void setAge(int age)
	{
		if (age < 0 || age > 100){
			cout << "你这个老妖精" << endl;
			return;
		}
		m_Age = age;
	}
	//获取年龄 读权限
	int getAge(){
		return m_Age;
	}

	//读姓名
	string getName(){
		return m_Name;
	}

	//写姓名
	void setName(string name){
		m_Name = name;
	}

	//只写的情人
	void setLover(string lover){
		m_lover = lover;
	}
};

void test01()
{
	Person p1;
	p1.setName("老王");

	cout << "p1的姓名：" << p1.getName() << endl; //p1的姓名：老王

	//年龄
	p1.setAge(120); //你这个老妖精

	cout << "p1的年龄：" << p1.getAge() << endl; //p1的年龄：0

	//情人 只能设置 外部我不告诉你
	p1.setLover("仓井");

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1的姓名：老王
你这个老妖精
p1的年龄：0
请按任意键继续. . .
*/