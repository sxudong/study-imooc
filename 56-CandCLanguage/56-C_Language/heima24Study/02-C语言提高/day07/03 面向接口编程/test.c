#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"CSckImp1.h"

/*
* 14 ����ӿڱ��
*/


/*
* 1.����ӿ�(����ָ�뺯��)
*   ����дҵ����Ҫ�õ���Щ�ӿڣ����Ǿ���ʵ�����ǲ��ܡ�������ָ��ָ������д�ĺ�����
*/
//��ʼ��
typedef void(*init_CSocketProtocol)(void **handle);
//���ͽӿ�
typedef void(*send_CSocketProtocol)(void *handle, unsigned char* sendData, int sendLen);
//���սӿ�
typedef void(*recv_CSocketProtocol)(void *handle, unsigned char* recvData, int* recvLen);
//�ر�
typedef void(*close_CSocketProtocol)(void *handle);


/*
* 2.ҵ�����
*/
void FrameWork(
	init_CSocketProtocol init,
	send_CSocketProtocol send,
	recv_CSocketProtocol recv,
	close_CSocketProtocol close)
{

	//��ʼ������
	void *handle = NULL;
	init(&handle);

	//��������
	char buf[] = "hello world!";
	int len = strlen(buf);
	send(handle, buf, len);

	//��������
	char recvBuf[1024] = { 0 };
	int recvLen = 0;
	recv(handle, recvBuf, &recvLen);
	printf("���յ�������:%s\n",recvBuf);
	printf("���յ������ݳ���:%d\n",recvLen);

	//�ر�����
	close(handle);
	handle = NULL;

}

void test()
{
    //���Ե��õ�����ʵ�ֵĺ���
	FrameWork(init_CSckImp1,send_CSckImp1,recv_CSckImp1,close_CSckImp1);
}


int main(){

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
���յ�������:hello world!
���յ������ݳ���:12
�밴���������. . .
*/