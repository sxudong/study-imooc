//父进程使用 SICCHLD 信号完成对子进程的回收(代码与课堂一致)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

/*
* 解决3个子进程都成为“僵尸进程”的问题
*   1.在注册之前，先将 SIGCHLD 信号阻塞
*   2.完成 SIGCHLD信号 的注册后，解除对 SIGCHLD信号 的阻塞。
*/
void waitchild(int signo) 
{
	pid_t wpid;

	//收到一个信号完成回收多个子进程
	while(1) 
	{
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

	//将 SIGCHLD 信号阻塞
	sigset_t mask;
	sigemptyset(&mask);
	sigaddset(&mask, SIGCHLD);
	sigprocmask(SIG_BLOCK, &mask, NULL); //阻塞
	
	for(i=0; i<3; i++)	{
		
		pid = fork();  //fork子进程
		if(pid < 0){   //fork失败的情况
			perror("fork error");
			return -1;
		}
		else if(pid>0){ //父进程
			printf("father process, pid==[%d], child pid==[%d]\n", getpid(), pid);
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
		sleep(1);
	}

	//第3个子进程
	if(i==2){
		printf("[%d]:child: cpid==[%d]\n", i, getpid());
		//sleep(3);                                         //第一时间回收
	}

	//父进程
	if(i==3){
		printf("[%d]:father: fpid==[%d]\n", i, getpid());

		//注册 SICCHLD 信号处理函数
		struct sigaction act;
		act.sa_handler = waitchild;
		sigemptyset(&act.sa_mask);  //将某个信号集清0。阻塞的信号。在信号处理函数执行期间, 不阻塞任何信号	
		act.sa_flags = 0;
		
		/*
		* 模拟3个子进程都成为“僵尸进程”
		* 睡眠5秒，3个子进程都死了，还没来得急注册。
		*/
		//1、sleep(5)期间,3个子进程全部退出了，这个时候 SIGCHLD信号 会保留在“未决信号集”中。
		sleep(5); 
		sigaction(SIGCHLD, &act, NULL);
		
		//完成 SIGCHLD信号 的注册后，解除对 SIGCHLD信号 的阻塞
		//2、SIGCHLD 解决阻塞之后，SIGCHLD就会被处理，接下来就会调用 waitchild 信号处理函数。
		// waitchild函数 只会被调用一次。
		sigprocmask(SIG_UNBLOCK, &mask, NULL); 
		
		while(1){
			sleep(1);
		}
	}	
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make sigchld6
cc     sigchld6.c   -o sigchld6
aaron@aaron-virtual-machine:~/桌面/test$ ./sigchld6
father process, pid==[20504], child pid==[20505]
child process, father pid==[20504], pid==[20505]
[0]:child: cpid==[20505]
father process, pid==[20504], child pid==[20506]
father process, pid==[20504], child pid==[20507]
child process, father pid==[20504], pid==[20506]
[1]:child: cpid==[20506]
[3]:father: fpid==[20504]
child process, father pid==[20504], pid==[20507]
[2]:child: cpid==[20507]
child is quit, wpid==[20505]   //3个子进程全部回收
child is quit, wpid==[20506]
child is quit, wpid==[20507]
no child is living, wpid==[-1]
*/