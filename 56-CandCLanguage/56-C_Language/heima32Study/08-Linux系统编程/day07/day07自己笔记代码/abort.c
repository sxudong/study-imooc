//abort函数测试
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>


int main()
{
	//给当前进程发送SIGINT信号
	abort();
	
	printf("hello world\n");
	return 0;
}

/* 没产生core文件
aaron@aaron-virtual-machine:~/桌面/test$ make abort
cc     abort.c   -o abort
aaron@aaron-virtual-machine:~/桌面/test$ ./abort 
已放弃 (核心已转储)
*/