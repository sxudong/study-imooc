#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"mydll.h" //���붯̬��ͷ�ļ�

#pragma comment(lib,"./testDll.lib") //���붯̬��


/*
* 12.3.2 ��̬���ʹ��
*/
//���ԡ��ⲿ������
int main(){

	int a = 10;
	int b = 20;
	int ret = myAdd(a, b);
	printf("ret = %d\n", ret);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 20
�밴���������. . .
*/



/*
* 13.3 �ݹ麯������
*/
void fun(int a) {

    //�������˳���������������ջ���
	if (a == 1) {
		printf("a = %d\n", a);
		return; //�жϺ�������Ҫ
	}

	fun(a - 1); //�ݹ����
	printf("a = %d\n", a);
}


int main2(void) {

	fun(2);
	printf("main\n");

	return 0;
}