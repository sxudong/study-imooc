#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 1. ջ�����ڴ��Զ������Զ��ͷţ�����Ҫ�����ֶ�����
*/
int* myFunc()
{
	//��Ҫ���ؾֲ������ĵ�ַ
	int a = 10; //ջ��
	return &a;  //�������������ܷ��ؾֲ������ĵ�ַ
}

void test01()
{
	//���ǲ�������ֵ�Ƕ��٣���Ϊ�ֲ�����a���ڴ��Ѿ�������
	int* p = myFunc();
	printf("*p = %d\n", *p);
}



char* getString()
{
	char str[] = "hello world!"; //����Ҳ��ջ�ϣ�

    //�������ﱣ����ǡ������׵�ַ��
	return str; //�����������ֲ���������ʱ�ᱻ���գ��ڴ汻�ͷŵ��ˣ�����ʲôֵ���п��ܡ�
}


void test02()
{
	char* s = NULL;

	s = getString();

	printf("s = %s\n", s); //s = ����������������l��
}


int main() {

	//�����������ᵼ�±�������������ִ��
	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}