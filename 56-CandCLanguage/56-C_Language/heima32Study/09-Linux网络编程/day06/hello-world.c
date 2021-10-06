/*
  This exmple program provides a trivial server program that listens for TCP
  connections on port 9995.  When they arrive, it writes a short message to
  each client connection, and closes each connection once it is flushed.

  Where possible, it exits cleanly in response to a SIGINT (ctrl-c).
*/


#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <signal.h>
#ifndef WIN32
#include <netinet/in.h>
# ifdef _XOPEN_SOURCE_EXTENDED
#  include <arpa/inet.h>
# endif
#include <sys/socket.h>
#endif

#include <event2/bufferevent.h>
#include <event2/buffer.h>
#include <event2/listener.h>
#include <event2/util.h>
#include <event2/event.h>
#include <ctype.h>

static const char MESSAGE[] = "Hello, World!\n";

static const int PORT = 9995;

static void listener_cb(struct evconnlistener *, evutil_socket_t,
    struct sockaddr *, int socklen, void *);
static void conn_writecb(struct bufferevent *, void *);
static void conn_readcb(struct bufferevent *, void *);
static void conn_eventcb(struct bufferevent *, short, void *);
static void signal_cb(evutil_socket_t, short, void *);

int
main(int argc, char **argv)
{
	struct event_base *base;         //地基 定义了指向地基节点的指针
	struct evconnlistener *listener; //链接监听器 定义了链接监听器的指针
	struct event *signal_event;      //信号事件 定义了信号事件指针

	struct sockaddr_in sin; //IP地址
#ifdef WIN32
	WSADATA wsa_data;
	WSAStartup(0x0201, &wsa_data);
#endif

	//创建地基节点---相当于epoll的树根(epoll_create)
	base = event_base_new();
	if (!base) {
		fprintf(stderr, "Could not initialize libevent!\n");
		return 1;
	}

	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET; //IPv4
	sin.sin_port = htons(PORT);

	//创建链接监听器--socket bind  listen  accept
	//listener_cb: 回调函数
	//LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE: 设置端口复用, 当链接监听器释放的时候关闭套接字(监听文件描述符)
	listener = evconnlistener_new_bind(base, listener_cb, (void *)base,
	    LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE, -1,
	    (struct sockaddr*)&sin,
	    sizeof(sin));

	if (!listener) {
		fprintf(stderr, "Could not create a listener!\n");
		return 1;
	}

	//设置SIGINT信号的事件回调
	signal_event = evsignal_new(base, SIGINT, signal_cb, (void *)base);

	if (!signal_event || event_add(signal_event, NULL)<0) {
		fprintf(stderr, "Could not create/add a signal event!\n");
		return 1;
	}

	//进入等待事件循环---相当于while(1)
	event_base_dispatch(base);

	//释放资源
	//释放连接监听器
	evconnlistener_free(listener);
	//释放信号事件节点
	event_free(signal_event);
	//释放地基节点
	event_base_free(base);

	printf("done\n");
	return 0;
}


//listener: 链接监听器指针
//fd: 通信文件描述符
//sa和socklen: 客户端地址信息和长度
//user_data: 参数，具体是地基节点指针
static void
listener_cb(struct evconnlistener *listener, evutil_socket_t fd,
    struct sockaddr *sa, int socklen, void *user_data)
{
	struct event_base *base = user_data;
	struct bufferevent *bev; //指向bufferevent的指针

	//创建bufferevent缓冲区
	//BEV_OPT_CLOSE_ON_FREE: bufferevent释放的时候自动关闭通信文件描述符，当释放bufferevent的时候关闭连接
	bev = bufferevent_socket_new(base, fd, BEV_OPT_CLOSE_ON_FREE);
	if (!bev) {
		fprintf(stderr, "Error constructing bufferevent!");
		event_base_loopbreak(base); //退出循环,程序结束
		return;
	}
	//设置回调函数: 读回调, 写事件和异常事件回调函数
	bufferevent_setcb(bev, conn_readcb, conn_writecb, conn_eventcb, NULL);
	//使bufferevent设置生效 使写事件回调生效
	bufferevent_enable(bev, EV_WRITE);
	//使读事件回调失效
	bufferevent_enable(bev, EV_READ);

