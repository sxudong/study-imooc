//线程退出函数测试
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

struct Test
{
	int data;
	char name[64];
};
int g_var = 9;
struct Test t;

//线程执行函数
void *mythread(void *arg)
{
	printf("child thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());
	pthread_exit(NULL); //线程退出
}

int main()
{
	//int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
    //                      void *(*start_routine) (void *), void *arg);
	//创建子线程
	pthread_t thread;
	//第一个参数 是线程号;
	//第二个参数 线程默认属性;
	//第三个参数 函数指针，指向线程主函数;
	//第四个参数 线程主函数执行期间所使用的参数。
	int ret = pthread_create(&thread, NULL, mythread, NULL);
	if(ret!=0){
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}
	printf("main thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());

	sleep(100);
	return 0;
}
/*
aaron@aaron-virtual-machine:~/桌面/test$ ./pthread_exit 
child thread, pid==[4947], id==[140629699438336]
main thread, pid==[4947], id==[140629707953984]

*/
/*
aaron@aaron-virtual-machine:~$ ps -ef
aaron      4911   2446  0 20:34 pts/2    00:00:00 bash
root       4921      2  0 20:34 ?        00:00:00 [kworker/u256:1-]
aaron      4947   4367  0 20:36 pts/1    00:00:00 ./pthread_exit        //主线程还活着
aaron      4949   4911  0 20:36 pts/2    00:00:00 ps -ef
*/