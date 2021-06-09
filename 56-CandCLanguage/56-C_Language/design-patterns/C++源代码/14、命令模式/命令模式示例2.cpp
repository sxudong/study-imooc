#include <iostream>
using namespace std;
#include <cstdio>
// 接收者：电灯类
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

// 接收者：风扇类
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
// 抽象命令类 Command
class Command
{
public:
	Command(){}
	// 声明抽象接口：发送命令
	virtual void execute() = 0;
private:
	Command *command;
};
// 具体命令类 LampCommand
class LampCommand :public Command
{
public:
	LampCommand(){
		printf("开关控制电灯\n");
		lamp = new Lamp();
	}
	// 实现execute()
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

// 具体命令类 FanCommand
class FanCommand :public Command
{
public:
	FanCommand(){
		printf("开关控制风扇\n");
		fan = new Fan();
	}
	// 实现execute()
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
// 调用者 Button
class Button
{
public:
	Button(){}
	// 注入具体命令类对象
	void setCommand(Command *cmd){
		this->command = cmd;
	}
	// 发送命令：触摸按钮
	void touch(){
		printf("触摸开关:");
		command->execute();
	}
private:
	Command *command;
};


int main()
{
	// 实例化调用者：按钮
	Button *button = new Button();
	Command *lampCmd, *fanCmd;

	// 按钮控制电灯
	lampCmd = new LampCommand();
	button->setCommand(lampCmd);
	button->touch();
	button->touch();
	button->touch();

	printf("\n\n");

	// 按钮控制风扇
	fanCmd = new FanCommand();
	button->setCommand(fanCmd);
	button->touch();
	button->touch();
	button->touch();

	printf("\n\n");
	system("pause");
	return 0;
}
