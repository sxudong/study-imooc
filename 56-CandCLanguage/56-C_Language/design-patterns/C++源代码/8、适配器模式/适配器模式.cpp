#include <iostream>
using namespace std;

//Ŀ�������
class Controller
{
public:
	Controller(){}
	virtual void pathPlanning() = 0;
private:
};


//��������DxfParser
class DxfParser
{
public:
	DxfParser(){}
	void parseFile(){
		printf("�����ļ���ȡ����\n");
	}
};

//��������PathPlanner
class PathPlanner
{
public:
	PathPlanner(){}
	void calculate(){
		printf("����ӹ�·��\n");
	}
};

//��������Adapter
class Adapter :public Controller
{
public:
	Adapter(){
		dxfParser = new DxfParser();
		pathPlanner = new PathPlanner();
	}
	void pathPlanning(){
		printf("·���滮��\n");
		dxfParser->parseFile();
		pathPlanner->calculate();
	}
private:
	DxfParser   *dxfParser;
	PathPlanner *pathPlanner;
};



int main()
{
	Controller *controller = new Adapter();
	controller->pathPlanning();

	system("pause");
	return 0;
}