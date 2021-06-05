#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
* ���󣺶�char��int�����������  ������� �Ӵ�С  ����ѡ������
*/

template <class T>
void mySwap( T &a, T &b)
{
	T tmp = a;
	a = b;
	b = tmp;
}

//����ģ��
template<class T> //����Java�ķ��ͷ����ķ��Ͳ����б�
void mySort( T arr[], int len )
{
	//ѡ������
	for (int i = 0; i < len;i++){
		int max = i;
		for (int j = i + 1; j < len;j++){
			if (arr[max] < arr[j])
				max = j; //���� �±�
		}

		if (max != i)
			mySwap(arr[max], arr[i]); //��������
	}
}


template<class T> //��ӡ����Ԫ�ص�ģ��
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
�밴���������. . .
*/