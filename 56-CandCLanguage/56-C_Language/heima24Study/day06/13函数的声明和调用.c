#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//1������  ���������ĸ�ʽ
extern int add01(int a, int b);

int main13()
{

	//3������  ִ�к��� ��Ҫ���ĳЩ����  ���� ����һ��֮�� ���Զ�ε���
	int a = add01(10, 20);
	printf("%d\n", a);

	system("pause");
	return EXIT_SUCCESS;
}

//2������  �����Ķ�����ǶԺ������ܵ�ʵ��
int add01(int a, int b)
{
	return a + b;
}