#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//���������Ͷ���
struct LinkNode
{
	int data;
	struct LinkNode* next;
};


void test()
{
	//����6���ڵ�
	struct LinkNode node1 = { 10, NULL };
	struct LinkNode node2 = { 20, NULL };
	struct LinkNode node3 = { 30, NULL };
	struct LinkNode node4 = { 40, NULL };
	struct LinkNode node5 = { 50, NULL };
	struct LinkNode node6 = { 60, NULL };
	//�����Ǵ�������
	node1.next = &node2;
	node2.next = &node3;
	node3.next = &node4;
	node4.next = &node5;
	node5.next = &node6;

	/*
	* ��α�������
	*/
	//�ȶ���һ����������ָ�����
	struct LinkNode* pCurrent = &node1; //�׽ڵ�
	while (pCurrent != NULL) {
		printf("%d ", pCurrent->data);  //��ӡ��һ���ڵ�

		//ָ�롰�ƶ�������һ��Ԫ�ص��׵�ַ
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
�밴���������. . .
*/