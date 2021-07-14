//僵尸进程
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
	//创建子进程
	pid_t pid = fork();
	if(pid < 0){ //fork失败的情况
		perror("fork error");
		return -1;
	}
	else if(pid > 0){ //父进程
		sleep(100);   //休睡200秒，让子进程先死
		printf("father: [%d], pid==[%d], fpid==[%d]\n", pid, getpid(),getppid());
	}
	else if(pid == 0){ //子进程
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
	}
	return 0;
}

/*
* 僵尸进程: 子进程先退出, 父进程没有完成对子进程的回收, 此时子进程就变成了僵尸进程。
* 如何解决僵尸进程:
*	不能使用kill -9杀死僵尸进程, 原因是僵尸进程是一个死掉的进程;
*	应该使用杀死僵尸进程父进程的方法来解决僵尸进程;
*	原因是: 杀死其父进程可以让init进程领养僵尸进程,最后由init进程回收僵尸进程。
*/	