//kill函数测试：父进程杀死子进程或者子进程杀死父进程
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
			sleep(1);
		}
		else if(pid==0){ //子进程
			printf("child process, father pid==[%d],pid==[%d]\n", getppid(), getpid());
			break;
		}
	}


	//第1个子进程
	if(i==0){
		printf("the first child,pid==[%d]\n", getpid());
		sleep(10);
	}

	//第2个子进程
	if(i==1){
		printf("the second child,pid==[%d]\n", getpid());	
		sleep(10);
	}

	//第3个子进程
	if(i==2){
		printf("the third child,pid==[%d]\n", getpid());
		sleep(10);
	}
	//父进程
	if(i==3){
		printf("the father,pid==[%d]\n", getpid());	
		sleep(10);
	}
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make kill1
cc     kill1.c   -o kill1
aaron@aaron-virtual-machine:~/桌面/test$ ./kill1 
father process, pid==[8645],child pid==[8646]
child process, father pid==[8645],pid==[8646]
the first child,pid==[8646]
father process, pid==[8645],child pid==[8650]
child process, father pid==[8645],pid==[8650]
the second child,pid==[8650]
father process, pid==[8645],child pid==[8654]
child process, father pid==[8645],pid==[8654]
the third child,pid==[8654]
the father,pid==[8645]

aaron@aaron-virtual-machine:~$ ps -ajx |grep kill1
  父ID  自己ID  组ID  会话ID
  PPID    PID   PGID    SID TTY       TPGID STAT   UID   TIME COMMAND
  2178   2186   2186   2186 pts/0      8353 Ss    1000   0:00 bash
     2   6505      0      0 ?            -1 I        0   0:05 [kworker/1:2-mpt]
   919   7775   7775    919 ?            -1 S        0   0:00 /sbin/dhclient -d -q -sf /usr/lib/Netwo
     2   8081      0      0 ?            -1 I        0   0:00 [kworker/u256:2-]
  2178   8124   8124   8124 pts/1      8124 Ss+   1000   0:00 bash
     2   8207      0      0 ?            -1 I        0   0:00 [kworker/u256:1-]
     2   8208      0      0 ?            -1 I        0   0:00 [kworker/0:0-eve]
     2   8249      0      0 ?            -1 I        0   0:00 [kworker/0:2-cgr]
     2   8279      0      0 ?            -1 I        0   0:00 [kworker/1:0]
  2178   8296   8296   8296 pts/2      8357 Ss    1000   0:00 bash
     2   8321      0      0 ?            -1 I        0   0:00 [kworker/u256:0-]
     2   8350      0      0 ?            -1 I        0   0:00 [kworker/0:1-cgr]
  2186   8353   8353   2186 pts/0      8353 S+    1000   0:00 ./kill1
  8353   8354   8353   2186 pts/0      8353 S+    1000   0:00 ./kill1
  8353   8355   8353   2186 pts/0      8353 S+    1000   0:00 ./kill1
  8353   8356   8353   2186 pts/0      8353 S+    1000   0:00 ./kill1
  8296   8357   8357   8296 pts/2      8357 R+    1000   0:00 ps -ajx

*/