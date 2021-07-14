//父进程使用 SICCHLD 信号完成对子进程的回收
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

void waitchild(int signo)
{
	pid_t wpid;

	//回收子进程
	while(1){
		wpid = waitpid(-1, NULL, WNOHANG);
		
		if(wpid>0){
			printf("child is quit, wpid==[%d]\n", wpid);
		}
		else if(wpid==0){
			printf("child is living, wpid==[%d]\n", wpid);
			break;
		}
		else if(wpid==-1){
			printf("no child is living, wpid==[%d]\n", wpid);
			break;
		}
	}
}

int main()
{
	pid_t pid;
	int i = 0;

	for(i=0; i<3; i++)	{
		
		pid = fork();  //fork子进程
		if(pid < 0){   //fork失败的情况
			perror("fork error");
			return -1;
		}
		else if(pid>0){ //父进程
			printf("father process, pid==[%d], child pid==[%d]\n", getpid(), pid);
			sleep(1);
		}
		else if(pid==0){ //子进程
			printf("child process, father pid==[%d], pid==[%d]\n", getppid(), getpid());
			break;
		}
	}

	//第1个子进程
	if(i==0){
		printf("[%d]:child: cpid==[%d]\n", i, getpid());
		sleep(1);
	}

	//第2个子进程
	if(i==1){
		printf("[%d]:child: cpid==[%d]\n", i, getpid());
		sleep(2);
	}

	//第3个子进程
	if(i==2){
		printf("[%d]:child: cpid==[%d]\n", i, getpid());
		sleep(3);
	}

	//父进程
	if(i==3){
		printf("[%d]:father: fpid==[%d]\n", i, getpid());

		//注册 SICCHLD 信号处理函数
		struct sigaction act;
		act.sa_handler = waitchild;
		sigemptyset(&act.sa_mask);  //将某个信号集清0。阻塞的信号。在信号处理函数执行期间, 不阻塞任何信号	
		act.sa_flags = 0;
		
		sigaction(SIGCHLD, &act, NULL);
		while(1){
			sleep(1);
		}
	}	
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make sigchld2
cc     sigchld2.c   -o sigchld2
aaron@aaron-virtual-machine:~/桌面/test$ ./sigchld2 
father: fpid==[19670], cpid==[19671]
child: fpid==[19670], cpid==[19671]
[0]:child: cpid==[19671]
father: fpid==[19670], cpid==[19672]
child: fpid==[19670], cpid==[19672]
[1]:child: cpid==[19672]
father: fpid==[19670], cpid==[19673]
child: fpid==[19670], cpid==[19673]
[2]:child: cpid==[19673]
[3]:father: fpid==[19670]
child is quit, wpid==[19671]          //子进程退出
child is quit, wpid==[19672]
child is quit, wpid==[19673]
no child is living, wpid==[-1]
*/