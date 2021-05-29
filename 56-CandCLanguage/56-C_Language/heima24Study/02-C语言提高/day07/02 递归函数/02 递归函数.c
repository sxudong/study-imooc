#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"LinkList.h"

int number = 0;

/*
* 13.3 �ݹ麯������
*/


/*
* �ַ�����ת��ӡ
*/
void reversPrint(char *p)
{
	++number;

	//1. ����Ҫ�˳��ݹ��˳�����
	if (*p == '\0')
		return;

	reversPrint(p + 1); //�ݹ��������
	printf("%c",*p); //gfedcba
}


void reversePrintList(struct LinkNode *pCurrent)
{
	if (NULL == pCurrent)
		return;

	reversePrintList(pCurrent->next);
	printf("%d ",pCurrent->data);
}


void test01()
{
	char *s = "abcdefg";
	reversPrint(s);

	printf("\n");
	printf("number:%d\n", number); //number:8
}

/*
* ���������ӡ
*/
void test02()
{
	//��ʼ������
	struct LinkNode *header = Init_LinkList();

	//���������ӡ
	reversePrintList(header->next);
	printf("\n");
	Foreach_LinkList(header);

	printf("\n");
	//��������
	Destroy_LinkList(header);
}

int main(){

	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
gfedcba
number:8
������������:
100
������������:
200
������������:
300
������������:
400
������������:
500
������������:
-1
500 400 300 200 100
100 200 300 400 500
-1�ڵ㱻����!
100�ڵ㱻����!
200�ڵ㱻����!
300�ڵ㱻����!
400�ڵ㱻����!
500�ڵ㱻����!
�밴���������. . .
*/