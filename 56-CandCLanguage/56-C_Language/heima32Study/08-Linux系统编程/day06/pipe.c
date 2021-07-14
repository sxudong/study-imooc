//3 管道-pipe
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>


/*
pipe用于父子进程间通信：
      1 父进程创建pipe
      2 父进程调用fork函数创建子进程
      3 父进程关闭一端
      4 子进程关闭一端
      5 父进程和子进程分别执行read或者write操作
*/


int main()
{
	//创建管道
	//方法：int pipe(int pipefd[2]);
	int fd[2];
	int ret = pipe(fd);
	if(ret < 0){
		perror("pipe error");
		return -1;
	}

	//创建子进程
	pid_t pid = fork();
	if(pid < 0){
		perror("fork error");
		return -1;
	}
	//父进程
	else if(pid > 0){ 
		//关闭读端
		close(fd[0]);
		sleep(5); 
		//往管道里写东西
		write(fd[1], "hello world", strlen("hello world"));	 

		wait(NULL); //阻塞函数，保证子进程先退出，父进程后退出
	}
	//子进程
	else { 
		//关闭写端
		close(fd[1]);
		
		char buf[64];
		memset(buf, 0x00, sizeof(buf)); //初始化
		//从管理中读数据
		int n = read(fd[0], buf, sizeof(buf)); //阻塞，5秒后有数据立即返回
		printf("read over, n==[%d], buf==[%s]\n", n, buf);
	}
	return 0;
}
/*
aaron@aaron-virtual-machine:~/桌面/test$ make pipe
cc     pipe.c   -o pipe
aaron@aaron-virtual-machine:~/桌面/test$ ./pipe 
read over, n==[11], buf==[hello world]
*/
