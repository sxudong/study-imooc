//web服务端程序--使用epoll模型
#include <unistd.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>
#include <dirent.h>

#include "pub.h"
#include "wrap.h"

int http_request(int cfd);

int main()
{
	//改变当前进程的工作目录
	char path[255] = {0};
	sprintf(path, "%s/%s", getenv("HOME"), "webpath");
	printf("HOME : %s\n", getenv("HOME")); //HOME : /home/aaron
	chdir(path);
	printf("path : %s\n", path);
	
	//创建socket -- 设置端口复用---bind
	int lfd = tcp4bind(9999, NULL);
	
	//设置监听
	Listen(lfd, 128);

	//创建epoll树
	int epfd = epoll_create(1024);
	if(epfd<0)
	{
		perror("epoll_create error");
		close(lfd);
		return -1;
	}
	
	//将监听文件描述符lfd上树
	struct epoll_event ev;
	ev.data.fd = lfd;
	ev.events = EPOLLIN;
	epoll_ctl(epfd, EPOLL_CTL_ADD, lfd, &ev);
	
	int i;
	int cfd;
	int nready;
	int sockfd;
	struct epoll_event events[1024];
	while(1)
	{
		//等待事件发生
		nready = epoll_wait(epfd, events, 1024, -1);
		if(nready<0)
		{
			if(errno==EINTR)
			{
				continue;
			}
			break;
		}
		
		for(i=0; i<nready; i++)
		{
			sockfd = events[i].data.fd;
			//有客户端连接请求
			if(sockfd==lfd)
			{
				//接受新的客户端连接
				cfd = Accept(lfd, NULL, NULL);
				
				//设置cfd为非阻塞
				int flag = fcntl(cfd, F_GETFL);
				flag |= O_NONBLOCK;
				fcntl(cfd, F_SETFL, flag);
				
				//将新的cfd上树
				ev.data.fd = cfd;
				ev.events = EPOLLIN;
				epoll_ctl(epfd, EPOLL_CTL_ADD, cfd, &ev);
			}
			else 
			{
				//有客户端数据发来
				http_request(cfd);
			}			
		}		
	}
}

int send_header(int cfd, char *code, char *msg, char *fileType, int len)
{
	char buf[1024] = {0};
	sprintf(buf, "HTTP/1.1 %s %s\r\n", code, msg);
	sprintf(buf+strlen(buf), "Content-Type:%s\r\n", fileType);
	if(len>0)
	{
		sprintf(buf+strlen(buf), "Content-Length:%d\r\n", len);
	}
	strcat(buf, "\r\n");
	Write(cfd, buf, strlen(buf));
	return 0;
}

int send_file(int cfd, char *fileName)
{
	//打开文件
	int fd = open(fileName, O_RDONLY);
	if(fd<0)
	{
		perror("open error");
		return -1;
	}
	
	//循环读文件, 然后发送
	int n;
	char buf[1024];
	while(1)
	{
		memset(buf, 0x00, sizeof(buf));
		n = read(fd, buf, sizeof(buf));
		if(n<=0)
		{
			break;
		}
		else 
		{
			Write(cfd, buf, n);
		}
	}
}

int http_request(int cfd)
{
	int n;
	char buf[1024];
	//读取请求行数据, 分析出要请求的资源文件名
	memset(buf, 0x00, sizeof(buf));
	Readline(cfd, buf, sizeof(buf));
	printf("buf==[%s]\n", buf);
	//GET /hanzi.c HTTP/1.1
	char reqType[16] = {0};
	char fileName[255] = {0};
	char protocal[16] = {0};
	sscanf(buf, "%[^ ] %[^ ] %[^ \r\n]", reqType, fileName, protocal);
	printf("[%s]\n", reqType);
	printf("[%s]\n", fileName);
	printf("[%s]\n", protocal);
	
	char *pFile = fileName+1;
	printf("[%s]\n", pFile);
	
	//循环读取完剩余的数据
	while((n=Readline(cfd, buf, sizeof(buf)))>0);
	
	//判断文件是否存在
	struct stat st;
	if(stat(pFile, &st)<0)
	{
		printf("file not exist\n");
		
		//发送头部信息
		send_header(cfd, "404", "NOT FOUND", get_mime_type(".html"), 0);
		
		//发送文件内容
		send_file(cfd, "error.html");	
	}
	else //若文件存在
	{
		//判断文件类型
		//普通文件
		if(S_ISREG(st.st_mode))
		{
			printf("file exist\n");
			//发送头部信息
			send_header(cfd, "200", "OK", get_mime_type(pFile), st.st_size);
			
			//发送文件内容
			send_file(cfd, pFile);
		}
		//目录文件
		else if(S_ISDIR(st.st_mode))
		{
			
		}
	}
}
/* 
//浏览器中访问：http://192.168.19.142:9999/log_demo.c
#将要访问的文件放在 webpath 下
aaron@aaron-virtual-machine:~/webpath$ pwd
/home/aaron/webpath
aaron@aaron-virtual-machine:~/webpath$ ls
log_demo.c

#编译并启动web服务
aaron@aaron-virtual-machine:~/桌面/test$ gcc -o webserver webserver.c wrap.c pub.c
aaron@aaron-virtual-machine:~/桌面/test$ ./webserver 
HOME : /home/aaron
path : /home/aaron/webpath
buf==[GET /log_demo.c HTTP/1.1
]
[GET]
[/log_demo.c]
[HTTP/1.1]
[log_demo.c]
file exist
buf==[GET /favicon.ico HTTP/1.1
]
[GET]
[/favicon.ico]
[HTTP/1.1]
[favicon.ico]
file not exist
open error: No such file or directory
*/