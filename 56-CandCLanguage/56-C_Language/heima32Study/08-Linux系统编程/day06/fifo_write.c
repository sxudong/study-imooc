//4 fifo完成两个进程间通信的测试
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>

/*
fifo完成两个进程间通信的思路：
进程A：
      1 创建一个fifo文件: mkfifo命 令或者使用mkfifo函数
      2 open fifo文件，获得一个文件描述符fd
      3 写fifo文件----write(fd,"xxx",...)
      4 关闭fifo文件---close(fd);

进程B：
      1 打开fifo文件，获得文件描述符fd 
      2 读fifo文件---read(fd,buf,sizeof(buf));
      3 关闭fifo文件---close(fd);
*/

int main()
{
	//创建fifo文件
	//方法：int mkfifo(const char *pathname, mode_t mode);
	//判断myfofo文件是否存在,若不存在则创建
	int ret = access("./myfifo", F_OK);
	if(ret != 0){		
		ret = mkfifo("./myfifo", 0777);
		if(ret<0){
			perror("mkfifo error");
			return -1;
		}
	}

	//打开文件
	int fd = open("./myfifo", O_RDWR);
	if(fd < 0){
		perror("open error");
		return -1;
	}

	//写fifo文件
	int i = 0; //标号
	char buf[64];
	while(1){ //循环写
		memset(buf, 0x00, sizeof(buf));
		sprintf(buf, "%d:%s", i, "hello world"); 
		write(fd, buf, strlen(buf));
		sleep(1);

		//读到进程B写的东西
		//memset(buf,0x00,sizeof(buf));
		//read(fd,buf,sizeof(buf));  
		//printf("%s",buf);
		i++;
	}
	//关闭文件
	close(fd);
	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ ./fifo_write

*/