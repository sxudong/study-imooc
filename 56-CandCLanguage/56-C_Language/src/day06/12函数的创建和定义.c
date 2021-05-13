#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//函数的定义中的参数列表的中的数据成为函数的形式参数   形参  形参接收实参 在函数内部进行运算
void Bubble(int arr[], int len)
{
	for (int i = 0; i < len-1; i++)
	{
		for (int j = 0; j < len - 1 - i; j++)
		{
			if (arr[j] < arr[j + 1])
			{
				int temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}
		}
	}
	return;
}

int main12()
{

	int arr[] = { 3,5,2,7,9,1,8,10,4,6 };
	//数组作为函数参数，可以退化为函数名  可以退化为指针
	//形参 实参  实际参数
	//函数调用
	Bubble(arr, 10);
	//strcmp()

	for (int i = 0; i < 10; i++)
	{
		printf("%d\n", arr[i]);
	}

	//int arr1[] = { 31,52,21,17,94,10,86 };
	//for (int i = 0; i < 7; i++)
	//{
	//	for (int j = 0; j < 7 - i; j++)
	//	{
	//		if (arr1[j] < arr1[j + 1])
	//		{
	//			int temp = arr1[j];
	//			arr1[j] = arr1[j + 1];
	//			arr1[j + 1] = temp;
	//		}
	//	}
	//}



	system("pause");
	return EXIT_SUCCESS;
}