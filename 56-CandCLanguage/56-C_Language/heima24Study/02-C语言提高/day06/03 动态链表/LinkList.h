#define _CRT_SECURE_NO_WARNINGS

#pragma once

#include<stdlib.h>
#include<stdbool.h>
#include<stdio.h>

//Ŀ��Ϊ����C++���ܹ�����Cд�ĺ���
#ifdef __cplusplus
extern "C" {
#endif


	//����ڵ���������
	struct LinkNode
	{
		int data;
		struct LinkNode* next;
	};

	/*
	* ��������Ҫ�ĺ����������� LinkList.c ��ʵ����Щ������
	*/

	//��ʼ������
	struct LinkNode* Init_LinkList();
	//��ֵΪoldval��λ�ò����µ�����newval
	void InsertByValue_LinkList(struct LinkNode* header, int oldval, int newval);
	//ɾ��ֵΪval�Ľ��
	void RemoveByValue_LinkList(struct LinkNode* header, int delValue);
	//����
	void Foreach_LinkList(struct LinkNode* header);
	//����
	void Destroy_LinkList(struct LinkNode* header);
	//���
	void Clear_LinkList(struct LinkNode* header);


#ifdef __cplusplus
}
#endif