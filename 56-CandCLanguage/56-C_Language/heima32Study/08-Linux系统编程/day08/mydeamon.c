/*
* 创建守护进程（ps -ajx 查看守护进程）
*
* 由setitimer触发的SIGALRM信号
* 
* 编写一个守护进程，每隔2S钟获取一次系统时间，并将这个时间写入磁盘文件。
* 分析：首先要按照1.3介绍的守护进行的步骤创建一个守护进程.
* 	每隔2S钟: 使用setitimer函数设置时钟, 该时钟发送的是SIGALRM信号,
* 	信号操作: 注册信号处理函数,signal或者sigaction, 还有一个信号处理函数
* 	获取一次系统时间: time函数的使用, ctime函数的使用
* 	写入磁盘文件: 文件操作函数: open write close 
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>

void myfunc(int signo)
{
	//打开文件
	int fd = open("mydemon.log", O_RDWR | O_CREAT | O_APPEND, 0755); //O_APPEND追加
	if(fd<0)
		return;

	//获取当前的系统时间
	time_t t;
	time(&t);
	char *p = ctime(&t);
	
	//将时间写入文件
	write(fd, p, strlen(p));

	close(fd);

	return;
}

int main()
{
	//1.父进程fork子进程, 然后父进程退出
	pid_t pid = fork();
	if(pid<0 || pid>0) //小于0创建失败，退出
		exit(1);
	
	//子进程调用setsid函数创建会话
	setsid();

	//改变当前的工作目录
	chdir("/home/aaron/log");

	//改变文件掩码
	umask(0000);

	//关闭标准输入,输出和错误输出文件描述符
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

	//核心操作
	//注册信号处理函数
	struct sigaction act;
	act.sa_handler = myfunc;
	act.sa_flags = 0;
	sigemptyset(&act.sa_mask);	    //将某个信号集清0
	sigaction(SIGALRM, &act, NULL); //捕捉函数sigaction,捕捉SIGALRM信号

	//设置时钟（毫秒级的延时）
	struct itimerval tm;
	//周期性时间赋值
	tm.it_interval.tv_sec = 2;  //每隔2S钟获取一次系统时间
	tm.it_interval.tv_usec = 0;
	//第一次触发的时间
	tm.it_value.tv_sec = 3;     //3秒种过后
	tm.it_value.tv_usec = 0;
	setitimer(ITIMER_REAL, &tm, NULL); //计时器。ITIMER_REAL：自然定时

	printf("hello world\n");

	while(1)
	{
		sleep(1);
	}
}
