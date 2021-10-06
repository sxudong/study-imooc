/*
* 4.3 常用遍历算法
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <algorithm>
#include <vector>
#include <functional>
using namespace std;


/*
* 遍历算法 遍历容器元素
*
* @param beg  开始迭代器
* @param end  结束迭代器
* @param _callback  函数回调或者函数对象
* @return  函数对象
*/

void myPrint(int v){ //普通函数方法
	cout << v << endl;
}

struct myPrint01 //类 （struct与class是一样的）
{
	//()重载
	void operator()(int v){
		cout << v << endl;
	}
};

void test01()
{
	vector<int> v;
	for (int i = 0; i < 10;i++)
		v.push_back(i);

	//for_each(v.begin(), v.end(), myPrint);
	for_each(v.begin(), v.end(), myPrint01());
}
/* Output:
0
1
2
3
4
5
6
7
8
9
*/


struct myPrint02
{
	int m_Count;

	//()重载
	void operator()(int v){
		cout << v << endl;
		m_Count++;
	}
};

/*
* 2 for_each有返回值
*/
void test02()
{
	vector<int>v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	myPrint02 print2 = for_each(v.begin(), v.end(), myPrint02());
	cout << print2.m_Count << endl;
}
/* Output:
0
1
2
3
4
5
6
7
8
9
10
*/


/*
* 3 for_each可以绑定参数进行输出
*/
struct myPrint03 : public binary_function<int,int,void>
{
	//重写 operator()
	void operator()(int v ,int start) const{
		cout << v  + start << endl;
	}
};

void test03()
{
	vector<int>v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	for_each(v.begin(), v.end(), bind2nd(myPrint03(), 10000));
}
/* Output:
10000
10001
10002
10003
10004
10005
10006
10007
10008
10009
*/

/*
* transform算法 将指定容器区间元素搬运到另一容器中
* 注意 : transform 不会给目标容器分配内存，所以需要我们提前分配好内存
*
* @param beg1  源容器开始迭代器
* @param end1  源容器结束迭代器
* @param beg2  目标容器开始迭代器
* @param _cakkback  回调函数或者函数对象
* @return  返回目标容器迭代器
*/
class TransForm
{
public:
	//重载 operator()
	int operator()(int val){
		return val + 10;
	}
};

void test04()
{
	vector<int> vSource; //原容器
	for (int i = 0; i < 10; i++)
		vSource.push_back(i);

	vector<int> vTarget; //目标容器
	vTarget.resize(vSource.size());

	transform(vSource.begin(), vSource.end(), vTarget.begin(), TransForm());

	for_each(vTarget.begin(), vTarget.end(), [](int val){ cout << val << " "; });
}
/* Output:
10 11 12 13 14 15 16 17 18 19
*/


/*
* transform 第二种用法
* 将两个容器数据相加搬运到目标容器
*/
class TransForm2
{
public:
	//重载 operator()
	int operator()(int val ,int val2){
		return val + val2;
	}
};

void test05()
{
	vector<int> v1;
	vector<int> v2;
	for (int i = 0; i < 10;i++){
		v1.push_back(100 + i);
		v2.push_back(200 + i);
	}

	vector<int> vTarget; //目标容器
	vTarget.resize(v1.size());
	transform(v1.begin(), v1.end(), v2.begin(), vTarget.begin(), TransForm2());

	// 300 302...
	for_each(vTarget.begin(), vTarget.end(), [](int val){ cout << val << " "; });
}
/* Output:
300 302 304 306 308 310 312 314 316 318
*/

int main(){

	test01();
	cout << "---------------" << endl;
	test02();
	cout << "---------------" << endl;
	test03();
	cout << "---------------" << endl;
	test04();
	cout << "---------------" << endl;
	test05();
	cout << endl;
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1
2
3
4
5
6
7
8
9
10
---------------
10000
10001
10002
10003
10004
10005
10006
10007
10008
10009
---------------
10 11 12 13 14 15 16 17 18 19 ---------------
300 302 304 306 308 310 312 314 316 318
请按任意键继续. . .
*/