//kill函数测试
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

int main()
{
	kill(getpid(), SIGKILL);
	printf("hello world\n");
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make kill_1
cc     kill_1.c   -o kill_1
aaron@aaron-virtual-machine:~/桌面/test$ ./kill_1
已杀死
*/