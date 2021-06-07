#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
* �ڽ���������ͷ�ļ�
*/
#include <functional>
#include <vector>
#include <algorithm>


/*
* 6�������ຯ������,����negate��һԪ���㣬�������Ƕ�Ԫ���㡣
*   template<class T> T plus<T>       //�ӷ��º���
*   template<class T> T minus<T>      //�����º���
*   template<class T> T multiplies<T> //�˷��º���
*   template<class T> T divides<T>    //�����º���
*   template<class T> T modulus<T>    //ȡģ�º���
*   template<class T> T negate<T>     //ȡ���º���
*/

/*
* 6����ϵ�����ຯ������,ÿһ�ֶ��Ƕ�Ԫ���㡣
*   template<class T> bool equal_to<T>      //����
*   template<class T> bool not_equal_to<T>  //������
*   template<class T> bool greater<T>       //����
*   template<class T> bool greater_equal<T> //���ڵ���
*   template<class T> bool less<T>          //С��
*   template<class T> bool less_equal<T>    //С�ڵ���
*/

/*
* �߼����������㺯��,notΪһԪ���㣬����Ϊ��Ԫ���㡣
*   template<class T> bool logical_and<T> //�߼���
*   template<class T> bool logical_or<T>  //�߼���
*   template<class T> bool logical_not<T> //�߼���
*/
void test01()
{
	/*
	* template<class T> T negate<T> //ȡ���º���
	*/
	negate<int> n;
	cout << n(10) << endl;   //-10

	/*
	* �ӷ�  template<class T> T plus<T>//�ӷ��º���
	*/
	plus<int> p;
	cout << p(1, 1) << endl; //2
}


/*
* template<class T> bool greater<T> //����
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