#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
#include <list>
using namespace std;


void test01()
{
	vector<int> v;
	for (int i = 0; i < 10; i++){
		v.push_back(i);
		cout << v.capacity() << endl;  // v.capacity()容器的容量
	}
}
/* Output:
1
2
3
4
6
6
9
9
9
13
*/



/*
* vector构造函数
*
* vector<T> v;                //采用模板实现类实现，默认构造函数
* vector(v.begin(), v.end()); //将v[begin(), end())区间中的元素拷贝给本身。
* vector(n, elem);            //构造函数将n个elem拷贝给本身。
* vector(const vector &vec);  //拷贝构造函数。
*
* 例子：使用第二个构造函数 我们可以...
* int arr[] = {2,3,4,1,9};
* vector<int> v1(arr, arr + sizeof(arr) / sizeof(int));
*/

/*
* 3.2.4.2 vector常用赋值操作
*
* assign(beg, end);                      //将[beg, end)区间中的数据拷贝赋值给本身。
* assign(n, elem);                       //将n个elem拷贝赋值给本身。
* vector& operator=(const vector  &vec); //重载等号操作符
* swap(vec);                             //将vec与本身的元素互换。
*/

/*
* 3.2.4.3 vector大小操作
*
* size();                //返回容器中元素的个数
* empty();               //判断容器是否为空
* resize(int num);       //重新指定容器的长度为num，若容器变长，则以默认值填充新位置。如果容器变短，则末尾超出容器长度的元素被删除。
* resize(int num, elem); //重新指定容器的长度为num，若容器变长，则以elem值填充新位置。如果容器变短，则末尾超出容器长>度的元素被删除。
* capacity();            //容器的容量
* reserve(int len);      //容器预留len个元素长度，预留位置不初始化，元素不可访问。
*/

void printVector( vector<int> & v){
	for (vector<int>::iterator it = v.begin(); it != v.end();it++)
		cout << *it << " ";

	cout << endl;
}

void test02()
{
	vector<int> v;
	int arr[] = { 2, 3, 4, 1, 9 };
	vector<int> v1(arr, arr + sizeof(arr) / sizeof(int));

	//创建数组
	vector<int> v2(v1.begin(), v1.end());
	printVector(v2); //2 3 4 1 9

	vector<int> v3(10, 100);
	printVector(v3); //100 100 100 100 100 100 100 100 100 100

	//赋值使用
	vector<int> v4;
	v4.assign(v3.begin(), v3.end());
	printVector(v4); //100 100 100 100 100 100 100 100 100 100


	v4.swap(v2);

	cout << "交换后的v4 " << endl;
	printVector(v4); // 2 3 4 1 9

	cout << "v4容器的大小" << v4.size() << endl; //5

	if (v4.empty())
		cout << "v4空" << endl;
	else
		cout << "v4不空" << endl; //v4不空

	//v4 23419
	v4.resize(10,-1); //第二个参数是默认值 ，默认0
	printVector(v4);  //2 3 4 1 9 -1 -1 -1 -1 -1

	v4.resize(3);
	printVector(v4);  //2 3 4

}



/*
* 巧用swap收缩空间
*/
void test03()
{
	vector<int> v;
	for (int i = 0; i < 100000; i++)
		v.push_back(i);

	cout << "v的容量" << v.capacity() << endl; //138255
	cout << "v的大小" << v.size() << endl;     //100000

	v.resize(3);

	cout << "v的容量" << v.capacity() << endl; //138255
	cout << "v的大小" << v.size() << endl;     //3

	//巧用swap
	vector<int>(v).swap(v);

	cout << "v的容量" << v.capacity() << endl; //3
	cout << "v的大小" << v.size() << endl;     //3
}




/*
* reserve(int len); 容器预留len个元素长度，预留位置不初始化，元素不可访问。
*/
void test04()
{
	vector<int> v;

	v.reserve(100000); //预留出空间

	int * p = NULL;
	int num = 0;
	for (int i = 0; i < 100000; i++){
		v.push_back(i);
		if (p != &v[0]){
			p = &v[0]; //等于数组首指针
			num++;
		}
	}
	cout << num << endl; //1
	// 开辟100000数据用了多少次
}



/*
* vector数据存取操作
*
* at(int idx); //返回索引idx所指的数据，如果idx越界，抛出out_of_range异常。
* operator[];  //返回索引idx所指的数据，越界时，运行直接报错
* front();     //返回容器中第一个数据元素
* back();      //返回容器中最后一个数据元素
*/

/*
* 3.2.4.5 vector插入和删除操作
*
* insert(const_iterator pos, int count,ele);       //迭代器指向位置pos插入count个元素ele.
* push_back(ele);                                  //尾部插入元素ele
* pop_back();                                      //删除最后一个元素
* erase(const_iterator start, const_iterator end); //删除迭代器从start到end之间的元素
* erase(const_iterator pos);                       //删除迭代器指向的元素
* clear();                                         //删除容器中所有元素
*/
void test05()
{
	vector<int> v;
	v.push_back(10);
	v.push_back(30);
	v.push_back(20);
	v.push_back(50);

	cout << "v的front" << v.front() << endl; //10
	cout << "v的back" << v.back() << endl;   //50

	//参数1：迭代器  参数2：N个数  参数3：具体插入的内容
	v.insert(v.begin(), 2 ,100);
	printVector(v); //100 100 10 30 20 50

	v.pop_back();   //尾删
	printVector(v); //100 100 10 30 20

	v.erase(v.begin()); //删除
	printVector(v);     //100 10 30 20

	//v.erase(v.begin(), v.end());
	v.clear(); //清空所有数据
	if (v.empty() )
		cout << "为空" << endl; //为空
}



void test06()
{
	//逆序遍历
	vector<int> v;
	for ( int  i = 0; i < 10; i++)
		v.push_back(i);
	//printVector(v); //0 1 2 3 4 5 6 7 8 9

	/*
	* reverse_iterator 逆序迭代器
	*/
	for (vector<int>::reverse_iterator i = v.rbegin(); i != v.rend(); i++)
		cout << *i << " ";  //9 8 7 6 5 4 3 2 1 0

	cout << endl;

	/*
	* vector迭代器 是随机访问的迭代器 支持跳跃式访问
	*/
	vector<int>::iterator itBegin = v.begin();
	itBegin = itBegin + 3;
	//如果上述写法不报错，这个迭代器是随机访问迭代器
	cout << *itBegin << endl; //3   //v 数组下标的第4个元素


	/*
	* list迭代器 不支持随机访问
	*/
	list<int> l;
	for (int i = 0; i < 10; i++)
		l.push_back(i);

	list<int>::iterator lIt = l.begin();
	//lIt = lIt + 1; //不支持随机访问
}


int main(){
	//test01();

	//test02();

	//test03();

	//test04();

	//test05();

	test06();

	system("pause");
	return EXIT_SUCCESS;
}