//raise函数测试
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>


int main()
{
	//给当前进程发送SIGINT信号
	raise(SIGKILL);
	
	printf("hello world\n");
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make raise1
cc     raise1.c   -o raise1
aaron@aaron-virtual-machine:~/桌面/test$ ./raise1 
已杀死
*/