//fork函数测试
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int g_var = 99;

int main()
{
	//创建子进程
	pid_t pid = fork();
	if(pid<0) //fork失败的情况
	{
		perror("fork error");
		return -1;
	}
	else if(pid>0)//父进程
	{
		printf("father: [%d], pid==[%d], fpid==[%d]\n", pid, getpid(),getppid());
		//自增加
		g_var++;
		printf("父进程 [%p]", &g_var);
		printf("father: g_var==[%d]\n", g_var);
	}
	else if(pid==0) //子进程
	{
		//为了避免父进程还没有执行, 子进程已经结束了
		sleep(1); 
		//打印“全局变量”虚拟内存地址
		printf("子进程 [%p]", &g_var);
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
		printf("child: g_var==[%d]\n", g_var);
	}
	
	return 0;
}
/* 结论：写时复制，读时共享。
 父子进程不能共享全局变量；
 但是如果父子进程只是对全局变量做读操作，则父子进程在内存中有一份，属于共享。
 但是如果父子进程中的任何一个进程对该变量做修改操作，会在内存中拷贝一个副本，然后在这个副本上进行修改，修改完成以后映射回去。
*/