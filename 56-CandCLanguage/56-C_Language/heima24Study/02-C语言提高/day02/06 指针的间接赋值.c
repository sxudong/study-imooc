#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


//��Ӹ�ֵ��������
// һ����ͨ����  �� ָ�����   ��  һ��ʵ�κ�һ���β�
// ������ϵ
// * �����ڴ�

void changeValue(int* p, long* l, char* letter) // int * p = &a;
{
	*p = 100; //ֵ�����޸ģ�ָ���ַ�������޸�
	*l = 2;
	*letter = 'b';
}

//ָ�����ǵ�ַ����&�������ȡ�����ĵ�ַ��
void test01()
{
	int a = 10;
	long l = 1;
	char letter = 'a';
	//char* p = "hello world!";  //�ַ��������ǲ������޸ģ��洢�ڳ�����
	//char a[] = "hello world!"; //��ͨ���飬�洢��ջ�У������޸�

	changeValue(&a, &l, &letter);

	printf("%d\n", a);   //100
	printf("%d\n", l);   //2
	printf("%c\n", letter); //b

	printf("----------------\n");
}


// ���������Qt���봮���Բ��ԣ�VS���ڴ��ַ�����ڱ䣬û�취���ԡ�
void test02()
{
	int b = 10;
	printf("b���ڴ��ַ��%d\n", &b); //15989896

	//ֻҪ�õ��ڴ�ĵ�ַ���Ϳ����޸��ڴ�ռ��ֵ
	*(int*) 15989896 = 100;
	printf("b = %d\n", b); //100

    //int *p = &b;
	int *p = 15989896;
	*(int*) p = 200;  //*((int*) p) = 200;  //ǿתΪ int * ���ͣ������ź�� * ָ���ڴ档����ʡ��������š�
	printf("p = %d\n", *p); //200

	printf("----------------\n");
}


void changePointer(int** val)
{
	*val = 0x008;
}

void test03()
{
	int* p = NULL;
	changePointer(&p);

	printf("p = %x\n", p); //p = 8
}

int main() {

	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
100
2
b
----------------
b���ڴ��ַ��6356616
b = 100
p = 200
----------------
p = 8
�밴���������. . .
*/