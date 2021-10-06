#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
#include <string>
#include <map>
#include <ctime>
using namespace std;

/*
* 需求：
*   公司今天招聘了5个员工，5名员工进入公司之后，需要指派员工在那个部门工作
*   人员信息有: 姓名 年龄 电话 工资等组成
*   通过 Multimap 进行信息的插入 保存 显示
*   分部门显示员工信息 显示全部员工信息
*/

enum{ RENLI,YANFA,MEISHU };

class Worker
{
public:
	string m_Name;
	int m_Money;
};


void createWorker(vector<Worker>&v ){
	string nameSeed = "ABCDE";
	for (int i = 0; i < 5;i++){
		string name = "员工";
		name += nameSeed[i];

		int money = rand() % 10000 + 10000; // 10000~ 19999

		Worker w;
		w.m_Name = name;
		w.m_Money = money;

		v.push_back(w);
	}
}

void setGroup( vector<Worker> & v, multimap<int,Worker> & m ){
	for (vector<Worker>::iterator i = v.begin(); i != v.end(); i++){
		//随机产生部门编号
		int departmentId = rand() % 3; // 0 1 2
		//将员工分到 multimap容器中
		m.insert(make_pair(departmentId, *i));
	}
}

void showGroup( multimap<int,Worker> & m )
{
	//人力部门显示
	cout << "人力部门员工如下：" << endl;

	multimap<int,Worker>::iterator pos = m.find(RENLI); //枚举下标 0
	int index = 0;
	int num = m.count(RENLI); //枚举下标 0 的总数量
	for (; pos != m.end(), index < num; pos++, index++) // 0  A  B  1  C  2  D E
		cout << "姓名：" << pos->second.m_Name << " 工资：" << pos->second.m_Money << endl;

	cout << "-------------------------" << endl;

	cout << "研发部门员工如下：" << endl;
	pos = m.find(YANFA); //枚举下标 1
	index = 0;
	num = m.count(YANFA); //枚举下标 1 的总数量
	for (; pos != m.end(), index < num; pos++, index++) // 0  A  B  1  C  2  D E
		cout << "姓名：" << pos->second.m_Name << " 工资：" << pos->second.m_Money << endl;

	cout << "-------------------------" << endl;

	cout << "美术部门员工如下：" << endl;
	pos = m.find(MEISHU); //枚举下标 2
	index = 0;
	num = m.count(MEISHU); //枚举下标 2 的总数量
	for (; pos != m.end(), index < num; pos++, index++) // 0  A  B  1  C  2  D E
		cout << "姓名：" << pos->second.m_Name << " 工资：" << pos->second.m_Money << endl;

}

int main(){

	srand((unsigned int)time(NULL));

	//声明一个存放员工的容器
	vector<Worker> v;

	//创建5名员工
	createWorker(v);

	//设置分组
	//分组的multimap容器
	multimap<int, Worker> m;
	setGroup(v,m);

	//分部门显示员工
	showGroup(m);

	cout << "----------" << endl;

	////员工创建测试
	for (vector<Worker>::iterator i = v.begin(); i != v.end(); i++)
		cout << "姓名： " << i->m_Name << " 工资： " << i->m_Money << endl;

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
人力部门员工如下：
姓名：员工E 工资：13136
-------------------------
研发部门员工如下：
姓名：员工B 工资：14911
姓名：员工C 工资：10230
-------------------------
美术部门员工如下：
姓名：员工A 工资：10490
姓名：员工D 工资：17100
----------
姓名： 员工A 工资： 10490
姓名： 员工B 工资： 14911
姓名： 员工C 工资： 10230
姓名： 员工D 工资： 17100
姓名： 员工E 工资： 13136
请按任意键继续. . .
*/