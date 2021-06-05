#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 继承的引出
	5.1	网页 很多公共部分
	5.2	导致实现时候有很多重复的代码
	5.3	引出继承，基类 （父类） 公共网页
	5.4	具体子类 实现不同的内容
	5.5	语法  class 子类 :继承方式 父类
*/


/*
派生类定义格式：
	Class 派生类名 : 继承方式 基类名{
		//派生类新增的数据成员和成员函数
	}

三种继承方式：
?	public ：    公有继承
?	private ：   私有继承
?	protected ： 保护继承
*/



//class News
//{
//public:
//	void header()
//	{
//		cout << "公共头部" << endl;
//	}
//	void footer()
//	{
//		cout << "公共底部" << endl;
//	}
//	void left()
//	{
//		cout << "左侧列表" << endl;
//	}
//
//	void content()
//	{
//		cout << "新闻播放" << endl;
//	}
//
//};
//
//class YULE
//{
//public:
//	void header()
//	{
//		cout << "公共头部" << endl;
//	}
//	void footer()
//	{
//		cout << "公共底部" << endl;
//	}
//	void left()
//	{
//		cout << "左侧列表" << endl;
//	}
//
//	void content()
//	{
//		cout << "白百合。。。" << endl;
//	}
//
//};
//
//void test01()
//{
//	News news;
//	news.header();
//	news.footer();
//	news.left();
//	news.content();
//
//	//娱乐页
//	YULE yl;
//	yl.header();
//	yl.footer();
//	yl.left();
//	yl.content();
//
//}


/*
* 继承写法
* 抽象一个“基类的网页”，“重复的代码”都写到这个网页上。
*/
class BasePage
{
public:
	void header()
	{
		cout << "公共头部" << endl;
	}
	void footer()
	{
		cout << "公共底部" << endl;
	}
	void left()
	{
		cout << "左侧列表" << endl;
	}
};


/*
* 继承  News类 继承于 BasePage类
* 冒号指出News类的基类是BasePage类。
*/
//新闻
class News : public BasePage
{
public:
	void content()
	{
		cout << "新闻播放" << endl;
	}
};


//娱乐
class YULE : public BasePage
{
public:
	void content()
	{
		cout << "白百合。。。" << endl;
	}
};


//游戏
class Game : public BasePage
{
public:
	void content()
	{
		cout << "KPL直播" << endl;
	}
};


void test02()
{
	cout << " 新闻网页内容： " << endl;
	News news;
	news.header();   //公共头部
	news.footer();   //公共底部
	news.left();     //公共左侧列表
	news.content();  //News子类的内容

	cout << " 娱乐网页内容： " << endl;
	YULE yl;
	yl.header();     //公共头部
	yl.footer();     //公共底部
	yl.left();       //公共左侧列表
	yl.content();    //YULE子类的内容

	cout << " 游戏网页内容： " << endl;
	Game game;
	game.header();
	game.footer();
	game.left();
	game.content();
}


/*
* 继承 减少代码重复内容
* 专业术语：BasePage  基类 (父类)   News 派生类 （子类）
*/
int main(){

	//test01();

	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
 新闻网页内容：
公共头部
公共底部
左侧列表
新闻播放
 娱乐网页内容：
公共头部
公共底部
左侧列表
白百合。。。
 游戏网页内容：
公共头部
公共底部
左侧列表
KPL直播
请按任意键继续. . .
*/