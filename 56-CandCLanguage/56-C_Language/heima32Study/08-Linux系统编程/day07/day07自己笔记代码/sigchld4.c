//父进程使用 SICCHLD 信号完成对子进程的回收(代码与课堂一致)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

/*
* 模拟产生一个“僵尸进程”
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
	
	/*
	* 模拟产生一个“僵尸进程”，父进程信号处理函数执行时间太长，第二个子进程已死，没有来得急回收。
	*/
	sleep(2); 
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
		
		sigaction(SIGCHLD, &act, NULL);
		while(1){
			sleep(1);
		}
	}	
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make sigchld4
cc     sigchld4.c   -o sigchld4
aaron@aaron-virtual-machine:~/桌面/test$ ./sigchld4
father process, pid==[20145], child pid==[20146]
father process, pid==[20145], child pid==[20147]
child process, father pid==[20145], pid==[20146]
[0]:child: cpid==[20146]
father process, pid==[20145], child pid==[20148]
[3]:father: fpid==[20145]
child process, father pid==[20145], pid==[20147]
[1]:child: cpid==[20147]
child process, father pid==[20145], pid==[20148]
[2]:child: cpid==[20148]
child is quit, wpid==[20148]          //回收一个子进程
child is quit, wpid==[20146]          //回收一个子进程

aaron@aaron-virtual-machine:~$ ps -ef
UID         PID   PPID  C STIME TTY          TIME CMD
root          1      0  0 6月17 ?       00:00:07 /sbin/init splash
root      20126      2  0 15:25 ?        00:00:00 [kworker/0:0-cgr]
aaron     20145  18967  0 15:28 pts/0    00:00:00 ./sigchld4
aaron     20147  20145  0 15:28 pts/0    00:00:00 [sigchld4] <defunct>     //产生一个 <defunct>僵尸进程
aaron     20149  18734  0 15:28 pts/2    00:00:00 ps -ef
aaron@aaron-virtual-machine:~$ 

*/