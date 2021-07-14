//信号集相关函数测试
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

//信号处理函数
void sighandler(int signo)
{
	printf("signo==[%d]\n", signo);
}

int main()
{

	//注册 SIGINT 和 SIGQUIT 的信号处理函数
	signal(SIGINT, sighandler);
	signal(SIGQUIT, sighandler);

	//定义信号集变量
	sigset_t set;

	//初始化信号集
	sigemptyset(&set);

	//将 SIGINT 和 SIGQUIT 加入到阻塞信号集中
	//SIGINT信号: 程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl+C)时发出,用于通知前台进程组终止进程。
	//SIGQUIT信号: 和SIGINT类似, 但由QUIT字符(通常是Ctrl+\)来控制. 进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号。
	sigaddset(&set, SIGINT);
	sigaddset(&set, SIGQUIT);

	//将set中的 SIGINT 和 SIGQUIT 信号加入到“阻塞信号集”中
	sigprocmask(SIG_BLOCK, &set, NULL);
	
	sigset_t pend;
	int i = 1;
	int j = 1;
	while(1){
		//初始化信号集
		sigemptyset(&pend);
		//获取“未决”信号集
		sigpending(&pend);	

		for(i=1; i<32; i++){
			//判断某个信号是否在集合中
			if(sigismember(&pend, i)==1){
				printf("1");
			}
			else{
				printf("0");	
			}
		}
		printf("\n");

		//循环10次解除对 SIGINT SIGQUIT 信号的阻塞
		if(j++%10 == 0){
			//从阻塞信号集中解除对 SIGINT 和 SIGQUIT 的阻塞
			sigprocmask(SIG_UNBLOCK, &set, NULL);		
		}
		else{
			//继续保持阻塞
			sigprocmask(SIG_BLOCK, &set, NULL);	
		}
		sleep(1);
	}
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make sigset1
cc     sigset1.c   -o sigset1
aaron@aaron-virtual-machine:~/桌面/test$ ./sigset1 
0000000000000000000000000000000
0000000000000000000000000000000
^C^C^C0100000000000000000000000000000
^\^\^\0110000000000000000000000000000
0110000000000000000000000000000
0110000000000000000000000000000
0110000000000000000000000000000
0110000000000000000000000000000
0110000000000000000000000000000
0110000000000000000000000000000
signo==[3]
signo==[2]
0000000000000000000000000000000
*/