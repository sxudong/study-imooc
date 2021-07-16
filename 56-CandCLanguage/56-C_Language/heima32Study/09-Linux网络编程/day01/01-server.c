//服务端程序
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
//要包含的头文件
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ctype.h>

// gcc -o serve 01-server.c
// nc 127.1 8888
int main()
{
	//1.创建socket
	//int socket(int domain, int type, int protocol);
	int lfd = socket(AF_INET, SOCK_STREAM, 0); //lfd文件描述符
	if(lfd<0)
	{
		perror("socket error");
		return -1;
	}

	//int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	//2.绑定
	struct sockaddr_in serv;
	bzero(&serv, sizeof(serv)); //置字节 字符串s的前n个字节为零且包括‘\0’。
	serv.sin_family = AF_INET;
	serv.sin_port = htons(8888); //端口,主机节序转网络字节短整型
	serv.sin_addr.s_addr = htonl(INADDR_ANY); //使用宏表示使用本地任意可用IP，主机节序转网络字节长整型
	
	int ret = bind(lfd, (struct sockaddr *)&serv, sizeof(serv));
	if(ret<0)
	{
		perror("bind error");	
		return -1;
	}
	
	//3.监听
	//int listen(int sockfd, int backlog);
	listen(lfd, 128); //最大值128
	
	//测试，在调用accept()之前连接已经建立了，在已链接队列中，
	//调用accept函数不是说新建一个连接, 而是从“已连接队列”中取出一个可用连接.
	//sleep(30); 
	
	//获取连接	
	//int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	struct sockaddr_in client;
	socklen_t len = sizeof(client);
	int cfd = accept(lfd, (struct sockaddr *)&client, &len);  //len是一个输入输出参数。cfd 通信文件描述符
	//const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
	
	//4.获取client端的IP和端口
	char sIP[16]; //IP
	memset(sIP, 0x00, sizeof(sIP));
	printf("client-->IP:[%s],PORT:[%d]\n", inet_ntop(AF_INET, &client.sin_addr.s_addr, sIP, sizeof(sIP)), ntohs(client.sin_port)); //打印IP和端口号
	printf("lfd==[%d], cfd==[%d]\n", lfd, cfd);

	int i = 0;
	int n = 0;
	char buf[1024];

	while(1)
	{
		//读数据
		memset(buf, 0x00, sizeof(buf));
		n = read(cfd, buf, sizeof(buf));
		if(n <= 0)
		{
			printf("read error or client close, n==[%d]\n", n); //客户端关闭
			break; //跳出循环
		}
		printf("n==[%d], buf==[%s]\n", n, buf);	

		for(i=0; i<n; i++)
		{
			buf[i] = toupper(buf[i]);
		}

		//发送数据
		write(cfd, buf, n);
	}

	//5.关闭监听“文件描述符”和“通信文件描述符”
	close(lfd);
	close(cfd);
	
	return 0;
}

