//alarm函数测试
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

/*
alarm:
	1 每一个进程都只有一个时钟
	2 alarm函数的返回值: 0 或者是上一个alarm剩余的秒数
	3 alarm(0): 取消定时器
	4 alarm函数发送的是SIGALRM信号
*/

//信号处理函数
void sighandler(int signo)
{
	printf("signo==[%d]\n", signo);
}

int main()
{
	signal(SIGALRM, sighandler);
	
	//设置时钟
	int n = alarm(5);
	printf("n==[%d]\n",n);
	
	sleep(2);
	n = alarm(2); //2秒钟后通知sighandler信号处理函数
	printf("n==[%d]\n",n);
	
	//取消时钟
	n = alarm(0); //由于已经取消了时钟，sighandler信号处理函数将不会打印
	printf("n==[%d]\n",n);
	
	sleep(10);
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make alarm2
cc     alarm2.c   -o alarm2
aaron@aaron-virtual-machine:~/桌面/test$ ./alarm2
n==[0]
n==[3]
n==[2]
*/