#include <iostream>
using namespace std;

//实现类接口
class Game
{
public:
	Game(){}
	virtual void play() = 0;
private:
};

//具体实现类GameA
class GameA :public Game
{
public:
	GameA(){}
	void play(){
		printf("Jungle玩游戏A\n");
	}
};

//具体实现类GameB
class GameB :public Game
{
public:
	GameB(){}
	void play(){
		printf("Jungle玩游戏B\n");
	}
};
//抽象类Phone
class Phone
{
public:
	Phone(){
	}
	//安装游戏
	virtual void setupGame(Game *igame) = 0;
	virtual void play() = 0;
private:
	Game *game;
};

//扩充抽象类PhoneA
class PhoneA :public Phone
{
public:
	PhoneA(){
	}
	//安装游戏
	void setupGame(Game *igame){
		this->game = igame;
	}
	void play(){
		this->game->play();
	}
private:
	Game *game;
};

//扩充抽象类PhoneB
class PhoneB :public Phone
{
public:
	PhoneB(){
	}
	//安装游戏
	void setupGame(Game *igame){
		this->game = igame;
	}
	void play(){
		this->game->play();
	}
private:
	Game *game;
};


int main()
{
	Game *game;
	Phone *phone;

	//Jungle买了PhoneA品牌的手机，想玩游戏A
	phone = new PhoneA();
	game = new GameA();
	phone->setupGame(game);
	phone->play();
	printf("++++++++++++++++++++++++++++++++++\n");

	//Jungle想在这个手机上玩游戏B
	game = new GameB();
	phone->setupGame(game);
	phone->play();

	system("pause");
	return 0;
}
