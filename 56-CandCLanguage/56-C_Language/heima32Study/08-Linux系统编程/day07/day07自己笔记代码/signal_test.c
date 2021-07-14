//signal函数测试：测试给没有“读端”的管道写数据，会产生SIGPIPE信号
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>

//信号处理函数
void sighandler(int signo)
{
	printf("signo==[%d]\n", signo);
}

int main()
{
	//创建管道
	//方法：int pipe(int pipefd[2]);
	int fd[2];
	int ret = pipe(fd);
	if(ret<0){
		perror("pipe error");
		return -1;
	}

	//注册 SIGPIPE 信号处理函数，给内核注册一个函数
	signal(SIGPIPE, sighandler); 
	
	//关闭读端
	close(fd[0]);
	//往一个没有读端的管道写数据，内核检测到这个错误，立即产生一个信号，
	//产生的信号是“SIGPIPE信号”，而且上一行也代码也注册了这个信号。内核
	//就知道执行哪一个函数，这个函数是上一行注册的“sighandler”函数。
	write(fd[1], "hello world", strlen("hello world"));	
	
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make pipe_test
cc     pipe_test.c   -o pipe_test
aaron@aaron-virtual-machine:~/桌面/test$ ./pipe_test 
signo==[13]
*/