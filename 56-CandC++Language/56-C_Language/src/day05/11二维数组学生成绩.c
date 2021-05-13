#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{
	//定义二维数组
	int scores[5][3];
	//int stuSum[5] = 0;
	//录入学生成绩
	for (int i = 0; i < 5; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			switch (j)
			{
			case 0:
				printf("请输入语文成绩：\n");
				scanf("%d", &scores[i][j]);
				break;
			case 1:
				printf("请输入数学成绩：\n");
				scanf("%d", &scores[i][j]);
				break;
			case 2:
				printf("请输入外语成绩：\n");
				scanf("%d", &scores[i][j]);
				break;
				//stuSum[i] += scores[i][j];
			}
		}
	}
	//求出学生的平均成绩
	int stuSum = 0;
	///int stuAvg = 0;
	for (int i = 0; i < 5; i++)
	{
		stuSum = 0;
		//stuAvg = 0;
		for (int j = 0; j < 3; j++)
		{
			stuSum += scores[i][j];
			//stuAvg = stuSum / 3;
		}
		printf("第%d名学生的平均成绩为：%d\n", i + 1, stuSum / 3);
	}

	//学科平均成绩
	int cSum = 0, mSum = 0, eSum = 0;
	for (int i = 0; i < 5; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			switch (j)
			{
			case 0:
				cSum += scores[i][j];
				break;
			case 1:
				mSum +=scores[i][j];
				break;
			case 2:
				eSum += scores[i][j];
				break;
			}

		}
	}

	printf("班级的语文平均成绩为：%d\n", cSum / 5);
	printf("班级的数学平均成绩为：%d\n", mSum / 5);
	printf("班级的英语平均成绩为：%d\n", eSum / 5);

	system("pause");
	return EXIT_SUCCESS;
}