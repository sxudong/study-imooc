//EPOLL模型测试
#include "wrap.h"
#include <sys/epoll.h>
#include <ctype.h>

int main()
{
	int ret;
	int n;
	int i;
	int k;
	int nready;
	int lfd;
	int cfd;
	int sockfd;
	char buf[1024];
	socklen_t socklen;
	struct sockaddr_in svraddr;
	struct epoll_event ev;
	struct epoll_event events[1024];
	
	//创建socket
	lfd = Socket(AF_INET, SOCK_STREAM, 0);
	
	//设置文件描述符为端口复用
	int opt = 1;
	setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(int));

	//绑定bind
	svraddr.sin_family = AF_INET;
	svraddr.sin_addr.s_addr = htonl(INADDR_ANY);
	svraddr.sin_port = htons(8888);
	Bind(lfd, (struct sockaddr *)&svraddr, sizeof(struct sockaddr_in));
	
	//监听listen
	Listen(lfd, 128);
	
	//创建一棵epoll树
	int epfd = epoll_create(1024);
	if(epfd<0)
	{
		perror("create epoll error");
		return -1;
	}
	
	//将lfd上epoll树
	ev.data.fd = lfd;
	ev.events = EPOLLIN;
	epoll_ctl(epfd, EPOLL_CTL_ADD, lfd, &ev);
	
	while(1)
	{
		nready = epoll_wait(epfd, events, 1024, -1);
		if(nready<0)
		{
			perror("epoll_wait error");
			if(errno==EINTR)
			{
				continue;
			}
			break;			
		}
		
		for(i=0; i<nready; i++)
		{
			//有客户端连接请求
			sockfd = events[i].data.fd;
			if(sockfd==lfd)
			{
				cfd = Accept(lfd, NULL, NULL);
				//将新的cfd上epoll树
				ev.data.fd = cfd;
				ev.events = EPOLLIN;
				epoll_ctl(epfd, EPOLL_CTL_ADD, cfd, &ev);
				continue;
			}
			
			//有客户端发送数据过来
			memset(buf, 0x00, sizeof(buf));
			n = Read(sockfd, buf, sizeof(buf));
			if(n<=0)
			{
				printf("n==[%d], buf==[%s]\n", n, buf);
				close(sockfd);
				//将sockfd对应的事件就节点从epoll树上删除
				epoll_ctl(epfd, EPOLL_CTL_DEL, sockfd, NULL);
				
			}
			else 
			{
				printf("n==[%d], buf==[%s]\n", n, buf);
				for(k=0; k<n; k++)
				{
					buf[k] = toupper(buf[k]); //小写转大写
				}
				Write(sockfd, buf, n);
			}
		}
	}
	
	close(epfd);
	close(lfd);
	return 0;
}

/*
aaron@aaron-virtual-machine:~$ gcc -o 01-epoll-1 01-epoll-1.c wrap.c
aaron@aaron-virtual-machine:~$ ./01-epoll-1 
n==[6], buf==[hello
]
n==[5], buf==[nice
]
n==[8], buf==[welcome
]
n==[0], buf==[]          //退出返回0

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
hello
HELLO

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
nice
NICE

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 8888
welcome
WELCOME
^C          //退出

，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      6937/./01-epoll-1   
tcp        0      0 127.0.0.1:8888          127.0.0.1:34522         ESTABLISHED 6937/./01-epoll-1   
tcp        0      0 127.0.0.1:8888          127.0.0.1:34524         ESTABLISHED 6937/./01-epoll-1   
tcp        0      0 127.0.0.1:34546         127.0.0.1:8888          TIME_WAIT   -                  //主动关闭方处理TIME_WAIT状态             
tcp        0      0 127.0.0.1:34522         127.0.0.1:8888          ESTABLISHED 6938/nc             
tcp        0      0 127.0.0.1:34524         127.0.0.1:8888          ESTABLISHED 6939/nc 
*/