#define _CRT_SECURE_NO_WARNINGS
#include <time.h>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main15()
{
	//加入随机数种子
	srand((unsigned int)time(NULL));
	int num = rand()%100+1;//1-100
	int value;
	while (1)//for(;;)
	{
		scanf("%d", &value);
		if (value > num)
			printf("您输入的数太大了\n");
		else if (value < num)
			printf("您输入的数太小了\n");
		else
		{
			printf("恭喜您！中奖啦~\n");
			break;
		}
	}


	system("pause");
	return EXIT_SUCCESS;
}