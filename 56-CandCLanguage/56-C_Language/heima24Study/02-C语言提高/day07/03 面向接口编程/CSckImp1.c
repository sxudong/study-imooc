#include"CSckImp1.h"

/*
* ���ݽӿڿ���ʵ�ַ������ӿڶ�����CSckImp1.h��
*/


//������/���ա���Ϣ�Ľṹ��
struct Info
{
	char data[1024];
	int len;
};


/*
* ��ʼ��
*/
void init_CSckImp1(void **handle)
{
	if (NULL == handle)
		return;

	struct Info *info = malloc(sizeof(struct Info));
	memset(info, 0, sizeof(struct Info));

	*handle = info;
}


/*
* ���ͽӿ�
*/
void send_CSckImp1(void *handle, unsigned char* sendData, int sendLen)
{
	if (NULL == handle)
		return;

	if (NULL == sendData)
		return;

	struct Info *info = (struct Info *)handle;

	strncpy(info->data, sendData, sendLen);
	info->len = sendLen;
}


/*
* ���սӿ�
*/
void recv_CSckImp1(void *handle, unsigned char* recvData, int* recvLen)
{
	if (NULL == handle)
		return;

	if (NULL == recvData)
		return;

	if (NULL == recvLen)
		return;

	struct Info *info = (struct Info *)handle;
	strncpy(recvData, info->data, info->len); //���ݸ��Ƶ� -> recvData
	*recvLen = info->len; //���ȸ�ֵ�� -> recvLen

}


/*
* �ر�
*/
void close_CSckImp1(void *handle)
{
	if (NULL == handle)
		return;

	free(handle);  //�ͷŶѿռ�
	handle = NULL; //ָ���ָ��
}