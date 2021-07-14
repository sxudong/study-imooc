//父进程调用waitpid函数完成对子进程的回收
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

/*
waitpid函数：
pid_t waitpid(pid_t pid, int *status, int options);
    参数:
        pid:
            >0: 表示等待指定的子进程
            =-1: 表示等待任意子进程
        status:
            同wait函数
        options:
            0：表示阻塞
            WNOHANG：表示不阻塞
    返回值：
        >0：回收的子进程的PID
        =0：若options取值为WNOHANG，则表示子进程还活者
        =-1：表示已经没有子进程了

    注意：调用一次waitpid或者wait函数只能回收一个子进程。
*/	


int main()
{
	//创建子进程
	pid_t pid = fork();
	if(pid<0){ //fork失败的情况
		perror("fork error");
		return -1;
	}
	else if(pid > 0){ //父进程
		printf("father: [%d], pid==[%d], fpid==[%d]\n", pid, getpid(),getppid());
		int status;
		
		//调用waitpid()函数
		//pid_t wpid = waitpid(pid,&status,0);       //指定的子进程
		while(1){
			pid_t wpid = waitpid(-1,&status,WNOHANG);    //-1 表示等待任意子进程, WNOHANG 表示不阻塞
			//printf("wpid==[%d]\n", wpid);
			
			if(wpid > 0){ //大于0，代表回收了子进程
				//正常退出
				if(WIFEXITED(status)){ 
					printf("child normal exit, status==[%d]\n", WEXITSTATUS(status));
				}
				//被信号杀死
				else if(WIFSIGNALED(status)){ 
					printf("child killed by signal, signo==[%d]\n", WTERMSIG(status)); //使用kill杀死返回
				}
			}
			//子进程还活着
			else if(wpid == 0){ 
				//printf("child is living,wpid==[%d]\n", wpid);
			}
			//没有子进程了
			else if(wpid == -1){
				printf("no child is living, wpid==[%d]\n",wpid);
				break;
			}			
		}
		//sleep(10);
	}
	else if(pid==0){ //子进程
		printf("child: pid==[%d], fpid==[%d]\n", getpid(), getppid());
		sleep(2); //睡眠20秒返回
		return 9;  //返回9，在父进程中“正常状态”应该打印一个“9”。用kill -15 PID,会打印15
	}
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make waitpid
cc     waitpid.c   -o waitpid
aaron@aaron-virtual-machine:~/桌面/test$ ./waitpid 
father: [88275], pid==[88274], fpid==[87839]
child: pid==[88275], fpid==[88274]
child normal exit, status==[9]
no child is living, wpid==[-1]
*/			