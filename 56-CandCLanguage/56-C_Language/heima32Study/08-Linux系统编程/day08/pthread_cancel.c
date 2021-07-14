//创建子线程
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

//线程执行函数
void *mythread(void *arg)
{
	while(1){
		int a;
		int b;

		/*
		* 设置“取消点”退出
		*/
		pthread_testcancel();

		//取消点：是线程检查是否被取消，并按请求进行动作的一个位置。
		//通常是一些系统调用creat，open，pause，close，read，write，printf...都有取消点
		//printf("-----\n");
	}
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

	/*
	* 取消子线程
	*/
	pthread_cancel(thread); //主要目的是退出

	pthread_join(thread, NULL);
	return 0;
}
/*
aaron@aaron-virtual-machine:~$ gcc -o pthread_cancel pthread_cancel.c -lpthread
aaron@aaron-virtual-machine:~$ ./pthread_cancel 
main thread, pid==[5138], id==[139729789454144]
*/