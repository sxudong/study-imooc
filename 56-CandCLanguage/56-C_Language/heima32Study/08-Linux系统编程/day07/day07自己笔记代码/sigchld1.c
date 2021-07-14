//验证 SICCHLD 信号是如何产生的：子进程退出，SIGSTOP,SIGQUIT
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

//信号处理函数
void sighandler(int signo) //信号处理函数执行期间需要阻塞的信号
{
	printf("signo==[%d]\n", signo);
}

int main()
{
	pid_t pid;
	int i = 0;

	signal(SIGCHLD, sighandler); //注册信号	
	
	pid = fork(); //fork子进程
	
	if(pid < 0){  //fork失败的情况
		perror("fork error");
		return -1;
	}
	else if(pid > 0){  //父进程
		printf("father: pid==[%d], child pid==[%d]\n", getpid(), pid);
		while(1){
			sleep(1);
		}
	}
	else if(pid == 0){ //子进程
		printf("child: father pid==[%d], pid==[%d]\n", getppid(), getpid());
		while(1){
			sleep(1);
		}
	}
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make sigchld1
cc     sigchld1.c   -o sigchld1
aaron@aaron-virtual-machine:~/桌面/test$ ./sigchld1 
father: pid==[18907], child pid==[18908]
child: father pid==[18907], pid==[18908]
signo==[17]
signo==[17]
signo==[17]

aaron@aaron-virtual-machine:~$ kill -STOP 18908  //触发signo==[17]信号
aaron@aaron-virtual-machine:~$ kill -CONT 18908  //触发signo==[17]信号
aaron@aaron-virtual-machine:~$ kill -9 18908     //触发signo==[17]信号
*/