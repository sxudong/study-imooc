//kill函数测试：杀死同一组所有的进程
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

void waitchild(int signo)
{
	printf("signo==[%d]\n", signo);
}

int main()
{
	int i = 0;
	int n = 3;

	for(i=0; i<n; i++)	{
		//fork子进程
		pid_t pid = fork();
		if(pid < 0){ //fork失败的情况
			perror("fork error");
			return -1;
		}
		else if(pid > 0){ //父进程
			printf("father process, pid==[%d],child pid==[%d]\n", getpid(), pid);
			/*
			* 父进程杀死第一个子进程
			*/
			/*
			if(i==0){
				kill(pid,SIGKILL);
			}
			*/
		}
		else if(pid==0){ //子进程
			printf("child process, father pid==[%d],pid==[%d]\n", getppid(), getpid());
			break;
		}
	}


	//第1个子进程
	if(i == 0){
		//杀死同一组所有的进程
		//3.2 kill函数/命令
		//pid = 0: 发送信号给与调用kill函数进程属于同一进程组的所有进程。
		kill(0, SIGKILL);
		
		printf("the first child,pid==[%d]\n", getpid());
		
		/*
		* 子进程杀死父进程 (严格的说不是杀死父进程，是给父进程发信号)
		*/
		//kill(getppid(),SIGKILL);
		
		//pid = -1：发送给进程有权限发送的系统中所有进程。
		//kill(-1, SIGKILL); //连接这台服务器的连接全部干掉
		
		sleep(1);
	}

	//第2个子进程
	if(i == 1){
		printf("the second child,pid==[%d]\n", getpid());	
		sleep(10);
	}

	//第3个子进程
	if(i == 2){
		printf("the third child,pid==[%d]\n", getpid());
		sleep(100);
	}
	//父进程
	if(i == 3){
		printf("the father,pid==[%d]\n", getpid());	
	}
	return 0;
}

/* 没有“the first child”，已经杀死
aaron@aaron-virtual-machine:~/桌面/test$ make kill3
cc     kill3.c   -o kill3
aaron@aaron-virtual-machine:~/桌面/test$ ./kill3 
father process, pid==[8792],child pid==[8793]
father process, pid==[8792],child pid==[8794]
child process, father pid==[8792],pid==[8793]
已杀死
*/