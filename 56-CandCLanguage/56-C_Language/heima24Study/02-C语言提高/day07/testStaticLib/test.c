#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"mylib.h" //���ÿ��������ġ���̬�⡱ͷ�ļ�


/*
* 12.2.2 ��̬���ʹ��
*/
int main(){

	int a = 10;
	int b = 20;

	//���á���̬�⡱��ĺ�������
	int ret = myAdd(a, b);

	printf("ret = %d\n", ret);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 30
�밴���������. . .
*/