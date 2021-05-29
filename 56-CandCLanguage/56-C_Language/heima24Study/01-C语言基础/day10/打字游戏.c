#include <stdio.h>
#include <time.h>
#include <conio.h>
#include <stdlib.h>

void tips()
{
	//system("cls");
	printf("==============打字游戏==============\n");
	printf("==========按任意键开启游戏==========\n");
	printf("===========按ESC退出游戏============\n");
	char ch = _getch();
	if (ch == 27)
	{
		exit(0);
	}
}

void rand_ch(char *arr)
{
	srand((unsigned int)time(NULL));
	for (int i = 0; i < 50; i++)
	{
		arr[i] = rand() % 26 + 'a';
	}
}

void start_game(char *arr)
{
	//计时器
	char ch;
	int start_time;
	int end_time;
	int count = 0;
	for (int i = 0; i < 50; i++)
	{
		ch = _getch();
		if (i == 0)
		{
			//记录时间 单位是秒 1970 1 1
			start_time = time(NULL);
		}
		if (ch == arr[i])
		{
			count++;
			printf("%c", ch);
		}
		else
		{
			printf("_");
		}

	}
	end_time = time(NULL);
	printf("\n用时：%d (秒)\n", end_time - start_time);
	printf("正确率：%.f %%\n", count*1.0 / 50 * 100);
	tips();
}

int main(void)
{
	char arr[51] = {0};
	//1、提示
	//2、随机字符串
	//3、时间 正确率
	while (1)
	{
		tips();
		rand_ch(arr);
		printf("%s\n\n", arr);
		start_game(arr);
	}
	return 0;
}