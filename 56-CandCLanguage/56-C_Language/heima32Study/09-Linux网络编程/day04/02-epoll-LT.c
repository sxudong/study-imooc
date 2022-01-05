//EPOLL模型测试——epoll默认情况下是LT模式
#include "wrap.h"
#include <sys/epoll.h>
#include <ctype.h>

/*
 epoll的LT和ET模式:
	1 epoll默认情况下是LT模式, 在这种模式下, 若读数据一次性没有读完,
	  缓冲区中还有可读数据, 则epoll_wait还会再次通知
	2 若将epoll设置为ET模式, 若读数据的时候一次性没有读完, 则epoll_wait不再通知,
	  直到下次有新的数据发来.
*/	  
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
	
	//创建一棵epoll树句柄（红黑树）
	int epfd = epoll_create(1024);
	if(epfd<0)
	{
		perror("create epoll error");
		return -1;
	}
	
	//将lfd上epoll树
	ev.data.fd = lfd; //lfd是Socket，ev是epoll_event 结构体
	ev.events = EPOLLIN;
	epoll_ctl(epfd, EPOLL_CTL_ADD, lfd, &ev); //将socket上到epfd树上
	
	while(1)
	{
	    // epfd: epoll_create()创建的一棵epoll树句柄
	    // events: epoll_event 结构体
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
			//n = recv(sockfd, buf, sizeof(buf), 0); //epoll默认情况下是LT模式, 在这种模式下, 若读数据一次性没有读完
			n = recv(sockfd, buf, 2, 0); //一次读2个字符
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
				//Write(sockfd, buf, n);
				send(sockfd, buf, n, 0);
			}
		}
	}
	
	close(epfd);
	close(lfd);
	return 0;
}

/*
#它会读5次，每次读2个字节
aaron@aaron-virtual-machine:~/桌面/test$ gcc -o epoll 02-epoll-LT.c wrap.c
aaron@aaron-virtual-machine:~/桌面/test$ ./epoll 
n==[2], buf==[11]
n==[2], buf==[22]
n==[2], buf==[33]
n==[2], buf==[44]
n==[2], buf==[55]
n==[1], buf==[
]


aaron@aaron-virtual-machine:~$ nc 127.1 8888
1122334455
1122334455

*/