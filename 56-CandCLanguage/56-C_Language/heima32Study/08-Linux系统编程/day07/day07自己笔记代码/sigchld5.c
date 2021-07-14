//父进程使用 SICCHLD 信号完成对子进程的回收(代码与课堂一致)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

/*
* 模拟3个子进程都成为“僵尸进程”
*
* defunct进程（僵尸进程）：
* 若子进程死了，父进程还活着，但是父进程没有调用wait或waitpid函数完成对子进程的回收，则该子进程就成了僵尸进程。
*/
void waitchild(int signo)
{
	pid_t wpid = waitpid(-1, NULL, WNOHANG);
	
	if(wpid>0){
		printf("child is quit, wpid==[%d]\n", wpid);
	}
	else if(wpid==0){
		printf("child is living, wpid==[%d]\n", wpid);
	}
	else if(wpid==-1){
		printf("no child is living, wpid==[%d]\n", wpid);
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
		sleep(5);
		
		sigaction(SIGCHLD, &act, NULL);
		while(1){
			sleep(1);
		}
	}	
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make sigchld5
cc     sigchld5.c   -o sigchld5
aaron@aaron-virtual-machine:~/桌面/test$ ./sigchld5
father process, pid==[20439], child pid==[20440]
child process, father pid==[20439], pid==[20440]
[0]:child: cpid==[20440]
father process, pid==[20439], child pid==[20441]
father process, pid==[20439], child pid==[20442]
[3]:father: fpid==[20439]
child process, father pid==[20439], pid==[20441]
[1]:child: cpid==[20441]
child process, father pid==[20439], pid==[20442]
[2]:child: cpid==[20442]

aaron@aaron-virtual-machine:~$ ps -ef
UID         PID   PPID  C STIME TTY          TIME CMD
aaron     20439  18967  0 16:20 pts/0    00:00:00 ./sigchld5
aaron     20440  20439  0 16:20 pts/0    00:00:00 [sigchld5] <defunct>  //3个子进程都成为<defunct>僵尸进程
aaron     20441  20439  0 16:20 pts/0    00:00:00 [sigchld5] <defunct>
aaron     20442  20439  0 16:20 pts/0    00:00:00 [sigchld5] <defunct>
aaron     20455  18734  0 16:21 pts/2    00:00:00 ps -ef

*/