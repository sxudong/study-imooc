#ifndef _WALL_HEAD //11.3.2 条件编译 防止头文件被重复包含引用。_WALL_HEAD为自定义的标识符
#define _WALL_HEAD
//#pragma  once

#include <iostream>
using namespace std;

class Wall
{
public:
	enum {
		ROW = 26, //长26行
		COL = 26  //宽26列
	};

	//初始化墙壁
	void initWall();

	//画出墙壁
	void drawWall();

	//根据索引设置 二维数组里的内容
	void setWall(int x, int y, char c);

	//根据索引获取当前位置的符号
	char getWall(int x, int y);

private:
	char gameArray[ROW][COL];
};


#endif