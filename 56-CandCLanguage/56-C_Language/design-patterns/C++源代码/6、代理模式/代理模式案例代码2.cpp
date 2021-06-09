#include "iostream"
using namespace std;

//a包含了一个类b，类b实现了某一个协议（一套接口）
class AppProtocol
{
public:
	virtual int ApplicationDidFinsh() = 0;
protected:
private:
};

//协议实现类
class AppDelegate : public AppProtocol
{
public:
	AppDelegate()
	{
		;
	}
	virtual int ApplicationDidFinsh()  //cocos2dx函数的入口点
	{
		cout << "ApplicationDidFinsh do...\n";
		return 0;
	}
};

//Application是代理类，在代理类中包含一个真正的实体类
class Application
{
public:
	Application()
	{
		ap = NULL;
	}
public:
	void run()
	{
		ap = new AppDelegate();
		ap->ApplicationDidFinsh();
		delete ap;
	}
protected:
private:
	AppDelegate *ap;
};

//好处：main函数不需要修改了。只需要修改协议实现类
void main()
{
	Application *app = new Application();
	app->run();

	if (app == NULL)
	{
		free(app);
	}

	cout << "hello..." << endl;
	system("pause");
}