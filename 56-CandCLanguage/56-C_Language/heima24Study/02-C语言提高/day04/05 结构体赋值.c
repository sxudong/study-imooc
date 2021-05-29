#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Person
{
	char name[64];
	int age;
};

void test01()
{
	struct Person person1 = { "aaa", 20 };
	struct Person person2 = { "bbb", 30 };

	//赋值操作
	person1 = person2;  //person2拷贝到person1

	printf("Name:%s Age:%d\n", person1.name, person1.age); //Name:bbb Age:30
	printf("Name:%s Age:%d\n", person2.name, person2.age); //Name:bbb Age:30
}


struct Teacher
{
	char* name;
	int age;
};

void test02()
{
	struct Teacher teacher1;
	teacher1.name = malloc(sizeof(char) * 64); //开辟堆内存
	memset(teacher1.name, 0, 64);
	strcpy(teacher1.name, "aaa");
	teacher1.age = 20;

	struct Teacher teacher2;
	teacher2.name = malloc(sizeof(char) * 128); //开辟堆内存
	memset(teacher2.name, 0, 128);
	strcpy(teacher2.name, "bbbbbbbbbbbbb");
	teacher2.age = 30;

	printf("Name:%s Age:%d\n", teacher1.name, teacher1.age); //Name:aaa Age:20
	printf("Name:%s Age:%d\n", teacher2.name, teacher2.age); //Name:bbbbbbbbbbbbb Age:30

    //栈上空间一样大
	printf("teacher1 size: %d\n", sizeof(teacher1)); //teacher1 size: 8
	printf("teacher2 size: %d\n", sizeof(teacher2)); //teacher2 size: 8

	/*
	* 赋值操作
	* 如果结构体内部有指针，并且指向堆空间。那么如果发生赋值行为，就会产生两个问题：
	* 1.同一块空间被释放2次。
	* 2.内存泄露
	*   这就是所谓的“深拷贝”。
	*/
	//不使用默认的结构体赋值行为
	//teacher1 = teacher2;  //加上这句程序会崩掉，因teacher1.name指向同一个内存地址，后面释放内存释放了2次。teacher1.name原来的堆内存空间就得不到释放，导致内存泄露。
	//如果结构体内部有"指针"指向“堆内存”，那么就不能使用编译器默认的赋值行为，应该“手动控制”赋值过程。

	//----------------------------------------------

	if (teacher1.name != NULL){
		free(teacher1.name);
		teacher1.name = NULL;
	}

    //“手动控制”赋值过程
	teacher1.name = malloc(strlen(teacher2.name) + 1); //重新开辟空间
	strcpy(teacher1.name, teacher2.name); //复制值
	teacher1.age = teacher2.age;

	//----------------------------------------------

	printf("---------------\n");
	printf("Name:%s Age:%d\n", teacher1.name, teacher1.age); //Name:bbbbbbbbbbbbb Age:30
	printf("Name:%s Age:%d\n", teacher2.name, teacher2.age); //Name:bbbbbbbbbbbbb Age:30

	//释放堆内存
	if (teacher1.name != NULL){
		free(teacher1.name);
		teacher1.name = NULL;
	}

	if (teacher2.name != NULL){
		free(teacher2.name);
		teacher2.name = NULL;
	}

}


int main() {

	test01();
	printf("----------02----------\n");
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Name:bbb Age:30
Name:bbb Age:30
----------02----------
Name:aaa Age:20
Name:bbbbbbbbbbbbb Age:30
teacher1 size: 8
teacher2 size: 8
---------------
Name:bbbbbbbbbbbbb Age:30
Name:bbbbbbbbbbbbb Age:30
请按任意键继续. . .
*/