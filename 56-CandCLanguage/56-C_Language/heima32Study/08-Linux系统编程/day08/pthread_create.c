//创建子线程
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>  //unistd.h是Linux/Unix的系统调用
#include <pthread.h> //引用创建线程需要头函数

//线程执行函数
void *mythread(void *arg)
{
	//pthread_self()获取线程id
	printf("child thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());
}

//编译命令：gcc pthread_create.c -lpthread
int main()
{
	//int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
    //                      void *(*start_routine) (void *), void *arg);
	//创建子线程
	pthread_t thread; //线程ID
	//第一个参数 是线程号;
	//第二个参数 线程默认属性;
	//第三个参数 函数指针，指向线程主函数;
	//第四个参数 线程主函数执行期间所使用的参数。
	int ret = pthread_create(&thread, NULL, mythread, NULL);
	if(ret !=0 ) //不等于0，就失败了
	{
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}
	printf("main thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());

	//目的是为了让子线程能够执行起来
	sleep(1);
	return 0;
}

/* 它们的PID是一样的，主线程和子线程在同一个进程空间里面，它们的线程ID是不一样的。
aaron@aaron-virtual-machine:~$ gcc pthread_create.c -lpthread
aaron@aaron-virtual-machine:~$ ls
a.out  mydeamon  mydeamon.c  pthread_create.c
aaron@aaron-virtual-machine:~$ ./a.out
main thread, pid==[3507], id==[139650218678080]
child thread, pid==[3507], id==[139650210162432]
*/