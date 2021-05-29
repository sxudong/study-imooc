#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//�ɶ��� Ҫ�� Ч�ʸ���Ҫ
void printArray(int arr[], int len)
{
	for (int i = 0; i < len; ++i){
	    //�����Ǹ��ݵ�ַ������ģ����������û��ʲô�±꣬�����﷨������ɶ��ԣ��������Աд����
		printf("%d ", arr[i]);
		//printf("%d ", *(arr + i)); //������һ������һ���Ľ���������﷨�ɶ��Ը��á�
	}
	printf("\n");
}

void test01()
{
	int arr[] = { 1, 2, 3, 4 };

	//1. sizeof  2.��������ȡ��ַ&arr
	//������������£�����������ָ����Ԫ�ص�ָ��
	//������������£�����������������
	//��������������֮�⣬�������������κ�����¶���ָ����Ԫ�ص�ָ��

	printf("sizeof arr:%d\n", sizeof arr);    //16

	printf("&arr addr : %d\n", &arr);         //7338384
	printf("&arr + 1 addr : %d\n", &arr + 1); //7338400  //����16���ֽڣ��������������С��

	int* p = arr;


	//��������һ��������ָ�롱
	//arr = NULL;   //err �����޸�

	//�����±��ܷ��Ǹ���?����
	p += 3;
	printf("p[-1]:%d\n", p[-1]);     //p[-1]:3
	printf("p[-1]:%d\n", *(p - 1));  //p[-1]:3  //���������ڵײ��p[-1]ת����*(p - 1)��ַ����

    //������ָ�����͡� �� ��������Ԫ��ָ�����͡�

	printArray(arr, sizeof(arr)/sizeof(arr[0]));
}


int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
sizeof arr:16
&arr addr : 7338384
&arr + 1 addr : 7338400
p[-1]:3
p[-1]:3
1 2 3 4
�밴���������. . .
*/