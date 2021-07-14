//sigaction函数测试：注册信号处理函数
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

/*
1 在xxx信号处理函数执行期间，若xxx信号再次产生多次，则信号处理函数不会被打断，
当信号处理函数执行完以后，后来产生的信号只会被处理一次。

      信号不支持排队。
*/

//信号处理函数
void sighandler(int signo) //信号处理函数执行期间需要阻塞的信号
{
	printf("signo==[%d]\n", signo);
	sleep(3);
}

int main()
{
	//注册 SIGINT 信号处理函数
	struct sigaction act;
	act.sa_handler = sighandler; //信号处理函数
	sigemptyset(&act.sa_mask);   //阻塞的信号。在信号处理函数执行期间, 不阻塞任何信号
	act.sa_flags = 0;
	
	sigaction(SIGINT, &act, NULL);

	while(1){
		sleep(1);
	}
	return 0;
}

/* 按ctrl+c不阻塞，休眠1秒直接打印
aaron@aaron-virtual-machine:~/桌面/test$ make sigaction1
cc     sigaction1.c   -o sigaction1
aaron@aaron-virtual-machine:~/桌面/test$ ./sigaction1 
^Csigno==[2]
^Csigno==[2]
^Csigno==[2]
*/