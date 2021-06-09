#include <iostream>
using namespace std;
#include <cstdio>
// �����ߣ������
class Lamp
{
public:
	Lamp(){
		this->lampState = false;
	}
	void on(){
		lampState = true;
		printf("Lamp is on\n");
	}
	void off(){
		lampState = false;
		printf("Lamp is off\n");
	}
	bool getLampState(){
		return lampState;
	}
private:
	bool lampState;
};

// �����ߣ�������
class Fan
{
public:
	Fan(){
		this->fanState = false;
	}
	void on(){
		fanState = true;
		printf("Fan is on\n");
	}
	void off(){
		fanState = false;
		printf("Fan is off\n");
	}
	bool getFanState(){
		return fanState;
	}
private:
	bool fanState;
};
// ���������� Command
class Command
{
public:
	Command(){}
	// ��������ӿڣ���������
	virtual void execute() = 0;
private:
	Command *command;
};
// ���������� LampCommand
class LampCommand :public Command
{
public:
	LampCommand(){
		printf("���ؿ��Ƶ��\n");
		lamp = new Lamp();
	}
	// ʵ��execute()
	void execute(){
		if (lamp->getLampState()){
			lamp->off();
		}
		else{
			lamp->on();
		}
	}
private:
	Lamp *lamp;
};

// ���������� FanCommand
class FanCommand :public Command
{
public:
	FanCommand(){
		printf("���ؿ��Ʒ���\n");
		fan = new Fan();
	}
	// ʵ��execute()
	void execute(){
		if (fan->getFanState()){
			fan->off();
		}
		else{
			fan->on();
		}
	}
private:
	Fan *fan;
};
// ������ Button
class Button
{
public:
	Button(){}
	// ע��������������
	void setCommand(Command *cmd){
		this->command = cmd;
	}
	// �������������ť
	void touch(){
		printf("��������:");
		command->execute();
	}
private:
	Command *command;
};


int main()
{
	// ʵ���������ߣ���ť
	Button *button = new Button();
	Command *lampCmd, *fanCmd;

	// ��ť���Ƶ��
	lampCmd = new LampCommand();
	button->setCommand(lampCmd);
	button->touch();
	button->touch();
	button->touch();

	printf("\n\n");

	// ��ť���Ʒ���
	fanCmd = new FanCommand();
	button->setCommand(fanCmd);
	button->touch();
	button->touch();
	button->touch();

	printf("\n\n");
	system("pause");
	return 0;
}
