#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

char *  removeSpace(char * arr)
{
	//char temp[100];
	char * start = arr;
	//字符串有效长度需要-1为数组元素下标
	char * end = arr + strlen(arr)-1;
	while (*end ==' ' && end > start)
	{
		end--;
	}
	*(end+1) = '\0';
	while (*start == ' ' && start < end)
	{
		start++;
	}
	return start;

}

int main01()
{

	//char arr[] = "       你好         ";

	//char * p= removeSpace(arr);
	//printf("%s\n", p);


	//printf("%d\n", sizeof(int **));
	//printf("%d\n", sizeof(int ***));
	//printf("%d\n", sizeof(void *));


	float arr[10] = {1,2,3};
	//printf("%p\n", &arr[0]);
	//printf("%p\n", &arr[0]+1);
	//&arr[0] + 1;
	char *p = arr;
	*(float *)p = 1000;
	printf("%f\n", arr[0]);
	//*((int *)p + 1) = 2000;
	//printf("%d\n", arr[2]);
	//int *p1 = arr;
	//int *p2 = &arr[1];
	//int len = p2 - p1;
	//printf("%d\n", len);

	//system("pause");
	return EXIT_SUCCESS;
}
