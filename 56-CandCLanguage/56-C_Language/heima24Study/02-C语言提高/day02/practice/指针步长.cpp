#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stddef.h>

void test01()
{
	char *p = NULL;//NULL二进制就是0
	printf("p=%p\n", p);
	printf("p+1=%p\n", p + 1);
	int *p2 = NULL;
	printf("p2=%d\n", p2);
	printf("p2+1=%d\n", p2 + 1);


	char buf[1024] = { 0 };
	int a = 100;
	memcpy(buf + 1, &a, sizeof(int)); //把a的地址拷贝到buf+1，拷贝sizeof个字节
	char *p3 = buf;
	printf("*p3=%d\n", *(int *)(p3 + 1));
}


struct Person
{
	int a;
	char b;
	char buf[64];
	int d;
};


void test02()
{
	struct Person p = { 10, 'a', "hello world", 100 };
	int b;
	printf("%d\n", sizeof(struct Person));
	printf("a off:%d\n", offsetof(struct Person, b));
	//(size_t)  (((struct Person*) 0)->b)
	printf("%s\n", (char *)&p + 5);
	printf("%c\n", (char *)((char *)&p + offsetof(struct Person, b)));
}




void main()
{
	//test01();
	test02();
	system("pause");
}