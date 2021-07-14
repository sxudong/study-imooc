//5 内存映射区
//使用mmap函数完成父子进程间通信
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>

/*
共享映射区：
void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);

参数：
	addr：一般传NULL,表示让内核去指定一个内存起始地址       
	length：文件大小;lseek或者stat函数
	prot：PROT_ _READ PROT_ WRITE PROT_ READ| PROT_ WRITE       
	flags：
		MAP_ SHARED：对映射区的修改会反映到文件中(可以对文件进行修改)              
		MAP_ PRIVATE：对映射区的修改不会对“文件”产生影响。
	fd：打开的文件描述符             
		fd = open();
	offset：从文件的哪个位置开始映射，一般传0

返回值：
	映射区的首地址
*/
	   
int main()
{     
	int fd = open("./test.log", O_RDWR);
	if(fd < 0){
		perror("open error");
		return -1;
	}

	int len = lseek(fd, 0, SEEK_END); //移动指针至0

	/*
	* 使用“mmap函数”建立共享映射区
	* 方法：void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset); 
	*/
	
	//MAP_ PRIVATE：对映射区的修改不会对“文件”产生影响,不会写入到文件中，所以尽可能的使用MAP_SHARED
	//void * addr = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0); 
	void * addr = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	
	if(addr == MAP_FAILED){ //如果失败
		perror("mmap error");
		return -1;
	}
	
	//mmap映射完成之后, 文件描述符关闭，对mmap映射有没有影响？没有影响。
	//close(fd); 

	//创建子进程
	pid_t pid = fork();
	if(pid < 0){
		perror("fork error");
		return -1;
	}
	else if(pid > 0){  //父进程
		memcpy(addr, "hello world", strlen("hello world"));	
		wait(NULL); //阻塞函数，保证子进程先退出，父进程后退出
	}
	else if(pid == 0){ //子进程
		sleep(1);
		char *p = (char *)addr;
		printf("[%s]", p);
	}

	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make mmap1
cc     mmap1.c   -o mmap1
]aaron@aaron-virtual-machine:~/桌面/test$ ./mmap1
[hello worldssssssssss
*/