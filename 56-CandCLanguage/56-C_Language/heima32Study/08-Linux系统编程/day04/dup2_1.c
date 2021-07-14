//使用dup2函数实现标准输出“重定向操作”
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	//打开文件
	int fd = open(argv[1], O_RDWR | O_CREAT, 0777);
	if(fd<0)
	{
		perror("open error");
		return -1;
	}

 	//调用dup2函数实现文件重定向操作
	dup2(fd, STDOUT_FILENO);
		
	//printf("ni hao hello world");
	write(STDOUT_FILENO, "ni hao hello world", strlen("ni hao hello world")); //跟printf是一样的
	
	close(fd);
	close(STDOUT_FILENO);

	return 0;
}
