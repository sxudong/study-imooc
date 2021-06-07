#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
#include <algorithm>
using namespace std;

class GreaterThen20
{
public:
	//()重载
	bool operator()(int val){
		return val > 20;
	}
};


/*
* 一元谓词: 函数参数1个，函数返回值是bool类型，可以作为一个判断式
*/
void test01()
{
	vector<int> v;
	v.push_back(10);
	v.push_back(20);
	v.push_back(30);
	v.push_back(40);
	v.push_back(50);

	/*
	* 需求：查找第一个大于20的数字
	*/

	//第三个参数：函数对象  匿名对象
	vector<int>::iterator pos = find_if(v.begin(), v.end(), GreaterThen20());
	if (pos!=v.end())
		cout << "找到大于20的数字为：" << *pos << endl; //找到大于20的数字为：30
	else
		cout << "未找到" << endl;
}

/*
* 二元谓词: 函数参数2个，函数返回值是bool类型
*/
class MyCompare
{
public:
	//()重载
	bool operator()(int v1,int v2){
		return v1 > v2;
	}
};
void test02()
{
	vector<int> v;
	v.push_back(10);
	v.push_back(20);
	v.push_back(30);
	v.push_back(40);
	v.push_back(50);

	sort(v.begin(), v.end(), MyCompare());

	/*
	* 匿名函数  lambda表达式  [](){};
	*/
	for_each(v.begin(), v.end(), [](int val){ cout << val << " "; });
}
/* Output:
50 40 30 20 10
*/

int main(){
	test01();
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
找到大于20的数字为：30
50 40 30 20 10 请按任意键继续. . .
*/