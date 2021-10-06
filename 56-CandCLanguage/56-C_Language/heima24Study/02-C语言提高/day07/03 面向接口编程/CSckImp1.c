#include"CSckImp1.h"

/*
* 根据接口开发实现方法（接口定义在CSckImp1.h）
*/


//“发送/接收“消息的结构体
struct Info
{
	char data[1024];
	int len;
};


/*
* 初始化
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
* 发送接口
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
* 接收接口
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
	strncpy(recvData, info->data, info->len); //数据复制到 -> recvData
	*recvLen = info->len; //长度赋值给 -> recvLen

}


/*
* 关闭
*/
void close_CSckImp1(void *handle)
{
	if (NULL == handle)
		return;

	free(handle);  //释放堆空间
	handle = NULL; //指向空指针
}