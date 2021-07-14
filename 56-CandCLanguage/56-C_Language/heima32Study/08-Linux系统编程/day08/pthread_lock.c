//线程同步
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

#define NUM 20000
int number = 0;

//定义一把互斥锁
pthread_mutex_t mutex;

//线程执行函数
void *mythread1(void *arg)
{
	int i=0;
	int n;
	for(i=0; i<NUM; i++){
		//加锁
		pthread_mutex_lock(&mutex);
		n = number ;
		n++ ;
		number = n ;
		printf("2:[%d]\n", number);
		//解锁
		pthread_mutex_unlock(&mutex);
	}

}

void *mythread2(void *arg)
{
	int i=0;
	int n;
	for(i=0; i<NUM; i++){
		pthread_mutex_lock(&mutex);
		n = number ;
		n++ ;
		number = n ;
		printf("2:[%d]\n", number);
		//解锁
		pthread_mutex_unlock(&mutex);
	}
}

int main()
{
	//互斥锁初始化
	pthread_mutex_init(&mutex, NULL);
	//创建子线程
	pthread_t thread1;
	int ret = pthread_create(&thread1, NULL, mythread1, NULL);
	if(ret != 0)
	{
		printf("pthread_ create error, [%s]\n", strerror(ret));
		return -1;
	}
	pthread_t thread2;
	ret = pthread_create(&thread2, NULL, mythread2, NULL);
	if(ret != 0)
	{
		printf("pthread_ create error, [%s]\n", strerror(ret));
		return -1;
	}	
	
	pthread_join(thread1,NULL);
	pthread_join(thread2,NULL);
	
	//释放互斥锁
	pthread_mutex_destroy(&mutex);
	
	printf("number==[%d]\n", number);
	return 0;
}

/*
aaron@aaron-virtual-machine:~$ gcc -o lock pthread_lock.c -lpthread
aaron@aaron-virtual-machine:~$ ./lock 
......
2:[39997]
2:[39998]
2:[39999]
2:[40000]
number==[40000]
*/