//循环创建子线程,并且打印是第几个子线程
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

//线程执行函数
void *mythread(void *arg)
{
	int i = *(int *)arg;
	//将参数打印出来
	printf("[%d]:child thread, pid==[%d], id==[%ld]\n", i, getpid(), pthread_self());
	sleep(100);
}

int main()
{
	//int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
	//                      void *(*start_routine) (void *), void *arg);
	//创建子线程
	int ret;
	int i = 0;
	int n = 5;
	int arr[5]; //定义一个数组让每个线程去访问一个内存空间
	pthread_t thread[5];
	for(i=0; i<n; i++){
		arr[i] = i;
		//都打印5
		//ret = pthread_create(&thread[i], NULL, mythread, NULL); 
		
		//第一个参数 是线程号;
		//第二个参数 线程默认属性;
		//第三个参数 函数指针，指向线程主函数;
		//第四个参数 线程主函数执行期间所使用的参数。
		ret = pthread_create(&thread[i], NULL, mythread, &arr[i]);
		if(ret != 0){
			printf("pthread_create error, [%s]\n", strerror(ret));
			return -1;
		}
	}
	printf("main thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());

	//目的是为了让子线程能够执行起来
	sleep(100);
	return 0;
}

/* Output:
aaron@aaron-virtual-machine:~$ gcc -o pthread_create_loop pthread_create_loop.c -lpthread
aaron@aaron-virtual-machine:~$ ./pthread_create_loop
[0]:child thread, pid==[4714], id==[140175849842432]
[1]:child thread, pid==[4714], id==[140175841449728]
[2]:child thread, pid==[4714], id==[140175833057024]
[3]:child thread, pid==[4714], id==[140175824664320]
[4]:child thread, pid==[4714], id==[140175816271616]
main thread, pid==[4714], id==[140175858358080]
*/