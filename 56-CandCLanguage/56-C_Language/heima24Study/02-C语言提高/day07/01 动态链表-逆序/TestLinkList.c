#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"LinkList.h"

void test()
{
	//初始化链表 100 200 666 300 400 500 600
	struct LinkNode* header = Init_LinkList();
	//打印链表
	Foreach_LinkList(header);
	//插入数据
	InsertByValue_LinkList(header, 200, 666);
	//打印链表
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	//逆序链表
	Reverse_LinkList(header);
	//打印逆序链表
	printf("\n---------逆序链表----------\n");
	Foreach_LinkList(header);

	//清空链表
	Clear_LinkList(header);

	InsertByValue_LinkList(header, 1000, 111);
	InsertByValue_LinkList(header, 1000, 211);
	InsertByValue_LinkList(header, 1000, 311);
	InsertByValue_LinkList(header, 1000, 411);

	//打印链表
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	RemoveByValue_LinkList(header, 311);
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	RemoveByValue_LinkList(header, 211);
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	//销毁链表
	Destroy_LinkList(header);

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
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
100 200 300 400 500
-------------------
100 666 200 300 400 500
---------逆序链表----------
500 400 300 200 666 100
-------------------
111 211 311 411
-------------------
111 211 411
-------------------
111 411 -1节点被销毁!
111节点被销毁!
411节点被销毁!
请按任意键继续. . .
*/