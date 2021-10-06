/*
* 4.8 常用集合算法
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <algorithm>
#include <vector>
#include <iterator>
using namespace std;

/*
* set_intersection算法
*   求两个set集合的交集
*   注意:两个集合必须是有序序列
*
* @param beg1  容器1开始迭代器
* @param end1  容器1结束迭代器
* @param beg2  容器2开始迭代器
* @param end2  容器2结束迭代器
* @param dest  目标容器开始迭代器
* @return  目标容器的最后一个元素的迭代器地址
*/
void test01()
{
	vector<int> v1;
	vector<int> v2;

	for (int i = 0; i < 10;i++){
		v1.push_back(i);
		v2.push_back(i + 5);
	}

	vector<int> vTarget;
	vTarget.resize( min(v1.size(),v2.size()));

	//set_intersection算法 求两个set集合的交集
	vector<int>::iterator itEnd= set_intersection(v1.begin(), v1.end(), v2.begin(), v2.end(), vTarget.begin());

	copy(vTarget.begin(), itEnd, ostream_iterator<int>(cout, " "));
	cout << endl;
}
/* Output:
5 6 7 8 9
*/


/*
* set_union算法
*   求两个set集合的并集
*   注意:两个集合必须是有序序列
*
* @param beg1  容器1开始迭代器
* @param end1  容器1结束迭代器
* @param beg2  容器2开始迭代器
* @param end2  容器2结束迭代器
* @param dest  目标容器开始迭代器
* @return  目标容器的最后一个元素的迭代器地址
*/
void test02()
{
	vector<int> v1;
	vector<int> v2;

	for (int i = 0; i < 10; i++){
		v1.push_back(i);
		v2.push_back(i + 5);
	}

	vector<int> vTarget;
	vTarget.resize(v1.size()+v2.size());

	//set_union算法 求两个set集合的并集
	vector<int>::iterator itEnd = set_union(v1.begin(), v1.end(), v2.begin(), v2.end(), vTarget.begin());

	copy(vTarget.begin(), itEnd, ostream_iterator<int>(cout, " "));
	cout << endl;
}
/* Output:
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14
*/


/*
* set_difference算法
*   求两个set集合的差集
*   注意:两个集合必须是有序序列
*
* @param beg1  容器1开始迭代器
* @param end1  容器1结束迭代器
* @param beg2  容器2开始迭代器
* @param end2  容器2结束迭代器
* @param dest  目标容器开始迭代器
* @return  目标容器的最后一个元素的迭代器地址
*/
void test03()
{
	vector<int> v1;
	vector<int> v2;

	for (int i = 0; i < 10; i++){
		v1.push_back(i);
		v2.push_back(i + 5);
	}

	vector<int> vTarget;
	vTarget.resize( max(v1.size(),v2.size() ));

	//v1 差 v2 求两个set集合的差集
	vector<int>::iterator itEnd = set_difference(v1.begin(), v1.end(), v2.begin(), v2.end(), vTarget.begin());

	copy(vTarget.begin(), itEnd, ostream_iterator<int>(cout, " "));
	cout << endl;

	//v2 差 v1 求两个set集合的差集
	itEnd = set_difference(v2.begin(), v2.end(), v1.begin(), v1.end(), vTarget.begin());
	copy(vTarget.begin(), itEnd, ostream_iterator<int>(cout, " "));
	cout << endl;
}
/* Output:
0 1 2 3 4
10 11 12 13 14
*/

int main(){
	test01();
	cout << "---------------" << endl;
	test02();
	cout << "---------------" << endl;
	test03();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
5 6 7 8 9
---------------
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14
---------------
0 1 2 3 4
10 11 12 13 14
请按任意键继续. . .
*/