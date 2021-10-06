#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
12 菱形继承问题以及解决
	12.1 解决问题利用虚基类
	12.2 sheepTuo 内部结构
		12.2.1 vbptr 虚基类指针
		12.2.2 指向一张 虚基类表
		12.2.3 通过表找到偏移量
		12.2.4 找到共有的数据
	12.3 内部工作原理 （可以不掌握）
	    cl /d1 reportSingleClassLayoutSheepTuo test.cpp
*/


class Animal
{
public:
	int m_Age;
};

//虚基类 Sheep (羊类)
class Sheep : virtual public Animal //加关键字virtual后变“虚基类”
{
};

//虚基类 Tuo (驼类)
class Tuo : virtual public Animal  //加关键字virtual后变“虚基类”
{
};

//羊驼类
class SheepTuo : public Sheep, public Tuo
{

};


/*
* 菱形继承的解决方案 —— 利用“虚继承”
* 使用“虚继承”操作的是“共享的”一份数据，只有一份m_Age。
*/
void test01()
{
	SheepTuo st;
	st.Sheep::m_Age = 10;
	st.Tuo::m_Age = 20;

	cout << st.Sheep::m_Age << endl; //20
	cout << st.Tuo::m_Age << endl;   //20

	//可以直接访问，原因：已经没有二义性的可能了，只有一份 m_Age
	cout << st.m_Age << endl;        //20
}

//通过地址 找到 偏移量
//内部工作原理
void test02()
{
	SheepTuo st;
	st.m_Age = 100;

    //需要看“虚拟机类内部工作原理.png"图操作
    //参考《C语言提高》day02 06-指针的间接赋值.c
	cout << &st << endl;                               //st的地址 0
	cout << (int*) &st << endl;                        //转变为int *，改变它的步长，找到 0 Sheep
	cout << *((int*) &st) << endl;                     //加*，获取到时面的值 Sheep虚基表
	cout << (int*) *(int*) &st<< endl;                 //它的步长是多大呢？你又要告诉它是int *
	cout << (int*) *(int*) &st + 1 << endl;            //加一个1,它就偏移到了数组第2个位置
	cout << (int*) ((int*) *(int*) &st + 1) << endl;   //加1之后把它整体括起来，你还需要给它强转为int *
	cout << *(int*) ((int*) *(int*) &st + 1) << endl;  //再加 * 就取到值 8 了。

	//找到Sheep（羊）的偏移量操作
	cout << *(int *)((int *)*(int *)&st + 1) << endl;  //8

	//找到Tuo（驼）的偏移量
	//(int*) &st        //找到0
	//(int*) &st + 1    //找到4 Tuo
	//*((int*) &st + 1) //加*，获取到里面的值Tuo虚基表
	cout << *((int *)((int *)*((int *)&st + 1) + 1)) << endl; //4

	//输出Age （首先找到 m_Age）
	//(char *) &st  //步长1个
	//(char *) &st + *(int *)((int *)*(int *) &st + 1)   //加上羊的偏移量 8 ，等于0这个位置加到 8。
	//((char *) &st + *(int *)((int *)*(int *) &st + 1)) //括起来
	//(Animal*) ((char *) &st + *(int *)((int *)*(int *) &st + 1))   //强转为(Animal*)
	//((Animal*) ((char *) &st + *(int *)((int *)*(int *) &st + 1))) //再括起来
	cout << ((Animal*)((char *)&st + *(int*)((int*)*(int *)&st + 1)))->m_Age << endl; //100

}

int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
20
20
----------------
00D8F7A0
00D8F7A0
3316528
00329B30
00329B34
00329B34
8
8
4
100
请按任意键继续. . .
*/