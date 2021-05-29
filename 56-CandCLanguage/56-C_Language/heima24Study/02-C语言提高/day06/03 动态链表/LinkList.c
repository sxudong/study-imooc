#include"LinkList.h"


/*
* ��ʼ������
*/
struct LinkNode* Init_LinkList()
{

	//����ͷ���
	struct LinkNode* header = malloc(sizeof(struct LinkNode));
	header->data = -1;
	header->next = NULL;

	//β��ָ��
	struct LinkNode* pRear = header;

	int val = -1;
	while (true)
	{
		printf("������������:\n");
		scanf("%d", &val);
		if (val == -1) //�������-1���˳�
			break;

		//�ȴ������½ڵ㡱
		struct LinkNode* newnode = malloc(sizeof(struct LinkNode));
		newnode->data = val;
		newnode->next = NULL;

		//���½ڵ㡱���뵽������
		pRear->next = newnode;

		//���¡�β��ָ�롱ָ��
		pRear = newnode; //���½ڵ㡱��Ϊβ������β��ָ�롱ָ���½ڵ㡱
	}

	return header;
}

/*
* ��ֵΪoldval��λ�á����롱�µ�����newval
*
* ������
*     header��Ҫ����������
*     oldval�����������ĸ�ֵǰ�����
*     newval��Ҫ�����ֵ
*/
void InsertByValue_LinkList(struct LinkNode* header, int oldval, int newval)
{
	if (NULL == header)
		return;


	//��������ָ�����
	struct LinkNode* pPrev = header;
	struct LinkNode* pCurrent = pPrev->next;

	while (pCurrent != NULL){

		if (pCurrent->data == oldval) //�ҵ�oldvalֵ��λ��
			break;

		//�����û�ҵ�����Ӧ��λ��,����ָ������ƶ�
		pPrev = pCurrent;
		pCurrent = pCurrent->next;
	}

#if 0
	//���pCurrentΪNULL  ˵�������в�����ֵΪoldval�Ľ��
	if (pCurrent == NULL)
		return;
#endif


	//�ȴ������½�㡱
	struct LinkNode* newnode = malloc(sizeof(struct LinkNode));
	newnode->data = newval;
	newnode->next = NULL;

	//���½ڵ㡱���뵽������
	newnode->next = pCurrent;
	pPrev->next = newnode;

}


/*
* ɾ��ֵΪval�Ľ��
*/
void RemoveByValue_LinkList(struct LinkNode* header, int delValue)
{

	if (NULL == header)
		return;

	//������������ָ�����
	struct LinkNode* pPrev = header;
	struct LinkNode* pCurrent = pPrev->next;

	while (pCurrent != NULL){

		if (pCurrent->data == delValue)
			break;

		//û���ҵ����ݣ�����ָ������ƶ�
		pPrev = pCurrent;
		pCurrent = pCurrent->next;
	}

	if (NULL == pCurrent) //û���ҵ��û�Ҫɾ��������
		return;

	//���½�����ɾ���ڵ�ġ�ǰ�����͡���̡�����ϵ
	pPrev->next = pCurrent->next;
	//�ͷ�ɾ���ڵ��ڴ�
	free(pCurrent);
	pCurrent = NULL;

}


/*
* ����
*/
void Foreach_LinkList(struct LinkNode* header)
{
	if (NULL == header)
		return;

	//����ָ�����
	struct LinkNode* pCurrent = header->next;

	while (pCurrent != NULL){
		printf("%d ", pCurrent->data);
		pCurrent = pCurrent->next;
	}

}


/*
* ����
*/
void Destroy_LinkList(struct LinkNode* header)
{
	if (NULL == header)
		return;

	//����ָ�����
	struct LinkNode* pCurrent = header;

	while (pCurrent != NULL){
		//�ȱ����µ�ǰ������һ���ڵ��ַ
		struct LinkNode* pNext = pCurrent->next;

		//�ͷŵ�ǰ����ڴ�
		printf("%d�ڵ㱻����!\n", pCurrent->data);
		free(pCurrent);

		//ָ������ƶ�
		pCurrent = pNext;

	}
}


/*
* ���
*/
void Clear_LinkList(struct LinkNode* header)
{
	if (NULL == header)
		return;

	//����ָ�����
	struct LinkNode* pCurrent = header->next;

	while (pCurrent != NULL){

		//�ȱ����µ�ǰ������һ���ڵ��ַ
		struct LinkNode* pNext = pCurrent->next;

		//�ͷŵ�ǰ����ڴ�
		free(pCurrent);

		//pCurrentָ����һ���ڵ�
		pCurrent = pNext;

	}

	header->next = NULL;
}
