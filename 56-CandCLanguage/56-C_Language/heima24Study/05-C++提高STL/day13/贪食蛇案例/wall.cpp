#include "wall.h"


void Wall::initWall(){

	for (int i = 0; i < ROW;i++){     //i 是row
		for (int j = 0; j < COL;j++){ //j 是column
			//放墙壁
			//分析墙的位置：墙壁上边i=0行放“*”，墙壁左边j=0列，放“*”，右边墙最后一列 col-1列放“*”，底边i=row-1行放“*”
			if (i == 0  || j == 0 || i == ROW - 1 || j == COL - 1)
				gameArray[i][j] = '*'; //这些条件下放“*”
			else
				gameArray[i][j] = ' ';
		}
	}


}

/*
* 画墙壁
*/
void Wall::drawWall(){

	for (int i = 0; i < ROW; i++){
		for (int j = 0; j < COL; j++)
			cout << gameArray[i][j] << " ";

		//在for打印墙壁后，紧接着打印一些提示信息
		if (i == 5)
			cout << "create by zt";

		if (i == 6)
			cout << "a : left";

		if (i == 7)
			cout << "d : right";

		if (i == 8)
			cout << "w : up";

		if (i == 9)
			cout << "s : down";

		cout << endl;
	}
}

void Wall::setWall(int x, int y, char c){
	gameArray[x][y] = c;
}

char Wall::getWall(int x, int y){
	return gameArray[x][y];
}
