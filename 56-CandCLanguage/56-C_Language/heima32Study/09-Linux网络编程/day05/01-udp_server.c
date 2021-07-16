//udp服务端
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ctype.h>

int main()
{
	//创建socket
	int cfd = socket(AF_INET, SOCK_DGRAM, 0);
	if(cfd<0)
	{
		perror("socket error");
		return -1;
	}

	//绑定
	struct sockaddr_in serv;
	struct sockaddr_in client;
	bzero(&serv, sizeof(serv));
	serv.sin_family = AF_INET;
	serv.sin_port = htons(8888);
	serv.sin_addr.s_addr = htonl(INADDR_ANY);
	bind(cfd, (struct sockaddr *)&serv, sizeof(serv));

	int i;
	int n;
	socklen_t len;
	char buf[1024];
	while(1)
	{
		//读取数据
		memset(buf, 0x00, sizeof(buf));
		len = sizeof(client);
		n = recvfrom(cfd, buf, sizeof(buf), 0, (struct sockaddr *)&client, &len);

		//将大写转换为小写
		for(i=0; i<n; i++)
		{
			buf[i] = toupper(buf[i]);
		}
		printf("[%d]:n==[%d], buf==[%s]\n", ntohs(client.sin_port), n, buf);
		//发送数据
		sendto(cfd, buf, n, 0, (struct sockaddr *)&client, len);
	}

	//关闭套接字
	close(cfd);

	return 0;
}
/* 测试服务端：
aaron@aaron-virtual-machine:~$ gcc -o server 01-udp_server.c wrap.c
aaron@aaron-virtual-machine:~$ ./server 
[53584]:n==[12], buf==[HELLO WORLD
]
[56061]:n==[5], buf==[NICE
]

aaron@aaron-virtual-machine:~$ nc -u 127.1 8888
hello world
HELLO WORLD

aaron@aaron-virtual-machine:~$ nc -u 127.1 8888
nice
NICE

aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
udp        0      0 127.0.0.1:53584         127.0.0.1:8888          ESTABLISHED 2885/nc             
udp        0      0 0.0.0.0:8888            0.0.0.0:*                           2874/./server 
*/