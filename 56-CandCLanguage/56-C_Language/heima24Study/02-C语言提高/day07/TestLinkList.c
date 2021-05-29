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
	printf("\n-------逆序链表------------\n");
	Foreach_LinkList(header);

	//清空链表
	Clear_LinkList(header);
	//打印链表

	InsertByValue_LinkList(header, 1000, 111);
	InsertByValue_LinkList(header, 1000, 211);
	InsertByValue_LinkList(header, 1000, 311);
	InsertByValue_LinkList(header, 1000, 411);

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
10
输入插入的数据:
20
输入插入的数据:
30
输入插入的数据:
40
输入插入的数据:
50
输入插入的数据:
-1
10 20 30 40 50
-------------------
10 20 30 40 50 666
-------逆序链表------------
666 50 40 30 20 10
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