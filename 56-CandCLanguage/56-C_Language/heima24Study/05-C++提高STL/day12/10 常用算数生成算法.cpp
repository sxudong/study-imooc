/*
* 4.7 常用算数生成算法
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
using namespace std;
#include <algorithm> //不好使
#include <numeric>   //好使
#include <iterator>


/*
* accumulate算法
*   计算容器元素累计总和
*
* @param beg  容器开始迭代器
* @param end  容器结束迭代器
* @param value  累加值
*/
void test01()
{
	vector<int> v;
	for (int i = 0; i <= 100;i++)
		v.push_back(i);

	//0~100累积和  5050
	//第三个参数  起始累加值
	int sum = accumulate(v.begin(), v.end(), 0);
	cout << "总和为：" << sum << endl; //5050
}


/*
* fill算法
*   向容器中添加元素
*
* @param beg  容器开始迭代器
* @param end  容器结束迭代器
* @param value  填充元素
*/
void test02()
{
	vector<int> v;
	v.resize(10);

	//填充
	fill(v.begin(), v.end(), 1000);

	copy(v.begin(), v.end(), ostream_iterator<int>(cout, " "));
	cout << endl;
}

int main(){
	test01();
	cout << "---------------" << endl;
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
总和为：5050
---------------
1000 1000 1000 1000 1000 1000 1000 1000 1000 1000
请按任意键继续. . .
*/