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
	//printf("[%p]\n", &g_var);
	//pthread_exit(&g_var);
	memset(&t, 0x00, sizeof(t));
	t.data = 99;
	strcpy(t.name, "xiaowen");
	
	pthread_exit(&t); //线程退出
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
	if(ret!=0)
	{
		printf("pthread_create error, [%s]\n", strerror(ret));
		return -1;
	}
	printf("main thread, pid==[%d], id==[%ld]\n", getpid(), pthread_self());

	//回收“子线程”
	void *p = NULL;
	//&p 指向 *mythread()中的 子线程&t
	pthread_join(thread, &p); //阻塞等待线程退出，获取“线程退出状态”。其作用，对应进程中的waitpid() 函数。
	//int n = *(int *)p;
	struct Test *pt = (struct Test *)p;
	printf("child exit status:[%d],[%s],[%p]\n",  pt->data, pt->name, p); //打印退出的子线程名字和状态

	return 0;
}
/*
aaron@aaron-virtual-machine:~$ ./pthread_exit 
main thread, pid==[4989], id==[140155873388352]
child thread, pid==[4989], id==[140155864872704]
child exit status:[99],[xiaowen],[0x5563cafd1040]  //子线程退出
*/