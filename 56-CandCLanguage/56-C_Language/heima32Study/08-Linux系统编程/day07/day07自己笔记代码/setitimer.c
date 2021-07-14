//setitimer函数测试
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>

//信号处理函数
void sighandler(int signo)
{
	printf("signo==[%d]\n", signo);
}

int main()
{
	//方法：int setitimer(int which, 
	//           const struct itimerval *new_value,
	//                 struct itimerval *old_value);
	
	//注册信号 SIGALRM 信号处理函数
	signal(SIGALRM, sighandler);
	
	struct itimerval tm;
	//周期性时间赋值
	tm.it_interval.tv_sec = 1;  //每隔1秒钟
	tm.it_interval.tv_usec = 0;

	//第一次触发的时间
	tm.it_value.tv_sec = 3; //3秒钟后，每隔1秒钟，发送SIGALRM信号
	tm.it_value.tv_usec = 0;
	
	setitimer(ITIMER_REAL,&tm, NULL);
	
	while(1){
		sleep(1);
	}
	return 0;
}

/* 
aaron@aaron-virtual-machine:~/桌面/test$ make setitimer
cc     setitimer.c   -o setitimer
aaron@aaron-virtual-machine:~/桌面/test$ ./setitimer 
signo==[14]
signo==[14]
signo==[14]
......
*/