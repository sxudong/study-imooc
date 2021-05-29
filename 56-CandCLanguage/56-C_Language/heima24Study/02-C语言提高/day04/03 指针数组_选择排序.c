#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 选择排序
*     比”冒泡排序“要少很多次交换。
*/
void SelectSort(char** arr, int len)
{
	for (int i = 0; i < len; ++i) {
	    //1.只更新下标，不交换
		int min = i;
		for (int j = i + 1; j < len; ++j) {
		    //如果"数组元素"小于“以min为下标的元素"，min记录下“下标”以j为下标的数组元素”下标“
			if (strcmp(arr[j], arr[min]) < 0) {
				min = j;
			}
		}

		//2.交换
		if (min != i) {
		    //当前min下标的值 与 当前i下标元素进行交换
			char* temp = arr[min];
			arr[min] = arr[i];
			arr[i] = temp;
		}
	} //i++
}

void PrintArray(char** arr, int len)
{
	for (int i = 0; i < len; ++i) {
		printf("%s\n", arr[i]);
	}
}

void test()
{
	char* pArr[] = { "ddd", "ccc", "fff", "hhh", "ppp", "rrr" };
	//pArr是什么类型的？ char **类型的
	int len = sizeof(pArr) / sizeof(char*);

	PrintArray(pArr, len);
	//选择排序
	SelectSort(pArr, len);
	printf("-------------------\n");
	PrintArray(pArr, len);
}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ddd
ccc
fff
hhh
ppp
rrr
-------------------
ccc
ddd
fff
hhh
ppp
rrr
请按任意键继续. . .
*/