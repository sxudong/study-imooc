#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std; //C++ ��ʹ��

typedef int(ARR_TYPE)[3];


/*
* 3��������Ϊ�����ĺ���������������ʹ�ã�������ѡ��1�֡�
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
			//���������﷨�ɶ��Ը���
			printf("%d ", parr[i][j]); //1 2 3 4 5 6 7 8 9
		}
	}
	printf("\n");
}


void test01()
{
	//���ֶ�ά�����﷨�ɶ��Ը�ǿ
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

	//���ڡ���ά���顱ͬ��һά���顱һ��������sizeof ��������ȡ��ַ֮�⣬��ô�������������ǡ�ָ��������Ԫ�ص�ָ�롱
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