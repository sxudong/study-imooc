//fork函数测试
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

//ps -ef | grep init  1号进程
int main()
{
	printf("before fork, pid:[%d]\n", getpid());
	//创建子进程
	//pid_t fork(void);
	pid_t pid = fork(); //返回的是子进程ID
	if(pid < 0)         //fork失败的情况
	{
		perror("fork error");
		return -1;
	}
	else if(pid>0) //父进程
	{
		printf("father: [%d], pid==[%d], fpid==[%d]\n", pid, getpid(),getppid());
		//sleep(1); //如果父进程先执行完，子进程的父进程id就会变成1号进程
	}
	else if(pid==0) //子进程
	{
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
	}
	
	printf("after fork, pid:[%d]\n", getpid());

	return 0;
}
