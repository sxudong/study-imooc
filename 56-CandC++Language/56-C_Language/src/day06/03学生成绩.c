#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define LEN 5  //耦合度

int main03()
{

	int scores[LEN];
	int sum = 0;
	//可以通过数据类型求出大小
	//int len = sizeof(scores) / sizeof(int);
	//可以通过数组元素求出大小
	int len = sizeof(scores) / sizeof(sizeof(scores[0]));

	for (int i = 0; i < len; i++)
	{
		//scnaf("%d", &a);
		//在通过键盘为数组赋值的时候，需要些取地址符号【&】

		scanf("%d", &scores[i]);
		sum += scores[i];//sum = sum+scores[i] avg = sum /10
	}
	//打印成绩
	for (int i = 0; i < len; i++)
	{
		printf("第%d名学生，成绩：%d\n", i + 1, scores[i]);
	}

	//求出数组的元素个数
	//sizeof(int);//4
	//sizeof(数组)
	//求出班级平均成绩

	printf("班级平均成绩为:%d\n", sum / len);
	system("pause");
	return EXIT_SUCCESS;
}