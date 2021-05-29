#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


void allocateSpace(int** temp)
{
	int* arr = malloc(sizeof(int) * 10);
	for (int i = 0; i < 10; ++i)
		arr[i] = i + 1;

	//指针间接赋值（指针里保存另一个地址）
	*temp = arr; //拿到到arr的首地址
}

void printArray(int* arr, int len)
{
	for (int i = 0; i < len; ++i)
		printf("%d ", arr[i]);
	printf("\n");
}

/*
* 释放堆空间
* freeSpace(void* arr)函数内的 arr 地址 == freeSpace(int** arr)函数内的 *arr 地址
*/
#if 0
    void freeSpace(void* arr) //不需要关心类型，直接释放就行
    {
        if (arr == NULL)
            return;

        //printf("arr的值 = %d\n", arr); //7088120

        free(arr);
        arr = NULL; //置空
    }
#else
    void freeSpace(int** arr) //**arr接收的是&pArray的地址，*arr是它的值
    {
        if (arr == NULL)
            return;

        //printf("*arr的值 = %d\n", *arr); //7088120

        if (*arr != NULL){
            free(*arr);  //*arr取的是&pArray的值，指针的值保存的是arr数组的地址
            *arr = NULL; //这个就是pArray的值指向空了
            arr = NULL;  //接收的临时变量等于空，这个地方可以不写，临时变量在函数体结束后会销毁
        }
    }
#endif


void test01()
{
	int* pArray = NULL;
	allocateSpace(&pArray);
	printArray(pArray, 10);
#if 0
	freeSpace(pArray);  //传的是pArray里保存的地址
	pArray = NULL;      //指向空，如果不这样，就会成为野指针
#endif
	freeSpace(&pArray); //传的是pArray指针自身的地址
	if (pArray == NULL){
		printf("pArray被置空!\n");
	}
}

int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1 2 3 4 5 6 7 8 9 10
pArray被置空!
请按任意键继续. . .
*/