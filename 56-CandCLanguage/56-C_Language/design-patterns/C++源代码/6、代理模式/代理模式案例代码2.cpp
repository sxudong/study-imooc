#include "iostream"
using namespace std;

//a������һ����b����bʵ����ĳһ��Э�飨һ�׽ӿڣ�
class AppProtocol
{
public:
	virtual int ApplicationDidFinsh() = 0;
protected:
private:
};

//Э��ʵ����
class AppDelegate : public AppProtocol
{
public:
	AppDelegate()
	{
		;
	}
	virtual int ApplicationDidFinsh()  //cocos2dx��������ڵ�
	{
		cout << "ApplicationDidFinsh do...\n";
		return 0;
	}
};

//Application�Ǵ����࣬�ڴ������а���һ��������ʵ����
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

//�ô���main��������Ҫ�޸��ˡ�ֻ��Ҫ�޸�Э��ʵ����
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