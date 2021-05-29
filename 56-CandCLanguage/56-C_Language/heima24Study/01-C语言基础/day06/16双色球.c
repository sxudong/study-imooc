#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <time.h>

int main()
{
	srand((unsigned int)time(NULL));
	//双色球  两种原色 红球 + 蓝球 （6+1）  红球 1-33   蓝球 1-16  打印双色球中奖信息
	//红色球不能重复  蓝球和红球可以重复
	int ball[6];

	//红色
	for (int i = 0; i < 6; i++)
	{
		// qiu = rand()%33 + 1;
		ball[i] = rand() % 33 + 1;
		//去重
		for (int j = 0; j < i; j++)
		{
			if (ball[i] == ball[j])
			{
				i--;
				continue;
			}
		}
	}

	//排序
	for (int i = 0; i < 6; i++)
	{
		printf("%d   ", ball[i]);
	}
	printf("+   %d\n", rand() % 16 + 1);
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
22   3   11   23   13   25   +   12
请按任意键继续. . .
*/