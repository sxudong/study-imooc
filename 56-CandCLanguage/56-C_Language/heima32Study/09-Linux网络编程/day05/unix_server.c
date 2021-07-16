//本地socket通信服务端
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/un.h>
#include <ctype.h>

int main()
{
	//创建socket
	int lfd = socket(AF_UNIX, SOCK_STREAM, 0); //本地socket通信
	if(lfd<0)
	{
		perror("socket error");
		return -1;
	}

	//删除socket文件,避免bind失败
	unlink("./server.sock");

	//绑定bind
	struct sockaddr_un serv;
	bzero(&serv, sizeof(serv));
	serv.sun_family = AF_UNIX;
	strcpy(serv.sun_path, "./server.sock"); 
	int ret = bind(lfd, (struct sockaddr *)&serv, sizeof(serv)); //绑定
	if(ret<0)
	{
		perror("bind error");
		return -1;
	}

	//监听listen
	listen(lfd, 10);

	//接收新的客户端连接-accept
	struct sockaddr_un client;
	bzero(&client, sizeof(client));
	//int len = sizeof(client);
	socklen_t len = sizeof(client);
	int cfd = accept(lfd, (struct sockaddr *)&client, &len);
	if(cfd<0)
	{
		perror("accept error");	
		return -1;
	}
	printf("client->[%s]\n", client.sun_path);

	int i;
	int n;
	char buf[1024];

	while(1)
	{
		//读数据
		memset(buf, 0x00, sizeof(buf));		
		n = read(cfd, buf, sizeof(buf));
		if(n<=0)
		{
			//perror("read error or client close");
			printf("read error or client close, n==[%d]\n", n);
			break;
		}
		for(i=0; i<n; i++){
			buf[i] = toupper(buf[i]); //转成大写
		}
		printf("n==[%d], buf==[%s]\n", n, buf);

		//发送数据
		write(cfd, buf, n);
	}

	close(lfd);

	return 0;
}
/* 测试服务端：
aaron@aaron-virtual-machine:~/桌面/test$ make unix_server
cc     unix_server.c   -o unix_server
aaron@aaron-virtual-machine:~/桌面/test$ ./unix_server 
client->[]
n==[6], buf==[HELLO
]
n==[6], buf==[AAAAA
]
read error or client close, n==[0]  //连接退出

aaron@aaron-virtual-machine:~/桌面/test$ nc -U server.sock
hello
HELLO
aaaaa
AAAAA
^C       //退出

aaron@aaron-virtual-machine:~$ netstat -anp | grep server
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
unix  2      [ ACC ]     流        LISTENING     77626    3158/./unix_server   ./server.sock
unix  3      [ ]         流        已连接     77627    3158/./unix_server   ./server.sock

*/

