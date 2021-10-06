#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
3 单例模式案例 – 打印机案例
	3.1	类似主席案例
	3.2	提供打印功能
	3.3	提供统计打印次数功能
*/


class Printer
{
private:
	Printer(){ m_Count = 0; };
	Printer(const Printer& p);

public:
	static Printer* getInstance()
	{
		return singlePrinter;
	}

	void printText(string text)
	{
		cout << text << endl;
		m_Count++;
		cout << "打印机使用了次数为： " << m_Count << endl;
	}

private:
	static Printer* singlePrinter;
	int m_Count;
};
Printer* Printer::singlePrinter = new Printer;

void test01()
{
	//拿到打印机
	Printer * printer =  Printer::getInstance();

	printer->printText("离职报告");
	printer->printText("入职报告");
	printer->printText("加薪申请");
	printer->printText("升级申请");
	printer->printText("退休申请");
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
离职报告
打印机使用了次数为： 1
入职报告
打印机使用了次数为： 2
加薪申请
打印机使用了次数为： 3
升级申请
打印机使用了次数为： 4
退休申请
打印机使用了次数为： 5
请按任意键继续. . .
*/