//创建子线程: 传递参数
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

//线程执行函数
void *mythread(void *arg)
{
	//int n = *(int *)arg; //加*取地址
	//printf("n==[%d]\n", n);
	struct Test *p = (struct Test *)arg;
	//struct Test *p = arg;
	
	printf("[%d][%s]\n", p->data, p->name);
	printf("child thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());
}

int main()
{
	int n = 99;
	struct Test t;
	memset(&t, 0x00, sizeof(struct Test)); //设置为0，初始化
	t.data = 88; //设置线程id
	strcpy(t.name, "xiaowen"); //设置线程名字
	//int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
    //                      void *(*start_routine) (void *), void *arg);
	//创建子线程
	pthread_t thread;
	//int ret = pthread_create(&thread, NULL, mythread, &n);
	int ret = pthread_create(&thread, NULL, mythread, &t);
	if(ret!=0)
	{
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}
	printf("main thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());

	//目的是为了让子线程能够执行起来
	sleep(1);
	return 0;
}

/* Output:
aaron@aaron-virtual-machine:~/桌面/test$ gcc pthread_create1.c -lpthread
aaron@aaron-virtual-machine:~/桌面/test$ ./a.out 
main thread, pid==[4242], id==[139707977717568]
[88][xiaowen]
child thread, pid==[4242], id==[139707969201920]
*/