//udp客户端
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ctype.h>

int main()
{
	//创建socket
	int cfd = socket(AF_INET, SOCK_DGRAM, 0);
	if(cfd<0)
	{
		perror("socket error");
		return -1;
	}

	int n;
	char buf[1024];
	struct sockaddr_in serv;
	serv.sin_family = AF_INET;
	serv.sin_port = htons(8888);
	inet_pton(AF_INET, "127.0.0.1", &serv.sin_addr.s_addr);

	while(1)
	{
		//读标准输入数据
		memset(buf, 0x00, sizeof(buf));
		n = read(STDIN_FILENO, buf, sizeof(buf));

		//发送数据
		sendto(cfd, buf, n, 0, (struct sockaddr *)&serv, sizeof(serv));

		//读取数据
		memset(buf, 0x00, sizeof(buf));
		n = recvfrom(cfd, buf, sizeof(buf), 0, NULL, NULL);
		printf("n==[%d], buf==[%s]\n", n, buf);
	}

	//关闭套接字
	close(cfd);

	return 0;
}
/* 连接服务端测试：
aaron@aaron-virtual-machine:~/桌面/test$ ./server 
[48948]:n==[6], buf==[HELLO
]
[47682]:n==[5], buf==[NICE
]

aaron@aaron-virtual-machine:~$ gcc -o client 02-udp_client.c wrap.c
aaron@aaron-virtual-machine:~$ ./client 
hello
n==[6], buf==[HELLO
]

aaron@aaron-virtual-machine:~$ ./client 
nice
n==[5], buf==[NICE
]

aaron@aaron-virtual-machine:~$ netstat -anp | grep 8888
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
udp        0      0 0.0.0.0:8888            0.0.0.0:*                           2937/./server       
aaron@aaron-virtual-machine:~$ netstat -anp | grep server
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
udp        0      0 0.0.0.0:8888            0.0.0.0:*                           2937/./server       
aaron@aaron-virtual-machine:~$ netstat -anp | grep client
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
udp        0      0 0.0.0.0:48948           0.0.0.0:*                           3004/./client       
udp        0      0 0.0.0.0:47682           0.0.0.0:*                           3030/./client   
*/