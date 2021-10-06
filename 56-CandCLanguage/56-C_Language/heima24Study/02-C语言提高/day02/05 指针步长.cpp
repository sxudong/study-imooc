#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stddef.h> //计算偏移量的头文件


/*
* 指针步长：指针变量+1 要向后跳多少字节
* 指针的类型，不单单决定指针的步长，还决定解引用的时候从给定地址开始取类型大小的字节数
*/

//1、指针的步长代表 指针+1之后跳跃的字节数
void test01()
{
	char* p = NULL;
	printf("%d\n", p);     //0
	printf("%d\n", p + 1); //1

	printf("----------------\n");

	double* p2 = NULL;
	printf("%d\n", p2);     //0
	printf("%d\n", p2 + 1); //8

	printf("----------------\n");

}

//2、解引用的时候，解出的字节数量
void test02()
{
	char buf[1024] = { 0 };
	int a = 100;

	//把a的地址拷贝到buf+1，拷贝sizeof个字节,也就是把&a拷贝到buf数组的1下标处。
	memcpy(buf + 1, &a, sizeof(int));


	char* p = buf;
	//p3的地址是数组首地址，+1 数组下标向后移一位，打印的结果刚好是上一步拷贝的数组结果100.
	printf("%d\n", *(int*)(p + 1)); //100

}

//步长练习，自定义数据类型练习
struct Person
{
	int a;        //  0 ~ 3
	char b;       //  4 ~ 7
	char buf[64]; //  8 ~ 71
	int d;        // 72 ~ 75
};

void test03()
{
	struct Person p = { 10, 'a', "hello world!", 100 };
	//char b;

	//首地址
	printf("首地址的值为：%d\n", *(int*)((char*)&p)); //10

	printf("----------------\n");

	// b成员的偏移量
	printf("b属性的偏移量：%d\n", offsetof(struct Person, b)); //4
	printf("b属性的值为：%s\n", (char*)&p + offsetof(struct Person, b)); //a  #这里比较奇葩，Qt编译器输出的是“a”,VS编译器输出的是“ahello world!”

	printf("----------------\n");

	printf("buf属性的偏移量：%d\n", offsetof(struct Person, buf)); //8
	printf("buf属性的值为：%s\n", (char*)&p + offsetof(struct Person, buf)); //hello world!

	printf("----------------\n");

	printf("d属性的偏移量：%d\n", offsetof(struct Person, d)); //72
	printf("d属性的值为：%d\n", *(int*)((char*)&p + offsetof(struct Person, d))); //100
}
/* Output:
首地址的值为：10
----------------
b属性的偏移量：4
b属性的值为：a
----------------
buf属性的偏移量：8
buf属性的值为：hello world!
----------------
d属性的偏移量：72
d属性的值为：100
*/


int main() {

	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}