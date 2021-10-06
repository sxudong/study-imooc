#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <map>
using namespace std;

/*
* map构造函数
*   map<T1, T2> mapTT;             //map默认构造函数:
*   map(const map &mp);            //拷贝构造函数
* 
* 3.8.2.2 map赋值操作
*   map& operator=(const map &mp); //重载等号操作符
*   swap(mp);                      //交换两个集合容器
* 
* 3.8.2.3 map大小操作
*   size();                        //返回容器中元素的数目
*   empty();                       //判断容器是否为空
* 
* 3.8.2.4 map插入数据元素操作
*   map.insert(...);              //往容器插入元素，返回pair<iterator,bool>
*   map<int, string> mapStu;
* 
*    // 第一种 通过pair的方式插入对象
*    mapStu.insert(pair<int, string>(3, "小张"));
* 
*    // 第二种 通过pair的方式插入对象
*    mapStu.inset(make_pair(-1, "校长"));
* 
*    // 第三种 通过value_type的方式插入对象
*    mapStu.insert(map<int, string>::value_type(1, "小李"));
* 
*    // 第四种 通过数组的方式插入值
*    mapStu[3] = "小刘";
*    mapStu[5] = "小王";
*/

void test01()
{
	map<int, int> m;

	/*
	* 插入值 4种方式
	*/
	//第一种
	m.insert(pair<int, int>(1, 10));
	//第二种 推荐
	m.insert(make_pair(2, 20));
	//第三种 不推荐
	m.insert(map<int, int>::value_type(3, 30));
	//第四种 如果保证key存在 ，那么可以通过[]访问
	m[4] = 40;

	for (map<int, int>::iterator it = m.begin(); it != m.end();it++)
		cout << "key = " << it->first << " value = " << it->second << endl;

	cout << m[5] <<endl;

	for (map<int, int>::iterator it = m.begin(); it != m.end(); it++)
		cout << "key = " << it->first << " value = " << it->second << endl;

	cout << m[4] << endl;

	if ( m.empty())
		cout << "空" << endl;
	else
		cout << "size = " << m.size() << endl;
}
/* Output:
key = 1 value = 10
key = 2 value = 20
key = 3 value = 30
key = 4 value = 40
0
key = 1 value = 10
key = 2 value = 20
key = 3 value = 30
key = 4 value = 40
key = 5 value = 0    //多出一个key = 5
40
size = 5
*/



/*
* map删除操作
*   clear();              //删除所有元素
*   erase(pos);           //删除pos迭代器所指的元素，返回下一个元素的迭代器。
*   erase(beg,end);       //删除区间[beg,end)的所有元素 ，返回下一个元素的迭代器。
*   erase(keyElem);       //删除容器中key为keyElem的对组。
* 
* 3.8.2.6 map查找操作
*   find(key);            //查找键key是否存在,若存在，返回该键的元素的迭代器；/若不存在，返回map.end();
*   count(keyElem);       //返回容器中key为keyElem的对组个数。对map来说，要么是0，要么是1。对multimap来说，值可能大于1。
*   lower_bound(keyElem); //返回第一个 key >= keyElem 元素的迭代器。
*   upper_bound(keyElem); //返回第一个 key > keyElem 元素的迭代器。
*   equal_range(keyElem); //返回容器中key与keyElem相等的“上下限”的两个迭代器。
*/
void test02()
{
	map<int, int> m;
	m.insert(pair<int, int>(1, 10));
	m.insert(make_pair(2, 20));
	m.insert(map<int, int>::value_type(3, 30));
	m[4] = 40;

	m.erase(1); //删除 key = 1 的元素
	for (map<int, int>::iterator it = m.begin(); it != m.end(); it++)
		cout << "key = " << it->first << " value" << it->second << endl;

	map<int,int>::iterator pos = m.find(2); //查看key = 2 的元素
	if (pos != m.end())
		cout << "找到 key:" << pos->first << " value:" << pos->second << endl; //找到 key:2 value:20
	else
		cout << "未找到" << endl; 


	int num  = m.count(3); //map的count 要么0 要么1 
	cout << "num = " << num << endl;

	/*
	* lower_bound(keyElem); 返回第一个 key >= keyElem 元素的迭代器。
	*/
	map<int,int>::iterator ret = m.lower_bound(3);
	if (ret != m.end())
		cout << "lower_bound 中key" << ret->first << " value: " << ret->second << endl; //30  "20 30 40" key >= 3, 30
	else
		cout << "未找到" << endl;


	/*
	* pper_bound(keyElem); 返回第一个 key > keyElem 元素的迭代器。
	*/
	ret = m.upper_bound(3);
	if (ret != m.end())
		cout << "upper_bound 中key" << ret->first << " value: " << ret->second << endl; //40  "20 30 40" key > 3, 40
	else
		cout << "未找到" << endl;


	/*
	* equal_range(keyElem); 返回容器中key与keyElem相等的“上下限”的两个迭代器。
	*/
	pair<map<int, int>::iterator, map<int, int>::iterator> ret2 = m.equal_range(3);

	if (ret2.first != m.end())
		cout << "找到了equal_range 中的lower_bound 的key " << ret2.first->first << " value: " << ret2.first->second << endl;  //30  "20 30 40" key >= 3, 30
	else
		cout << "未找到" << endl;


	if (ret2.second != m.end())
		cout << "找到了equal_range 中的upper_bound 的key " << ret2.second->first << " value: " << ret2.second->second << endl; //40  "20 30 40" key > 3, 40
	else
		cout << "未找到" << endl;
}
/* Output:
key = 2 value20
key = 3 value30
key = 4 value40
找到：key2 value:20
num = 1
lower_bound 中key3 value: 30
upper_bound 中key4 value: 40
找到了equal_range 中的lower_bound 的key 3 value: 30
找到了equal_range 中的upper_bound 的key 4 value: 40
*/



//指定排序规则
class myCompare
{
public:
	bool operator()(int v1, int v2){
		return v1 > v2;
	}
};

void printVector( vector<int> & v){
	for (vector<int>::iterator it = v.begin(); it != v.end();it++)
		cout << *it << " ";

	cout << endl;
}

void test03()
{
	//从大到小排序
	map<int, int, myCompare> m;
	m.insert(pair<int, int>(1, 10));
	m.insert(make_pair(2, 20));
	m.insert(map<int, int>::value_type(3, 30));
	m[4] = 40;

	for (map<int, int, myCompare>::iterator it = m.begin(); it != m.end();it++)
		cout << "key: " << it->first << " value: " << it->second << endl;
}
/* Output:
key: 4 value: 40
key: 3 value: 30
key: 2 value: 20
key: 1 value: 10
*/

int main(){

	//test01();

	test02();

	//test03();

	system("pause");
	return EXIT_SUCCESS;
}