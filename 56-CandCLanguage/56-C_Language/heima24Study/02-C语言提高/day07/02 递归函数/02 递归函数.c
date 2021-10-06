#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"LinkList.h"

int number = 0;

/*
* 13.3 递归函数调用
*/


/*
* 字符串反转打印
*/
void reversPrint(char *p)
{
	++number;

	//1. 首先要退出递归退出条件
	if (*p == '\0')
		return;

	reversPrint(p + 1); //递归调用自身
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
* 链表逆序打印
*/
void test02()
{
	//初始化链表
	struct LinkNode *header = Init_LinkList();

	//链表逆序打印
	reversePrintList(header->next);
	printf("\n");
	Foreach_LinkList(header);

	printf("\n");
	//销毁链表
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
输入插入的数据:
100
输入插入的数据:
200
输入插入的数据:
300
输入插入的数据:
400
输入插入的数据:
500
输入插入的数据:
-1
500 400 300 200 100
100 200 300 400 500
-1节点被销毁!
100节点被销毁!
200节点被销毁!
300节点被销毁!
400节点被销毁!
500节点被销毁!
请按任意键继续. . .
*/