#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//链表结点类型定义
struct LinkNode
{
	int data;
	struct LinkNode* next;
};


void test()
{
	//创建6个节点
	struct LinkNode node1 = { 10, NULL };
	struct LinkNode node2 = { 20, NULL };
	struct LinkNode node3 = { 30, NULL };
	struct LinkNode node4 = { 40, NULL };
	struct LinkNode node5 = { 50, NULL };
	struct LinkNode node6 = { 60, NULL };
	//把它们串连起来
	node1.next = &node2;
	node2.next = &node3;
	node3.next = &node4;
	node4.next = &node5;
	node5.next = &node6;

	/*
	* 如何遍历链表？
	*/
	//先定义一个“辅助”指针变量
	struct LinkNode* pCurrent = &node1; //首节点
	while (pCurrent != NULL) {
		printf("%d ", pCurrent->data);  //打印下一个节点

		//指针“移动”到下一个元素的首地址
		pCurrent = pCurrent->next;
	}
	printf("\n");
}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
10 20 30 40 50 60
请按任意键继续. . .
*/