//父进程调用wait函数完成对子进程的回收
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
		//调用wait()函数
		pid_t wpid = wait(&status); 
		printf("wpid==[%d]\n", wpid);
		
		//正常退出
		if(WIFEXITED(status)){ 
			printf("child normal exit, status==[%d]\n", WEXITSTATUS(status));
		}
		//被信号杀死
		else if(WIFSIGNALED(status)){ 
			printf("child killed by signal, signo==[%d]\n", WTERMSIG(status)); //使用kill杀死返回
		}
	}
	else if(pid==0){ //子进程
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
		sleep(20); //睡眠20秒返回
		return 9;  //返回9，在父进程中“正常状态”应该打印一个“9”。用kill -15 PID,会打印15
	}
	return 0;
}

/*
wait函数:
	pid_t wait(int *status);
	返回值:
		>0: 回收的子进程的PID
		-1: 没有子进程
	参数:
		status: 子进程的退出状态
			if(WIFEXITED(status))
			{
				WEXITSTATUS(status)
			}
			else if(WIFSIGNALED(status))
			{
				WTERMSIG(status)
			}
*/			