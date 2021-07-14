//父进程调用waitpid函数完成对子进程的回收
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
	//创建子进程
	pid_t pid = fork();
	if(pid<0){ //fork失败的情况
		perror("fork error");
		return -1;
	}
	else if(pid > 0){ //父进程
		printf("father: [%d], pid==[%d], fpid==[%d]\n", pid, getpid(),getppid());
		int status;
		
		//调用waitpid()函数
		//pid_t wpid = waitpid(pid,&status,0);       //指定的子进程
		pid_t wpid = waitpid(-1,&status,WNOHANG);    //-1 表示等待任意子进程, WNOHANG 表示不阻塞
		printf("wpid==[%d]\n", wpid);
		
		if(wpid > 0){ //大于0，代表回收了子进程
			//正常退出
			if(WIFEXITED(status)){ 
				printf("child normal exit, status==[%d]\n", WEXITSTATUS(status));
			}
			//被信号杀死
			else if(WIFSIGNALED(status)){ 
				printf("child killed by signal, signo==[%d]\n", WTERMSIG(status)); //使用kill杀死返回
			}
		}
		sleep(20);
	}
	else if(pid==0){ //子进程
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
		sleep(2); //睡眠20秒返回
		return 9;  //返回9，在父进程中“正常状态”应该打印一个“9”。用kill -15 PID,会打印15
	}
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ ./waitpid3
father: [88105], pid==[88104], fpid==[87839]
wpid==[0]                                             //wpid=0,子进程还活着
child: pid==[88105], fpid==[88104]
*/			