#include "wall.h"


void Wall::initWall(){

	for (int i = 0; i < ROW;i++){     //i ��row
		for (int j = 0; j < COL;j++){ //j ��column
			//��ǽ��
			//����ǽ��λ�ã�ǽ���ϱ�i=0�зš�*����ǽ�����j=0�У��š�*�����ұ�ǽ���һ�� col-1�зš�*�����ױ�i=row-1�зš�*��
			if (i == 0  || j == 0 || i == ROW - 1 || j == COL - 1)
				gameArray[i][j] = '*'; //��Щ�����·š�*��
			else
				gameArray[i][j] = ' ';
		}
	}


}

/*
* ��ǽ��
*/
void Wall::drawWall(){

	for (int i = 0; i < ROW; i++){
		for (int j = 0; j < COL; j++)
			cout << gameArray[i][j] << " ";

		//��for��ӡǽ�ں󣬽����Ŵ�ӡһЩ��ʾ��Ϣ
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
