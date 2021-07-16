//多线程版本的高并发服务器
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ctype.h>
#include <pthread.h> //引入多线程库头文件
#include "wrap.h"


/*
* 类似15-java-base socket/bio/chart2/ChatServer.java
*
* 问题原因：
* pthread 库不是 Linux 系统默认的库，连接时需要使用静态库 libpthread.a，
* 所以在使用pthread_create()创建线程，以及调用 pthread_atfork()函数建立
  fork处理程序时，需要链接该库。
*
* 问题解决：
* 在编译中要加 -lpthread参数
* gcc -o mutithread 02-muti-thread.c wrap.c-lpthread
* 02-muti-thread.c为你些的源文件，不要忘了加上头文件#include <pthread.h>
*
* gcc -o mutithread 02-muti-thread.c wrap.c -lpthread
*/


//子线程回调函数
void *thread_work(void *arg)
{
	sleep(20);
	int cfd = *(int *)arg;
	printf("cfd==[%d]\n", cfd);
	
	int i;
	int n;
	char buf[1024];
	
	while(1)
	{
		//read数据
		memset(buf, 0x00, sizeof(buf));
		n = Read(cfd, buf, sizeof(buf));
		if(n <= 0){
			printf("read error or client closed,n==[%d]\n", n);
			break;
		}
		printf("n==[%d], buf==[%s]\n", n, buf);
		
		for(i=0; i<n; i++){
			buf[i] = toupper(buf[i]);
		}
		//发送数据给客户端
		Write(cfd, buf, n);	
	}
	
	//关闭通信文件描述符
	close(cfd);
	
	pthread_exit(NULL);
}

int main()
{
	//创建socket
	int lfd = Socket(AF_INET, SOCK_STREAM, 0);
	
	//设置端口复用
	int opt = 1;
	//OpenJDK12源码 /openjdk/src/jdk.net/linux/native/libextnet/LinuxSocketOptions.c 调用了setsockopt()函数
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
	
	int cfd;
	pthread_t threadID;
	while(1){
		//接受新的连接
		cfd = Accept(lfd, NULL, NULL);
		
		//创建子线程
		pthread_create(&threadID, NULL, thread_work, &cfd);
		
		//设置子线程为分离属性
		pthread_detach(threadID);
	}

	//关闭监听文件描述符
	close(lfd);
	
	return 0;
}

/*
#编译
aaron@aaron-virtual-machine:~$ gcc -o mutithread 02-muti-thread.c wrap.c -lpthread
aaron@aaron-virtual-machine:~$ ls
01-mult-process.c  02-muti-thread.c  mutithread  wrap.c  wrap.h
aaron@aaron-virtual-machine:~$ ./mutithread
cfd==[4]
n==[12], buf==[Hello
World
]
cfd==[5]
n==[6], buf==[
nice
]

#查看端口是否启动
aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      2918/./mutithread

#测试连接发送数据
aaron@aaron-virtual-machine:~$ nc 127.1 8888
Hello
World
HELLO
WORLD

aaron@aaron-virtual-machine:~$ nc 127.1 8888
nice
NICE

aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      2918/./mutithread
tcp        0      0 127.0.0.1:60788         127.0.0.1:8888          ESTABLISHED 2947/nc
tcp        0      0 127.0.0.1:8888          127.0.0.1:60788         ESTABLISHED 2918/./mutithread
tcp        0      0 127.0.0.1:8888          127.0.0.1:60784         ESTABLISHED 2918/./mutithread
tcp        0      0 127.0.0.1:60784         127.0.0.1:8888          ESTABLISHED 2935/nc
*/