#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* �꺯��������һ�������ĺ�����ֻ��Ԥ���������м򵥵��ı��滻��
*
* Ϊʲôд�꺯����
* �꺯����һ�������º꺯��Ч��Ҫ�Ⱥ����ߡ�
*/
#define MYADD(x,y) ((x)+(y))
#define MAX 1024


//������������ĺ��� ����ֵ ���� ������
int add(int a, int b)
{
	return a + b;
}


int main() {

	int a = 10;
	int b = 20;

	//�Կռ任ʱ��
	//����Ƶ��ʹ�� ���Ҷ�С�ĺ���������һ��ʹ�ú꺯�����棬��Ϊ�꺯��û����ͨ�������õĿ���(����ѹջ����ת�����ص�)
	printf("a + b = %d\n", ((a)+(b))); //a + b = 30


	system("pause");
	return EXIT_SUCCESS;
}
