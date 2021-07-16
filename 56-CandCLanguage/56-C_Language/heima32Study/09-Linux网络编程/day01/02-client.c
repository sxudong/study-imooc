//客户端代码
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
//要包含的头文件
#include <arpa/inet.h>
#include <netinet/in.h>

// netstat -anp | grep 8888 查看TCP状态
// gcc -o client 01-client.c
int main()
{
	//1.创建socket---返回一个cfd文件描述符，该文件描述符是用于和服务端进行通信
	int cfd = socket(AF_INET, SOCK_STREAM, 0); //通信文件描述符
	if(cfd<0)
	{
		perror("socket error");
		return -1;
	}

	//2.连接服务端
	//int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	struct sockaddr_in serv;
	serv.sin_family = AF_INET;
	serv.sin_port = htons(8888);
	
	inet_pton(AF_INET, "127.0.0.1", &serv.sin_addr.s_addr); //将字符串形式的点分十进制IP转换为大端模式的网络IP
	printf("[%x]\n", serv.sin_addr.s_addr); //[100007f]  127.0.0.1
	
	int ret = connect(cfd, (struct sockaddr *)&serv, sizeof(serv));
	if(ret<0)
	{
		perror("connect error");
		return -1;
	}	

	//3.收发数据
	int n = 0;
	char buf[256];
	while(1)
	{
		//读标准输入数据
		memset(buf, 0x00, sizeof(buf));
		n = read(STDIN_FILENO, buf, sizeof(buf));
		
		//发送数据
		//write只是把数据写入到缓冲区，真正发送数据是“内核”做的。
		//“内核”把数据从缓冲区里拿到出来，最终调用网卡的驱动程序把数据发送出去。
		write(cfd, buf, n); 

		//读服务端发来的数据
		memset(buf, 0x00, sizeof(buf));
		n = read(cfd, buf, sizeof(buf));
		if(n <= 0) //如果服务端关闭
		{
			printf("read error or server closed, n==[%d]\n", n);
			break;
		}
		printf("n==[%d], buf==[%s]\n", n, buf);
	}

	//4.关闭套接字cfd
	close(cfd);

	return 0;
}
