#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
* 内建函数对象头文件
*/
#include <functional>
#include <vector>
#include <algorithm>


/*
* 6个算数类函数对象,除了negate是一元运算，其他都是二元运算。
*   template<class T> T plus<T>       //加法仿函数
*   template<class T> T minus<T>      //减法仿函数
*   template<class T> T multiplies<T> //乘法仿函数
*   template<class T> T divides<T>    //除法仿函数
*   template<class T> T modulus<T>    //取模仿函数
*   template<class T> T negate<T>     //取反仿函数
*/

/*
* 6个关系运算类函数对象,每一种都是二元运算。
*   template<class T> bool equal_to<T>      //等于
*   template<class T> bool not_equal_to<T>  //不等于
*   template<class T> bool greater<T>       //大于
*   template<class T> bool greater_equal<T> //大于等于
*   template<class T> bool less<T>          //小于
*   template<class T> bool less_equal<T>    //小于等于
*/

/*
* 逻辑运算类运算函数,not为一元运算，其余为二元运算。
*   template<class T> bool logical_and<T> //逻辑与
*   template<class T> bool logical_or<T>  //逻辑或
*   template<class T> bool logical_not<T> //逻辑非
*/
void test01()
{
	/*
	* template<class T> T negate<T> //取反仿函数
	*/
	negate<int> n;
	cout << n(10) << endl;   //-10

	/*
	* 加法  template<class T> T plus<T>//加法仿函数
	*/
	plus<int> p;
	cout << p(1, 1) << endl; //2
}


/*
* template<class T> bool greater<T> //大于
*/
void test02()
{
	vector<int> v;

	v.push_back(10);
	v.push_back(30);
	v.push_back(50);
	v.push_back(20);
	v.push_back(40);

	sort(v.begin(), v.end(), greater<int>());

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