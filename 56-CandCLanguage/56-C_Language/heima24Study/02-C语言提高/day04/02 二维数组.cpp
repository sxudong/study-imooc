#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std; //C++ 中使用

typedef int(ARR_TYPE)[3];


/*
* 3种数组做为参数的函数方法，都可以使用，可任意选择1种。
*/
//void printBiArray(int(*parr)[3], int len1, int len2)
//{
//	for (int i = 0; i < len1; ++i) {
//		for (int j = 0; j < len2; ++j) {
//			//printf("%d ", *(*(parr + i) + j) );
//			printf("%d ", parr[i][j]); //1 2 3 4 5 6 7 8 9
//		}
//	}
//	printf("\n");
//}

//void printBiArray(int parr[3][3], int len1, int len2)
//{
//	for (int i = 0; i < len1; ++i) {
//		for (int j = 0; j < len2; ++j) {
//			//printf("%d ", *(*(parr + i) + j) );
//			printf("%d ", parr[i][j]); //1 2 3 4 5 6 7 8 9
//		}
//	}
//	printf("\n");
//}

void printBiArray(int parr[][3], int len1, int len2)
{
	for (int i = 0; i < len1; ++i) {
		for (int j = 0; j < len2; ++j) {
			//printf("%d ", *(*(parr + i) + j) );
			//下面这种语法可读性更好
			printf("%d ", parr[i][j]); //1 2 3 4 5 6 7 8 9
		}
	}
	printf("\n");
}


void test01()
{
	//这种二维数组语法可读性更强
	int arr[3][3] =
	{
		{ 1, 2, 3 },
		{ 4, 5, 6 },
		{ 7, 8, 9 }
	};

	printBiArray(arr, 3, 3);

#if 0
	//int arr[3][3] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
	//int arr[][3] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };

	//对于“二维数组”同“一维数组”一样，除了sizeof 对数组名取地址之外，那么“数组名”就是“指向数组首元素的指针”
	//printf("%s\n", typeid(arr).name());
	//int(*pArray)[3] = arr;

	printf("arr[1][2]%d\n", arr[1][2]); //arr[1][2]6
	printf("*(*(arr + 2) + 1) : %d\n", *(*(arr + 1) + 2)); //*(*(arr + 2) + 1) : 6
	printf("*(*(arr + 2) + 1) : %d\n", *(*(arr + 2) + 1)); //*(*(arr + 2) + 1) : 8
#endif

}

int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}