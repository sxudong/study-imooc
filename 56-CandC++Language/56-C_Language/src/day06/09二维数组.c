#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main09()
{

	//二维数组定义
	int arr[3][3];
	//arr[0][0]; arr[0][1]; arr[0][2];
	//arr[1][0]; arr[1][1]; arr[1][2];
	//arr[2][0]; arr[2][1]; arr[2][2];
	printf("二维数组长度：%d\n", sizeof(arr));//36
	printf("二维数组中一行长度：%d\n", sizeof(arr[0]));//12
	printf("行数：%d\n", sizeof(arr) / sizeof(arr[0]));
	printf("列数：%d\n", sizeof(arr[0]) / sizeof(arr[0][0]));

	for (int i = 0; i < sizeof(arr) / sizeof(arr[0]); i++)
	{
		for (int j = 0; j < sizeof(arr[0]) / sizeof(arr[0][0]); j++)
		{
			scanf("%d", &arr[i][j]);
		}
	}


	//打印数据
	for (int i = 0; i < sizeof(arr) / sizeof(arr[0]); i++)
	{
		for (int j = 0; j < sizeof(arr[0]) / sizeof(arr[0][0]); j++)
		{
			printf("第%d行%d列：%d\n",i,j,arr[i][j]);
		}
	}


	//二维数组的内存模型
	printf("二维数组的内存首地址：%p\n", arr);
	printf("二维数组的内存首行地址：%p\n", arr[0]);
	printf("二维数组的内存第二行首行地址：%p\n", arr[1]);

	printf("二维数组的内存首个元素地址：%p\n", &arr[0][0]);
	printf("二维数组的内存首行第二个元素地址：%p\n", &arr[0][1]);
	printf("二维数组的内存首行第三个元素地址：%p\n", &arr[0][2]);

	printf("二维数组的内存第二行第一个元素地址：%p\n", &arr[1][0]);
	printf("二维数组的内存第二行第二个元素地址：%p\n", &arr[1][1]);

	printf("二维数组的内存第三行第二个元素地址：%p\n", &arr[2][1]);


	//system("pause");
	return EXIT_SUCCESS;
}