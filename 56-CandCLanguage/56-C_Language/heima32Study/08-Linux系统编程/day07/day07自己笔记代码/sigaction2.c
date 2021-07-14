//sigaction函数测试：注册信号处理函数
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

/*
2 在xxx信号处理函数执行期间(前提是sa_ mask中阻塞了yyy信号)，
  若收到了yyy信号，则yyy信号会被阻塞。
  当xxx信号处理函数执行完毕后，则yyy信号只会被处理一次。
*/

//信号处理函数
void sighandler(int signo) //信号处理函数执行期间需要阻塞的信号
{
	printf("signo==[%d]\n", signo);
	sleep(5);
}

int main()
{
	//注册 SIGINT 信号处理函数
	struct sigaction act;
	act.sa_handler = sighandler; //信号处理函数
	sigemptyset(&act.sa_mask);   //阻塞的信号。在信号处理函数执行期间, 不阻塞任何信号
	
	//在信号处理函数执行期间阻塞 3号信号 SIGQUIT 信号
	sigaddset(&act.sa_mask, SIGQUIT);
	
	act.sa_flags = 0;
	sigaction(SIGINT, &act, NULL);
	
	signal(SIGQUIT, sighandler); //注册信号	

	while(1){
		sleep(1);
	}
	return 0;
}

/* 
aaron@aaron-virtual-machine:~/桌面/test$ kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
63) SIGRTMAX-1	64) SIGRTMAX	

aaron@aaron-virtual-machine:~/桌面/test$ make sigaction2
cc     sigaction2.c   -o sigaction2
aaron@aaron-virtual-machine:~/桌面/test$ ./sigaction2 
^Csigno==[2]
^\                    //2号信号执行期间，把3号信号阻塞了
*/