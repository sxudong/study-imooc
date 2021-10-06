#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test01()
{
	FILE* f = fopen("./test.txt", "r");
	if (NULL == f){
		printf("打开文件失败!\n");
		return;
	}

	char ch;

	//abcdefEOF
		  //A
#if 0
	//读取打印文件
	while (!feof(f)){
		ch = fgetc(f);

		//只要读到了EOF，_flag就是true
		if (feof(f)) //不加这个判断，会多打2个格，这2个空格就是EOF
			break;

		printf("%c", ch);
	}
	printf("\n");
#endif
	//只要没有读到EOF，就继续读取打印
	while ((ch = fgetc(f)) != EOF)
		printf("%c", ch); //打印读取到的数据
	printf("\n");

	//关闭文件
	fclose(f);
	f = NULL;
}

struct Person
{
	//嵌套一级指针，当fread()只是把name指针写到文件里面了，堆上数据没有写到文件里面
	//如果name是一个指针的话，不能把指针写到文件里面去。如果程序关闭，你再从文件里读数据，堆上数据已经丢失了。
	char* name;
	int age;
};

void test02()
{
	//struct Person p1 = { "aaa", 20 };
}

int main() {

	test01();
	//printf("%c",EOF); //EOF:end of

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
aaaaaaaaaaaaaaaaaaaaaaaaaaaa
请按任意键继续. . .
*/