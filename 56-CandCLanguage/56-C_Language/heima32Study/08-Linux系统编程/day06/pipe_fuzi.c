//使用pipe完成ps aux | grep bash操作
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
	//创建管道
	//int pipe(int pipefd[2]);
	int fd[2];
	int ret = pipe(fd);
	if(ret<0){
		perror("pipe error");
		return -1;
	}

	//创建子进程
	pid_t pid = fork();
	if(pid < 0) {
		perror("fork error");
		return -1;
	}
	else if(pid > 0){ //父进程
		//关闭读端
		close(fd[0]);

		//将标准输出重定向到管道的写端
		dup2(fd[1], STDOUT_FILENO);
		
		execlp("ps", "ps", "aux", NULL); //执行ps命令

		perror("execlp error");
	}
	else { //子进程
		//关闭写端
		close(fd[1]);
	
		//将标准输入重定向到管道的读端
		dup2(fd[0], STDIN_FILENO);

		execlp("grep", "grep", "--color=auto", "bash", NULL); //执行grep命令

		perror("execlp error");
	}
	return 0;
}

/*
//系统的管道命令
aaron@aaron-virtual-machine:~/桌面/test$ ps aux | grep bash
aaron      3273  0.0  0.2  29808  4956 pts/0    Ss   23:06   0:00 bash
aaron      3292  0.0  0.0  21540  1060 pts/0    R+   23:07   0:00 grep --color=auto bash

//自定义实现的“管道命令”
aaron@aaron-virtual-machine:~/桌面/test$ make pipe_fuzi
cc     pipe_fuzi.c   -o pipe_fuzi
aaron@aaron-virtual-machine:~/桌面/test$ ./pipe_fuzi
aaron      3273  0.1  0.2  29808  4956 pts/0    Ss   23:06   0:00 bash
aaron      3290  0.0  0.0  21540  1148 pts/0    S+   23:06   0:00 grep --color=auto bash
*/