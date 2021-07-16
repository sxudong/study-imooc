//select, 同时监听多个文件描述符, 将监控的操作交给内核去处理。
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ctype.h>
#include "wrap.h"


int main()
{
	//创建socket
	int lfd = Socket(AF_INET, SOCK_STREAM, 0);
	
	//设置端口复用
	int opt = 1;
	setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(int)); 

	//绑定
	struct sockaddr_in serv;
	bzero(&serv, sizeof(serv));
	serv.sin_family = AF_INET;
	serv.sin_port = htons(8888);
	serv.sin_addr.s_addr = htonl(INADDR_ANY);
	Bind(lfd, (struct sockaddr *)&serv, sizeof(serv));
	
	//设置监听
	Listen(lfd, 128);
	
	//定义fd_set类型的变量
	fd_set readfds; 
	fd_set tmpfds;
	
	//清空readfds和tmpfds集合
	FD_ZERO(&readfds);
	FD_ZERO(&tmpfds); 
	
	//将lfd加入到readfds中，委托内核监控
	FD_SET(lfd, &readfds);
	int maxfd = lfd;
	int nready;
	int cfd;
	int i;
	int sockfd;
	int n;
	char buf[1024];
	
	while(1){
		tmpfds = readfds;
		//tmpfds是输入输出参数：
		//输入：告诉内核要监测哪些文件描述符
		//输出：内核告诉应用程序有哪些文件描述符发生了变化
		nready = select( maxfd+1,&tmpfds,NULL,NULL,NULL);
		if(nready<0){
			if(errno==EINTR)//被信号中断
			{
				continue;
			}
			break;
		}
		printf("nready==[%d]\n",nready);
		//有客户端连接请求到来
		if(FD_ISSET(lfd,&tmpfds)){
			
			//接受新的客户端连接请求
			cfd = Accept(lfd,NULL,NULL);
			
			//将cfd加入到readfds集合中
			FD_SET(cfd,&readfds);
			
			//修改内核的监控范围
			if (maxfd<cfd)
				maxfd = cfd;
				
			if(--nready==0)
				continue ;	
		}
		//有数据发来的情况
		for(i=lfd+1; i<=maxfd; i++){
			
			sockfd = i;
			//判断sockfd文件描述符是否有变化
			if(FD_ISSET(sockfd,&tmpfds))
			{	
				//读数据
				memset(buf,0x00,sizeof(buf));
				n = Read(sockfd,buf,sizeof(buf));
				if(n<=0){
					//关闭连接
					close(sockfd);
					//将sockfd从readfds中删除
					FD_CLR(sockfd, &readfds);

				}
				else{
					printf("n==[%d]，buf==[%s]\n", n, buf);
					int k=0; 
					for(k=0; k<n; k++){
						buf[k] = toupper(buf[k]);
					}
					Write(sockfd,buf,n);
				}
				
				if(--nready==0){ //减少循环次数
					break;
				}
			}
		}
	}
	//关闭监听文件描述符
	close(lfd);

	return 0;
}	

/*
aaron@aaron-virtual-machine:~$ gcc -o select select.c wrap.c
aaron@aaron-virtual-machine:~$ ./select 
read over,n==[6],buf==[hello
]
read over,n==[5],buf==[nice
]
read over,n==[9],buf==[welecome
]
read error or client closed,n==[0]


#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
hello
HELLO

#打开另一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
nice
NICE
^C    //退出

#现在有2个链接
aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      6284/./select       
tcp        0      0 127.0.0.1:8888          127.0.0.1:33906         ESTABLISHED 6284/./select       
tcp        0      0 127.0.0.1:33906         127.0.0.1:8888          ESTABLISHED 6285/nc             
tcp        0      0 127.0.0.1:33910         127.0.0.1:8888          TIME_WAIT   -              //主动关闭方处理TIME_WAIT状态
*/