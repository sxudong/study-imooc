//5 内存映射区
//使用“mmap函数”完成两个不相干进程间通信
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>

int main()
{
	int fd = open("./test.log", O_RDWR);
	if(fd<0){
		perror("open error");
		return -1;
	}

	int len = lseek(fd, 0, SEEK_END); //移动指针至0

	//使用“mmap函数”建立共享映射区
	void * addr = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if(addr == MAP_FAILED){ //如果失败
		perror("mmap error");
		return -1;
	}

	char buf[64];
	memset(buf, 0x00, sizeof(buf)); //重置清零
	memcpy(buf, addr, 10);          //内存拷贝
	printf("buf=[%s]\n", buf);

	return 0;
}
