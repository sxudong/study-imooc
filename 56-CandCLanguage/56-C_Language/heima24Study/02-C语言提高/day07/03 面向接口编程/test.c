#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"CSckImp1.h"

/*
* 14 面向接口编程
*/


/*
* 1.定义接口(定义指针函数)
*   我们写业务需要用到这些接口，但是具体实现我们不管。用我们指针指向厂商所写的函数。
*/
//初始化
typedef void(*init_CSocketProtocol)(void **handle);
//发送接口
typedef void(*send_CSocketProtocol)(void *handle, unsigned char* sendData, int sendLen);
//接收接口
typedef void(*recv_CSocketProtocol)(void *handle, unsigned char* recvData, int* recvLen);
//关闭
typedef void(*close_CSocketProtocol)(void *handle);


/*
* 2.业务代码
*/
void FrameWork(
	init_CSocketProtocol init,
	send_CSocketProtocol send,
	recv_CSocketProtocol recv,
	close_CSocketProtocol close)
{

	//初始化连接
	void *handle = NULL;
	init(&handle);

	//发送数据
	char buf[] = "hello world!";
	int len = strlen(buf);
	send(handle, buf, len);

	//接收数据
	char recvBuf[1024] = { 0 };
	int recvLen = 0;
	recv(handle, recvBuf, &recvLen);
	printf("接收到的数据:%s\n",recvBuf);
	printf("接收到的数据长度:%d\n",recvLen);

	//关闭连接
	close(handle);
	handle = NULL;

}

void test()
{
    //测试调用第三方实现的函数
	FrameWork(init_CSckImp1,send_CSckImp1,recv_CSckImp1,close_CSckImp1);
}


int main(){

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
接收到的数据:hello world!
接收到的数据长度:12
请按任意键继续. . .
*/