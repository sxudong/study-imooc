//编写libevent服务端
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <string.h>
#include <event2/event.h>

struct event *connev = NULL;

//typedef void (*event_callback_fn)(evutil_socket_t fd, short events, void *arg);
void readcb(evutil_socket_t fd, short events, void *arg)
{
	int n;
	char buf[1024];
	memset(buf, 0x00, sizeof(buf));
	n = read(fd, buf, sizeof(buf));
	if(n<=0){
		close(fd);
		//将通信文件描述符对应的事件从 base地基 上删除
		event_del(connev);
	}
	else{
		write(fd, buf, n);
	}
}

void conncb(evutil_socket_t fd, short events, void *arg)
{
	struct event_base *base = (struct event_base *)arg;

	//接受新的客户端连接
	int cfd = accept(fd, NULL, NULL);
	if(cfd>0)
	{
		//创建通信文件描述符对应的事件并设置回调函数为 readcb
		connev = event_new(base, cfd, EV_READ|EV_PERSIST, readcb, NULL);
		if(connev==NULL)
		{
			//退出循环
			event_base_loopexit(base, NULL);
		}
		
		//将通信文件描述符对应的事件上 event_base 地基
		event_add(connev, NULL);	
	}	
}

int main()
{
	//创建socket
	int lfd = socket(AF_INET, SOCK_STREAM, 0);

	//设置端口复用
	int opt = 1;
	setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

	//绑定
	struct sockaddr_in serv;
	bzero(&serv, sizeof(serv));
	serv.sin_addr.s_addr = htonl(INADDR_ANY);
	serv.sin_port = htons(8888);
	serv.sin_family = AF_INET;
	bind(lfd, (struct sockaddr*)&serv, sizeof(serv));

	//监听
	listen(lfd, 120);

	//创建地基
	struct event_base *base = event_base_new();
	if(base==NULL)
	{
		printf("event_base_new error\n");
		return -1;
	}

	//创建监听文件描述符对应的事件
	//struct event *event_new(struct event_base *base, evutil_socket_t fd, short events, event_callback_fn cb, void *arg);
	struct event *ev = event_new(base, lfd, EV_READ|EV_PERSIST, conncb, base);
	if(ev==NULL)
	{
		printf("event_new error\n");
		return -1;
	}

	//将新的事件节点上base地基
	event_add(ev, NULL);

	//进入事件循环等待
	event_base_dispatch(base);

	//释放资源
	event_base_free(base);
	event_free(ev);

	close(lfd);
	return 0;

}
/*
#编译启动服务端
aaron@aaron-virtual-machine:~$ gcc -o event_sever 01-event-server.c -levent
aaron@aaron-virtual-machine:~$ ./event_sever 

aaron@aaron-virtual-machine:~$ nc 127.1 8888
hello
hello

aaron@aaron-virtual-machine:~$ nc 127.1 8888
world
world

aaron@aaron-virtual-machine:~$ nc 127.1 8888
nice
nice
^C    //退出连接

aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      27233/./event_sever 
tcp        0      0 127.0.0.1:58416         127.0.0.1:8888          ESTABLISHED 27274/nc            
tcp        0      0 127.0.0.1:8888          127.0.0.1:58416         ESTABLISHED 27233/./event_sever 
tcp        0      0 127.0.0.1:58412         127.0.0.1:8888          ESTABLISHED 27260/nc            
tcp        0      0 127.0.0.1:8888          127.0.0.1:58412         ESTABLISHED 27233/./event_sever 
tcp        0      0 127.0.0.1:58420         127.0.0.1:8888          TIME_WAIT   -          //主动关闭方处理TIME_WAIT状态  

*/