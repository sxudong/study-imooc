#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
标准输入流对象 —— cin

9 标准的输入流
	9.1	cin.get()              缓冲区中读取一个字符
	9.2	cin.get(两个参数)      不读换行符
	9.3	cin.getline()          读取换行 并且扔掉
	9.4	cin.ignore 忽略（N）   N代表忽略字符数
	9.5	cin.peek()             偷窥 偷看1个字符然后放回去
	9.6	cin.putback()          放回 把字符放回缓冲区

10	输入流案例
	10.1 判断用户输入的是字符串还是数字 利用偷窥 或者 放回
	10.2 让用户输入指定范围内的数字，如果不正确 重新输入
		10.2.1	cin.fail() 看标志位  0正常 1不正常
		10.2.2	cin.clear()重置标志位
		10.2.3	cin.syne() 清空缓冲区
*/

/*
cin.get()         //一次只能读取一个字符
cin.get(一个参数) //读一个字符
cin.get(两个参数) //可以读字符串
cin.getline()
cin.ignore()
cin.peek()
cin.putback()
*/


/*
*  cin.get()  一次只能读取一个字符
*/
void test01()
{
	// 输入as   缓冲区中： a  s  换行，第一个拿 a， 第二个 拿 s， 第三次拿换行，第四次等待下次输入。
	char c = cin.get(); //等待输入
	cout << "c = " << c << endl;

	c = cin.get(); //从缓冲区拿第2个字符
	cout << "c = " << c << endl;

	c = cin.get(); //从缓冲区拿第3个字符
	cout << "c = " << c << endl;

	c = cin.get();
	cout << "c = " << c << endl;
}
/* Output:
as
c = a
c = s
c =

bcd
c = b
请按任意键继续. . .
*/


/*
* cin.get(两个参数) 可以读字符串
* 读取字符串时，不会把换行符拿走，遗留在缓冲区中
*/
void test02()
{
	char buf[1024];
	cin.get(buf, 1024); //cin.get(两个参数) //可以读字符串

	char c = cin.get();

	if (c == '\n'){
		cout << "换行还在缓冲区" << endl;
	}else{
		cout << "换行不在缓冲区" << endl;
	}

	cout << buf << endl;
}
/* 输入hello world:
hello world
换行还在缓冲区
hello world
请按任意键继续. . .
*/


/*
* cin.getline() 把换行符读取，并且扔掉
*/
void test03()
{
	char buf[1024];
	cin.getline(buf, 1024);

	char c = cin.get();
	if (c == '\n'){
		cout << "换行还在缓冲区" << endl;
	}else{
		cout << "换行不在缓冲区" << endl;
	}
}
/* 输入hello world:
hello world
                //停留在这一行，等待下次输入
*/

/*
* cin.ignore() 忽略
*/
void test04()
{
	//没有参数 代表忽略一个字符 ，带参数 N，代表忽略 N 个字符
	cin.ignore(2);
	char c =  cin.get();

	cout << "c = " << c << endl;
}
/* 输入world:
world
c = r             //忽略了wo，2个字符
请按任意键继续. . .
*/



/*
* cin.peek() peek中文意思“偷窥”
*/
void test05()
{
	//输入as  偷看一眼 a，然后再放回缓冲区，缓冲区中还是as
	char c = cin.peek();

	cout << "c = " << c << endl;

	c = cin.get();

	cout << "c = " << c << endl;
}
/* Output:
as
c = a
c = a
请按任意键继续. . .
*/


/*
* cin.putback() 放回
*/
void test06()
{
	//输入abc
	char c = cin.get();
	cin.putback(c);

	char buf[1024];

	cin.getline(buf,1024); //读取到 buf 到里
	cout << buf << endl;
}
/* 输入hello world:
hello world
hello world
请按任意键继续. . .
*/


/*
* 案例1：判断用户的是字符串 还是数字？
*/
void test07()
{
	cout << "请输入一串数字或者字符串" << endl;

	//偷窥
	char c = cin.peek();

	if (c >= '0' && c <= '9'){
		int num;
		cin >> num; //把缓冲区的内容输入到 num

		cout << "您输入是数字 ：数字为" << num << endl;
	}else{
		char buf[1024];
		cin >> buf;

		cout << "您输入是字符串 ：字符串为" << buf << endl;
	}
}
/* Output:
请输入一串数字或者字符串
a
您输入是字符串 ：字符串为a
请按任意键继续. . .
*/



/*
* 案例2：让用户输入 1 到 10 的数字，如果输入有误 重新输入
* VS下输入超过10的数字测试没问题，但输入字符串程序会死掉，在QT下测试没问题。
*/
void test08()
{
	int num;

	cout << "请输入一个1到10的数字：" << endl;

	while (true){
		cin >> num; //把缓冲区的内容输入到 num
		if (num > 0 && num <= 10){
			cout << "输入的数字为" << num << endl;
			break;
		}
		//cout << "对不起，请重新输入" << endl;

		/*
		* 缓冲区有一个“标志位”，当你要一个int类型的时候，
		* 当你确输入一个char时，这个“标志位”就被毁了，
		* 毁了就看不到正常的结果，它坏的标志就一直存在，
		* 无限的从缓冲区拿到的都是那个错误的值，导致一直执行
		* “对不起，请重新输入”这行代码。
		*/

		cin.clear(); //重置标志位

		// 2015 版本的vs 下 用ignore 处理 cin.ignore(N);

		cin.sync(); //清空缓冲区

		//看缓冲区中的“标志位”
		//标志位 0是正常的，1是不正常的。
		//cout << "标志位: " << cin.fail() << endl;
	}

}
/* 直到输入正常的0-10数字:
请输入一个1到10的数字：
1000
ad
10
输入的数字为10
请按任意键继续. . .
*/



int main(){

	//test01();

	//test02();

	//test03();

	//test04();

	//test05();

	//test06();

	//test07();

	test08();

	system("pause");
	return EXIT_SUCCESS;
}