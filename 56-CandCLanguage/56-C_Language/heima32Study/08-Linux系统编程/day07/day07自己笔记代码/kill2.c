//kill函数测试：子进程杀死父进程
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
		}
		else if(pid==0){ //子进程
			printf("child process, father pid==[%d],pid==[%d]\n", getppid(), getpid());
			break;
		}
	}


	//第1个子进程
	if(i == 0){
		printf("the first child,pid==[%d]\n", getpid());
		//子进程杀死父进程 (严格的说不是杀死父进程，是给父进程发信号)
		kill(getppid(),SIGKILL); //getppid()父进程ID
		sleep(10);
	}

	//第2个子进程
	if(i == 1){
		printf("the second child,pid==[%d]\n", getpid());	
		sleep(10);
	}

	//第3个子进程
	if(i == 2){
		printf("the third child,pid==[%d]\n", getpid());
		sleep(10);
	}
	//父进程
	if(i == 3){
		printf("the father,pid==[%d]\n", getpid());	
		sleep(10);
	}
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make kill2
cc     kill2.c   -o kill2
aaron@aaron-virtual-machine:~/桌面/test$ ./kill2 
father process, pid==[8668],child pid==[8669]
father process, pid==[8668],child pid==[8670]
child process, father pid==[8668],pid==[8669]
the first child,pid==[8669]
child process, father pid==[8668],pid==[8670]
the second child,pid==[8670]
已杀死
*/