	//使bufferevent设置无效
	//bufferevent_disable(bev, EV_READ);

	//bufferevent_write(bev, MESSAGE, strlen(MESSAGE));
}

static void
conn_readcb(struct bufferevent *bev, void *user_data)
{
	//size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size);
	char buf[1024];
	memset(buf, 0x00, sizeof(buf));
	//从bufferevent读数据
	int n = bufferevent_read(bev, buf, sizeof(buf));
	printf("n=[%d],buf==[%s]\n", n, buf);

	int i=0;
	for(i=0; i<n; i++)
	{
		buf[i] = toupper(buf[i]);
	}
	//往bufferevent的写缓冲区写数据
	//int bufferevent_write(struct bufferevent *bufev, const void *data, size_t size);
	bufferevent_write(bev, buf, n); //写bufferevent缓冲区会触发写事件回调
}

static void
conn_writecb(struct bufferevent *bev, void *user_data)
{
	printf("--call--%s--\n", __FUNCTION__);

	//获取bufferevent的写缓冲区的指针
	struct evbuffer *output = bufferevent_get_output(bev);
	//查看缓冲区还有没有数据
	if (evbuffer_get_length(output) == 0) {
		printf("flushed answer\n");
		//释放bufferevent,关闭通信文件 描述符
		//bufferevent_free(bev);
	}
}

static void
conn_eventcb(struct bufferevent *bev, short events, void *user_data)
{
	if (events & BEV_EVENT_EOF) {
		printf("Connection closed.\n");
	} else if (events & BEV_EVENT_ERROR) {
		printf("Got an error on the connection: %s\n",
		    strerror(errno));/*XXX win32*/
	}
	/* None of the other events can happen here, since we haven't enabled
	 * timeouts */
	bufferevent_free(bev);
}

static void
signal_cb(evutil_socket_t sig, short events, void *user_data)
{
	struct event_base *base = user_data;
	struct timeval delay = { 2, 0 };

	printf("Caught an interrupt signal; exiting cleanly in two seconds.\n");

	//事件回调函数执行完后, 再过2秒, 跳出循环, 程序结束
	event_base_loopexit(base, &delay);
}
/*
#编译并启动服务端
aaron@aaron-virtual-machine:~$ gcc -o hello-world hello-world.c -levent
aaron@aaron-virtual-machine:~$ ./hello-world
--call--conn_writecb--
flushed answer
n=[6],buf==[hello
]
--call--conn_writecb--
flushed answer
--call--conn_writecb--
flushed answer
n=[5],buf==[nice
]
--call--conn_writecb--
flushed answer
--call--conn_writecb--
flushed answer
n=[8],buf==[welcome
]
--call--conn_writecb--
flushed answer
Connection closed.      //退出连接

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 9995
hello
HELLO

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 9995
nice
NICE

#打开一个连接
aaron@aaron-virtual-machine:~$ nc 127.1 9995
welcome
WELCOME
^C

aaron@aaron-virtual-machine:~$ netstat -anp | grep 9995
（并非所有进程都能被检测到，所有非本用户的进程信息将不会显示，如果想看到所有信息，则必须切换到 root 用户）
tcp        0      0 0.0.0.0:9995            0.0.0.0:*               LISTEN      27507/./hello-world
tcp        0      0 127.0.0.1:57354         127.0.0.1:9995          TIME_WAIT   -                   //主动关闭方处理TIME_WAIT状态
tcp        0      0 127.0.0.1:57344         127.0.0.1:9995          ESTABLISHED 27517/nc            
tcp        0      0 127.0.0.1:9995          127.0.0.1:57344         ESTABLISHED 27507/./hello-world 
tcp        0      0 127.0.0.1:9995          127.0.0.1:57348         ESTABLISHED 27507/./hello-world 
tcp        0      0 127.0.0.1:57348         127.0.0.1:9995          ESTABLISHED 27526/nc  
*/