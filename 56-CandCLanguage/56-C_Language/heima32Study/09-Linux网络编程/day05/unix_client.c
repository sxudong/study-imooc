//本地socket通信客户端
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/un.h>


int main()
{
	//创建socket
	int cfd = socket(AF_UNIX, SOCK_STREAM, 0);
	if(cfd<0)
	{
		perror("socket error");
		return -1;
	}

	//删除socket文件,避免bind失败
	unlink("./client.sock");

	//绑定bind
	struct sockaddr_un client;
	bzero(&client, sizeof(client));
	client.sun_family = AF_UNIX;
	strcpy(client.sun_path, "./client.sock"); 
	int ret = bind(cfd, (struct sockaddr *)&client, sizeof(client));
	if(ret<0)
	{
		perror("bind error");
		return -1;
	}

	struct sockaddr_un serv;
	bzero(&serv, sizeof(serv));
	serv.sun_family = AF_UNIX;
	strcpy(serv.sun_path, "./server.sock");
	ret = connect(cfd, (struct sockaddr *)&serv, sizeof(serv));
	if(ret<0)
	{
		perror("connect error");	
		return -1;
	}

	int n;
	char buf[1024];

	while(1)
	{
		memset(buf, 0x00, sizeof(buf));
		n = read(STDIN_FILENO, buf, sizeof(buf));

		//发送数据
		write(cfd, buf, n);

		//读数据
		memset(buf, 0x00, sizeof(buf));		
		n = read(cfd, buf, sizeof(buf));
		if(n<=0)
		{
			printf("read error or client close, n==[%d]\n", n);
			break;
		}
		printf("n==[%d], buf==[%s]\n", n, buf);
	}

	//关闭文件描述符
	close(cfd);

	return 0;
}
/*
aaron@aaron-virtual-machine:~$ ./unix_server 
client->[./client.sock]
n==[6], buf==[HELLO
]
read error or client close, n==[0]  //客户端连接退出

aaron@aaron-virtual-machine:~$ make unix_client
cc     unix_client.c   -o unix_client
aaron@aaron-virtual-machine:~$ ./unix_client 
hello
n==[6], buf==[HELLO
^C   //退出

aaron@aaron-virtual-machine:~$ netstat -anp | grep server
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
unix  2      [ ACC ]     流        LISTENING     82318    3256/./unix_server   ./server.sock
unix  3      [ ]         流        已连接     82319    3256/./unix_server   ./server.sock

*/