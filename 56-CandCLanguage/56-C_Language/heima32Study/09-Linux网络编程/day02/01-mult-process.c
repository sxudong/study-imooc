//多进程版本的网络服务器
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ctype.h>
#include "wrap.h"

//gcc -o server 01-mult-process.c wrap.c
int main()
{
	//创建socket
	int lfd = Socket(AF_INET, SOCK_STREAM, 0);
	
	//绑定
	struct sockaddr_in serv;
	bzero(&serv, sizeof(serv));
	serv.sin_family = AF_INET;
	serv.sin_port = htons(8888);
	serv.sin_addr.s_addr = htonl(INADDR_ANY);
	Bind(lfd, (struct sockaddr *)&serv, sizeof(serv));
	
	//设置监听
	Listen(lfd, 128);
	
	pid_t pid;
	int cfd;
	char sIP[16];
	socklen_t len;
	struct sockaddr_in client;
	while(1){
		//接受新的连接
		len = sizeof(client);
		memset(sIP, 0x00, sizeof(sIP));
		cfd = Accept(lfd, (struct sockaddr *)&client, &len);
		printf("client:[%s] [%d]\n", inet_ntop(AF_INET, &client.sin_addr.s_addr, sIP, sizeof(sIP)), ntohs(client.sin_port));

		//接受一个新的连接, 创建一个子进程,让子进程完成数据的收发操作
		pid = fork();
		if(pid<0){
			perror("fork error");
			exit(-1);
		}
		else if(pid>0){
			//关闭通信文件描述符cfd
			close(cfd);
		}
		else if(pid==0){
			//关闭监听文件描述符
			close(lfd);

			int i=0;
			int n;
			char buf[1024];

			while(1){
				//读数据
				n = Read(cfd, buf, sizeof(buf));
				if(n <= 0){
					printf("read error or client closed, n==[%d]\n", n);
					break;
				}
				//printf("client:[%s] [%d]\n", inet_ntop(AF_INET, &client.sin_addr.s_addr, sIP, sizeof(sIP)), ntohs(client.sin_port));
				printf("[%d]---->:n==[%d], buf==[%s]\n", ntohs(client.sin_port), n, buf);

				//将小写转换为大写
				for(i=0; i<n; i++)
					buf[i] = toupper(buf[i]);
				//发送数据
				Write(cfd, buf, n);
			}

			//关闭cfd
			close(cfd);
			exit(0);
		}
	}

	//关闭监听文件描述符
	close(lfd);

	return 0;
}

/*
#启动服务端进程
aaron@aaron-virtual-machine:~$ gcc -o server 01-mult-process.c wrap.c
aaron@aaron-virtual-machine:~$ ./server

#检查8888端口
aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      3019/./mutiprocess

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
Hello
HELLO

#再打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
nice
NICE

#服务器端接收到数据
aaron@aaron-virtual-machine:~$ ./mutiprocess
client:[127.0.0.1] [60832]
[60832]---->:n==[6], buf==[Hello
]
client:[127.0.0.1] [60836]
[60836]---->:n==[5], buf==[nice
]

aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      3019/./mutiprocess
tcp        0      0 127.0.0.1:8888          127.0.0.1:60836         ESTABLISHED 3049/./mutiprocess
tcp        0      0 127.0.0.1:60832         127.0.0.1:8888          ESTABLISHED 3036/nc
tcp        0      0 127.0.0.1:8888          127.0.0.1:60832         ESTABLISHED 3037/./mutiprocess
tcp        0      0 127.0.0.1:60836         127.0.0.1:8888          ESTABLISHED 3048/nc
*/