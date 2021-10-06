/*
* 4.5 常用排序算法
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <algorithm>
#include <vector>
#include <functional>
#include <ctime>


/*
* merge算法
*   容器元素合并，并存储到另一容器中，这两个容器必须也是有序的。
*
* @param beg1  容器1开始迭代器
* @param end1  容器1结束迭代器
* @param beg2  容器2开始迭代器
* @param end2  容器2结束迭代器
* @param dest  目标容器开始迭代器
*/
void test01()
{
	vector<int> v1;
	vector<int> v2;

	for (int i = 0; i < 10; i++){
		v1.push_back(i);     //0 开始
		v2.push_back(i + 1); //1 开始
	}

	vector<int> vTarget;
	vTarget.resize(v1.size() + v2.size());
	merge(v1.begin(), v1.end(), v2.begin(), v2.end(), vTarget.begin());

	for_each(vTarget.begin(), vTarget.end(), [](int v){ cout << v << " "; });
	cout << endl;
}
/* Output:
0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10
*/


/*
* sort算法 容器元素排序
* 注意：两个容器必须是有序的
*
* @param beg  容器1开始迭代器
* @param end  容器1结束迭代器
* @param _callback  回调函数或者谓词(返回bool类型的函数对象)
*/
void test02()
{
	vector<int> v1;

	v1.push_back(10);
	v1.push_back(40);
	v1.push_back(20);
	v1.push_back(90);
	v1.push_back(50);

	sort(v1.begin(), v1.end());
	for_each(v1.begin(), v1.end(), [](int val){cout << val << " "; });
	cout << endl;

	sort(v1.begin(), v1.end(), greater<int>());
	for_each(v1.begin(), v1.end(), [](int val){cout << val << " "; });
	cout << endl;
}
/* Output:
10 20 40 50 90
90 50 40 20 10
*/


/*
* random_shuffle(iterator beg, iterator end) 洗牌
*/
void test03()
{
	vector<int> v;
	for (int i = 0; i < 10;i++)
		v.push_back(i);

	random_shuffle(v.begin(), v.end());
	for_each(v.begin(), v.end(), [](int val){cout << val << " "; });
	cout << endl;
}
/* Output:
3 1 6 2 5 9 4 8 7 0
*/


/*
* reverse(iterator beg, iterator end)
*/
void test04()
{
	vector<int>v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	reverse(v.begin(), v.end());
	for_each(v.begin(), v.end(), [](int val){cout << val << " "; });
	cout << endl;
}
/* Output:
9 8 7 6 5 4 3 2 1 0
*/


int main(){
	srand((unsigned int)time(NULL)); //随机种子
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
0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10
---------------
10 20 40 50 90
90 50 40 20 10
---------------
2 8 7 9 4 3 5 1 6 0
---------------
9 8 7 6 5 4 3 2 1 0
请按任意键继续. . .
*/