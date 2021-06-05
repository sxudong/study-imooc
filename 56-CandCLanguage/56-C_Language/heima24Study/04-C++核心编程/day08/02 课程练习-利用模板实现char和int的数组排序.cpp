#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
* 需求：对char和int数组进行排序  排序规则 从大到小  利用选择排序
*/

template <class T>
void mySwap( T &a, T &b)
{
	T tmp = a;
	a = b;
	b = tmp;
}

//函数模板
template<class T> //类似Java的泛型方法的泛型参数列表
void mySort( T arr[], int len )
{
	//选择排序
	for (int i = 0; i < len;i++){
		int max = i;
		for (int j = i + 1; j < len;j++){
			if (arr[max] < arr[j])
				max = j; //交换 下标
		}

		if (max != i)
			mySwap(arr[max], arr[i]); //交换数据
	}
}


template<class T> //打印数组元素的模板
void printArray( T arr[], int len)
{
	for (int i = 0; i < len;i++)
		cout << arr[i] << " ";

	cout << endl;
}

void test01()
{
	char charArr[] = "helloworld";
	int len = sizeof(charArr) / sizeof(char);
	mySort(charArr, len);
	printArray(charArr, len);


	int intArr[] = { 1, 4, 100, 34, 55 };
	int len2 = sizeof(intArr) / sizeof (int);
	mySort(intArr, len2);
	printArray(intArr, len2);

}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
w r o o l l l h e d
100 55 34 4 1
请按任意键继续. . .
*/