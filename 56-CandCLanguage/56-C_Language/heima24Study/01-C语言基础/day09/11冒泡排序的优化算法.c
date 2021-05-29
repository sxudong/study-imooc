#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//排序算法分：时间广度优化 和 空间广度优化
void bubble(int *arr, int len)
{
	int flag = 1;
	//时间广度优化
	for (int i = 0; i < len - 1; i++){
		for (int j = 0; j < len - i - 1; j++){
			if (arr[j] < arr[j + 1]){
				flag = 0;
				int temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}
		}
		if (flag)
			return;
		flag = 1;
	}
}

int main()
{
	int arr[] = { 1,3,5,8,9,2,7,4,6,0 };
	bubble(arr,10);

	for (int i = 0; i < 10; i++)
	{
		printf("%d\n", arr[i]);
	}
	//system("pause");
	return EXIT_SUCCESS;
}
/*
9
8
7
6
5
4
3
2
1
0
*/