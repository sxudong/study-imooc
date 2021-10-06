#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
	01 某个数据文件包含了家庭成员的年龄。 一个家庭各个成员的年龄位于同一行，由空格分割。例如
	   下面的数据：
	   --------------------
	   45 42 22
	   36 35 7 3 1
	   22 30
	   --------------------
	   描述了三个家庭的所有成员的年龄，它们分别有3个、5个和2个成员。
	   编写一个程序，计算这种用文件表示的每个家庭所有成员的平均年龄。程序应该用格式代码85.2f
	   打印出平均年龄，家庭每个成员的年龄。atoi();

	02 编写一个名叫sort的函数， 它用于对一个任意类型的数组进行排序。为了使函数更为通用，它的
	   其中一个参数必须是 - 个指向比较回调函数的指针，该回调函数由调用程序提供。比较函数接受
	   两个参数，也就是两个指向需要比较的值的指针。如果两个值相等，函数返回0; 如果第1个值小
	   于第2个，函数返回一个小于0的整数：如果第1个值大于第2个值，函数返回一个大于0的整数。

	   sort函数的参数是 :
		 1.一个指向需要排序的数组的第1个值的指针。
		 2.数组中元系的个数。
		 3.一个指向比较回调函数的指针。
*/



/*
* 选择排序
*
* 参数：
*     *ptr：需要排序的数组
*     ele_size：数组每个元素的字节大小
*     len：数组长度
*     *compare：排序方法
*/
//第一个参数是数组名(首地址)，第二个参数为数组长度，第三是每个元素所占字节
void selectSort( void* pAddr, int ele_size, int len, int(*compare)(void *,void *))
{
    //给temp开辟size字节个大小，以char类型存储
	char* temp = malloc(ele_size);

	for (int i = 0; i < len; ++i) {
        //记录下标
		int minOrMax = i; //定义“最小值”或者“最大值”下标

		for (int j = i + 1; j < len; ++j) {
            //把从arr开始的j*size个字节以char*赋给pJ
			//定义出 j 元素“地址”
			char* pJ = (char*) pAddr + j * ele_size; //首地址 偏移量 = j * 元素size
			char* pMinOrMax = (char*) pAddr + minOrMax * ele_size; //数组元素往后挪一位

			if (compare(pJ, pMinOrMax))
				minOrMax = j; //更新“最小值”或者“最大值”下标
		}

		if (minOrMax != i) {
			//交换 i 和 minOrMax 下标元素
			char* pMinOrMax = (char*) pAddr + minOrMax * ele_size;
			char* pI = (char*) pAddr + i * ele_size;

			//对下标为 j 和 minormax 的两个数进行交换
			memcpy(temp, pI, ele_size);
			memcpy(pI, pMinOrMax, ele_size);
			memcpy(pMinOrMax, temp, ele_size);
		}
	}

	if (temp != NULL){
		free(temp);
		temp = NULL;
	}
}

int compareInt(void *d1,void *d2)
{
	int *p1 = (int *)d1;
	int *p2 = (int *)d2;

	return *p1 > *p2;
}

void test01()
{
	int arr[] = { 7, 4, 9, 2, 1 };
	//调用排序算法函数
	selectSort(arr, sizeof(int), sizeof(arr) / sizeof(int), compareInt);
	for (int i = 0; i < 5; ++i)
		printf("%d ",arr[i]); //9 7 4 2 1

	printf("\n");
}

void doLogic(int *p)
{
	if (NULL == p){
		printf("%s 的 %d行出错！\n",__FILE__,__LINE__);
		printf("%s\n", __DATE__);
		printf("%s\n", __TIME__);

		return;
	}
}

struct Person
{
	char name[64];
	int age;
};

int myComparePerson(void* data1, void* data2)
{
	struct Person* p1 = data1;
	struct Person* p2 = data2;

	//if ( p1->age < p2->age)
	//{
	//	return  1;
	//}
	//return 0;
	//按照年龄 升序排序
	return  p1->age < p2->age;

}

void test02()
{
	struct Person pArray[] =
	{
		{ "aaa", 10 },
		{ "bbb", 40 },
		{ "ccc", 20 },
		{ "ddd", 30 },
	};

	int len = sizeof(pArray) / sizeof(struct Person);
	selectSort(pArray, sizeof(struct Person), len, myComparePerson);

	for (int i = 0; i < len; i++)
		printf("姓名：%s 年龄:%d\n", pArray[i].name, pArray[i].age);
}

int main(){
	//printf("%d", 10 > 5); //1
	test01();
	doLogic(NULL);
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
9 7 4 2 1
G:\VisualStudioWorkSpace\01 作业_排序算法\01 作业_排序算法.c 的 72行出错！
May 29 2021
10:02:25
姓名：aaa 年龄:10
姓名：ccc 年龄:20
姓名：ddd 年龄:30
姓名：bbb 年龄:40
请按任意键继续. . .
*/