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
	struct event_base *base;         //�ػ� ������ָ��ػ��ڵ��ָ��
	struct evconnlistener *listener; //���Ӽ����� ���������Ӽ�������ָ��
	struct event *signal_event;      //�ź��¼� �������ź��¼�ָ��

	struct sockaddr_in sin; //IP��ַ
#ifdef WIN32
	WSADATA wsa_data;
	WSAStartup(0x0201, &wsa_data);
#endif

	//�����ػ��ڵ�---�൱��epoll������(epoll_create)
	base = event_base_new();
	if (!base) {
		fprintf(stderr, "Could not initialize libevent!\n");
		return 1;
	}

	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET; //IPv4
	sin.sin_port = htons(PORT);

	//�������Ӽ�����--socket bind  listen  accept
	//listener_cb: �ص�����
	//LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE: ���ö˿ڸ���, �����Ӽ������ͷŵ�ʱ��ر��׽���(�����ļ�������)
	listener = evconnlistener_new_bind(base, listener_cb, (void *)base,
	    LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE, -1,
	    (struct sockaddr*)&sin,
	    sizeof(sin));

	if (!listener) {
		fprintf(stderr, "Could not create a listener!\n");
		return 1;
	}

	//����SIGINT�źŵ��¼��ص�
	signal_event = evsignal_new(base, SIGINT, signal_cb, (void *)base);

	if (!signal_event || event_add(signal_event, NULL)<0) {
		fprintf(stderr, "Could not create/add a signal event!\n");
		return 1;
	}

	//����ȴ��¼�ѭ��---�൱��while(1)
	event_base_dispatch(base);

	//�ͷ���Դ
	//�ͷ����Ӽ�����
	evconnlistener_free(listener);
	//�ͷ��ź��¼��ڵ�
	event_free(signal_event);
	//�ͷŵػ��ڵ�
	event_base_free(base);

	printf("done\n");
	return 0;
}


//listener: ���Ӽ�����ָ��
//fd: ͨ���ļ�������
//sa��socklen: �ͻ��˵�ַ��Ϣ�ͳ���
//user_data: �����������ǵػ��ڵ�ָ��
static void
listener_cb(struct evconnlistener *listener, evutil_socket_t fd,
    struct sockaddr *sa, int socklen, void *user_data)
{
	struct event_base *base = user_data;
	struct bufferevent *bev; //ָ��bufferevent��ָ��

	//����bufferevent������
	//BEV_OPT_CLOSE_ON_FREE: bufferevent�ͷŵ�ʱ���Զ��ر�ͨ���ļ������������ͷ�bufferevent��ʱ��ر�����
	bev = bufferevent_socket_new(base, fd, BEV_OPT_CLOSE_ON_FREE);
	if (!bev) {
		fprintf(stderr, "Error constructing bufferevent!");
		event_base_loopbreak(base); //�˳�ѭ��,�������
		return;
	}
	//���ûص�����: ���ص�, д�¼����쳣�¼��ص�����
	bufferevent_setcb(bev, conn_readcb, conn_writecb, conn_eventcb, NULL);
	//ʹbufferevent������Ч ʹд�¼��ص���Ч
	bufferevent_enable(bev, EV_WRITE);
	//ʹ���¼��ص�ʧЧ
	bufferevent_enable(bev, EV_READ);
	
	//ʹbufferevent������Ч
	//bufferevent_disable(bev, EV_READ);

	//bufferevent_write(bev, MESSAGE, strlen(MESSAGE));
}

static void
conn_readcb(struct bufferevent *bev, void *user_data)
{
	//size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size);
	char buf[1024];
	memset(buf, 0x00, sizeof(buf));
	//��bufferevent������
	int n = bufferevent_read(bev, buf, sizeof(buf));
	printf("n=[%d],buf==[%s]\n", n, buf);
	
	int i=0;
	for(i=0; i<n; i++)
	{
		buf[i] = toupper(buf[i]);
	}
	//��bufferevent��д������д����
	//int bufferevent_write(struct bufferevent *bufev, const void *data, size_t size);
	bufferevent_write(bev, buf, n); //дbufferevent�������ᴥ��д�¼��ص�
}

static void
conn_writecb(struct bufferevent *bev, void *user_data)
{
	printf("--call--%s--\n", __FUNCTION__);
	
	//��ȡbufferevent��д��������ָ��
	struct evbuffer *output = bufferevent_get_output(bev);
	//�鿴����������û������
	if (evbuffer_get_length(output) == 0) {
		printf("flushed answer\n");
		//�ͷ�bufferevent,�ر�ͨ���ļ� ������
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

	//�¼��ص�����ִ�����, �ٹ�2��, ����ѭ��, �������
	event_base_loopexit(base, &delay);
}
/*
#���벢���������
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
Connection closed.      //�˳�����

#��һ������
aaron@aaron-virtual-machine:~$ nc 127.1 9995
hello
HELLO

#��һ������
aaron@aaron-virtual-machine:~$ nc 127.1 9995
nice
NICE

#��һ������
aaron@aaron-virtual-machine:~$ nc 127.1 9995
welcome
WELCOME
^C

aaron@aaron-virtual-machine:~$ netstat -anp | grep 9995
���������н��̶��ܱ���⵽�����зǱ��û��Ľ�����Ϣ��������ʾ������뿴��������Ϣ��������л��� root �û���
tcp        0      0 0.0.0.0:9995            0.0.0.0:*               LISTEN      27507/./hello-world 
tcp        0      0 127.0.0.1:57354         127.0.0.1:9995          TIME_WAIT   -                   //�����رշ�����TIME_WAIT״̬              
tcp        0      0 127.0.0.1:57344         127.0.0.1:9995          ESTABLISHED 27517/nc            
tcp        0      0 127.0.0.1:9995          127.0.0.1:57344         ESTABLISHED 27507/./hello-world 
tcp        0      0 127.0.0.1:9995          127.0.0.1:57348         ESTABLISHED 27507/./hello-world 
tcp        0      0 127.0.0.1:57348         127.0.0.1:9995          ESTABLISHED 27526/nc  
*/