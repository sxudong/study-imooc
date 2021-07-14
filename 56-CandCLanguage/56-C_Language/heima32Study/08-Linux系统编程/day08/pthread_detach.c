//设置子线程为分离属性
/*
线程分离状态：
指定该状态，线程主动与主控线程断开关系。线程结束后，
其退出状态不由其他线程获取，而直接自己自动释放。
网络、多线程服务器常用。

进程若有该机制，将不会产生僵尸进程。僵尸进程的产生
主要由于进程死后，大部分资源被释放，一点残留资源仍
存于系统中，导致内核认为该进程仍存在。
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

//线程执行函数
void *mythread(void *arg)
{
	printf("child thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());
	sleep(10);
}

int main()
{
	//int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
    //                      void *(*start_routine) (void *), void *arg);
	//创建子线程
	pthread_t thread;
	int ret = pthread_create(&thread, NULL, mythread, NULL);
	if(ret!=0){
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}
	printf("main thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());

	//设置线程为分离属性
	pthread_detach(thread);

	//子线程设置分离属性,则pthread_join不再阻塞,立刻返回
	ret = pthread_join(thread, NULL);
	if(ret!=0){
		printf("pthread_join error:[%s]\n", strerror(ret));
	}

	//目的是为了让子线程能够执行起来
	sleep(1);
	return 0;
}

/*
aaron@aaron-virtual-machine:~$ gcc -o pthread_detach pthread_detach.c -lpthread
aaron@aaron-virtual-machine:~$ ./pthread_detach 
main thread, pid==[5066], id==[140499341965120]
pthread_join error:[Invalid argument]               //子线程已经被回收了，所以这里报错
child thread, pid==[5066], id==[140499333449472]
*/