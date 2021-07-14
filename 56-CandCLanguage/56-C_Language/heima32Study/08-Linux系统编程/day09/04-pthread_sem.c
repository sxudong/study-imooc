/*
* 使用信号量实现“生产者”和“消费者”模型
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

typedef struct node
{
	int data;
	struct node *next;
}NODE;

NODE *head = NULL;

//定义信号量
sem_t sem_producer;
sem_t sem_consumer;

//“生产者”线程
void *producer(void *arg)
{
	NODE *pNode = NULL;
	while(1){
		//生产一个节点
		pNode = (NODE *)malloc(sizeof(NODE));
		if(pNode==NULL){
			perror("malloc error");
			exit(-1);
		}
		pNode->data = rand()%1000;
		printf("P:[%d]\n", pNode->data);

		//加锁
		sem_wait(&sem_producer); //-- 等于0阻塞

		pNode->next = head;
		head = pNode;

		//解锁
		sem_post(&sem_consumer); //相当于++

		sleep(rand()%3);
	}
}


//“消费者”线程
void *consumer(void *arg)
{
	NODE *pNode = NULL;
	while(1){
		//加锁
		sem_wait(&sem_consumer); //相当于-- 等于0阻塞
		
		printf("C:[%d]\n", head->data);	
		pNode = head;
		head = head->next;

		//解锁
		sem_post(&sem_producer); //相当于++

		free(pNode);
		pNode = NULL;

		sleep(rand()%3);
	}
}

int main()
{
	int ret;
	pthread_t thread1;
	pthread_t thread2;

	//初始化信号量
	sem_init(&sem_producer, 0, 5); //第二个参数：0表示线程同步, 第三个参数：5个线程可以操作数据，可以连续生产5个
	sem_init(&sem_consumer, 0, 0); //消费者一开始是堵塞的，所以这里第三个参数是0

	//创建“生产者线程”
	ret = pthread_create(&thread1, NULL, producer, NULL);
	if(ret!=0){
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}

	//创建“消费者线程”
	ret = pthread_create(&thread2, NULL, consumer, NULL);
	if(ret!=0){
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}

	//等待线程结束
	pthread_join(thread1, NULL);
	pthread_join(thread2, NULL);

	//释放信号量资源
	sem_destroy(&sem_producer);
	sem_destroy(&sem_consumer);

	return 0;
}

/* 
@aaron-virtual-machine:~$ gcc -o 04-pthread_sem 04-pthread_sem.c -lpthread
@aaron-virtual-machine:~$ ./04-pthread_sem 
P:[383]
C:[383]
P:[915]
C:[915]
P:[386]
C:[386]
P:[421]
C:[421]
P:[690]
C:[690]
P:[926]  
P:[426]  //连续生产2个
......
*/