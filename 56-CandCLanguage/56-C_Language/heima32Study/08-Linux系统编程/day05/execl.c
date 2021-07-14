//fork函数测试
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

/*
* execl: 一般用于执行用户“自定义的应用程序”
* execp: 一般用于执行“系统命令”
*/
int main()
{
	//创建子进程
	pid_t pid = fork();
	if(pid<0) //fork失败的情况
	{
		perror("fork error");
		return -1;
	}
	else if(pid>0)  //父进程
	{
		printf("father: [%d], pid==[%d], fpid==[%d]\n", pid, getpid(),getppid());
		//sleep(1);
	}
	else if(pid==0) //子进程
	{
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
		
		//带路径 
		//execl("/bin/ls", "ls", "-l", NULL);                             //子进程执行“ls命令”
		//execl("./test", "test", "hello", "world", "ni", "hao", NULL);   //子进程执行自定义的可执行程序
		
		//不带路径
		//execlp("ls", "ls", "-l", NULL);
		execlp("./test", "test", "hello", "world", "ni", "hao", NULL);
		//execlp("./iitest", "test", "hello", "world", "ni", "hao", NULL); //测试 perror("execl error")
		
		perror("execl error"); //如果上面执行成功，这条代码不执行。
	}
	
	return 0;
}
