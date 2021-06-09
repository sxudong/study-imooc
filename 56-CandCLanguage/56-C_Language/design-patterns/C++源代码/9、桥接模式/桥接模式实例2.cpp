#include <iostream>
using namespace std;

//ʵ����ӿ�
class Game
{
public:
	Game(){}
	virtual void play() = 0;
private:
};

//����ʵ����GameA
class GameA :public Game
{
public:
	GameA(){}
	void play(){
		printf("Jungle����ϷA\n");
	}
};

//����ʵ����GameB
class GameB :public Game
{
public:
	GameB(){}
	void play(){
		printf("Jungle����ϷB\n");
	}
};
//������Phone
class Phone
{
public:
	Phone(){
	}
	//��װ��Ϸ
	virtual void setupGame(Game *igame) = 0;
	virtual void play() = 0;
private:
	Game *game;
};

//���������PhoneA
class PhoneA :public Phone
{
public:
	PhoneA(){
	}
	//��װ��Ϸ
	void setupGame(Game *igame){
		this->game = igame;
	}
	void play(){
		this->game->play();
	}
private:
	Game *game;
};

//���������PhoneB
class PhoneB :public Phone
{
public:
	PhoneB(){
	}
	//��װ��Ϸ
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

	//Jungle����PhoneAƷ�Ƶ��ֻ���������ϷA
	phone = new PhoneA();
	game = new GameA();
	phone->setupGame(game);
	phone->play();
	printf("++++++++++++++++++++++++++++++++++\n");

	//Jungle��������ֻ�������ϷB
	game = new GameB();
	phone->setupGame(game);
	phone->play();

	system("pause");
	return 0;
}
