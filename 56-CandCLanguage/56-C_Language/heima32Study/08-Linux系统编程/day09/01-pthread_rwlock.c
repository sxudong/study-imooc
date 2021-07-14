//读写锁测试程序
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

int number = 0;

//定义一把读写锁
pthread_rwlock_t rwlock;

//“写线程”回调函数
void *thread_write(void *arg)
{
	int i = *(int *)arg;

	int cur;

	while(1){
		//加写锁
		pthread_rwlock_wrlock(&rwlock);

		cur = number;
		cur++;
		number = cur;	
		printf("[%d]-W:[%d]\n", i, cur);

		//解锁
		pthread_rwlock_unlock(&rwlock);
		sleep(rand()%3);
	}
}

//“读线程”回调函数
void *thread_read(void *arg)
{
	int i = *(int *)arg;
	int cur;

	while(1){
		//加读锁
		pthread_rwlock_rdlock(&rwlock);

		cur = number;
		printf("[%d]-R:[%d]\n", i, cur);

		//解锁
		pthread_rwlock_unlock(&rwlock);
		sleep(rand()%3);
	}	
}

int main()
{
	int n = 8;
	int i = 0;
	int arr[8];
	pthread_t thread[8];

	//读写锁初始化
	pthread_rwlock_init(&rwlock, NULL);

	//创建3个“写”子线程
	for(i=0; i<3; i++){
		arr[i] = i;
		pthread_create(&thread[i], NULL, thread_write, &arr[i]);
	}

	//创建5个“读”子线程
	for(i=3; i<n; i++){
		arr[i] = i;
		pthread_create(&thread[i], NULL, thread_read, &arr[i]);
	}

	//回收子线程
	int j = 0;
	for(j=0; j<n; j++)
		pthread_join(thread[j], NULL);

	//释放锁
	pthread_rwlock_destroy(&rwlock);

	return 0;
}
/*
aaron@aaron-virtual-machine:~$ gcc -o pthread_rwlock 01-pthread_rwlock.c -lpthread
aaron@aaron-virtual-machine:~$ ./pthread_rwlock 
[0]-W:[1]  //写加1
[1]-W:[2]  //写加1
[2]-W:[3]  //写加1
[3]-R:[3]  //读
[6]-R:[3]  //读
[5]-R:[3]  //读
[4]-R:[3]  //读
[7]-R:[3]  //读
...
*/