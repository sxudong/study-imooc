#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"LinkList.h"

void test()
{
	//��ʼ������ 100 200 666 300 400 500 600
	struct LinkNode* header = Init_LinkList();
	//��ӡ����
	Foreach_LinkList(header);
	//��������
	InsertByValue_LinkList(header, 200, 666);
	//��ӡ����
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	//�������
	Clear_LinkList(header);


	InsertByValue_LinkList(header, 1000, 111);
	InsertByValue_LinkList(header, 1000, 211);
	InsertByValue_LinkList(header, 1000, 311);
	InsertByValue_LinkList(header, 1000, 411);

	//��ӡ����
	printf("\n-------------------\n");
	Foreach_LinkList(header);


	RemoveByValue_LinkList(header, 311);
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	RemoveByValue_LinkList(header, 211);
	printf("\n-------------------\n");
	Foreach_LinkList(header);

	//��������
	Destroy_LinkList(header);

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
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
100 200 300 400 500
-------------------
100 666 200 300 400 500
-------------------
111 211 311 411
-------------------
111 211 411
-------------------
111 411 -1�ڵ㱻����!
111�ڵ㱻����!
411�ڵ㱻����!
�밴���������. . .
*/