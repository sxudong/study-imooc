#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
1. calloc()

 #include <stdlib.h>
 void *calloc(size_t nmemb, size_t size);
 -功能：
	 在内存动态存储区中分配nmemb块长度为size字节的连续区域。calloc自动将分配的内存置0。
 -参数：
	nmemb：所需内存单元数量
	size：每个内存单元的大小（单位：字节）
 -返回值：
	成功：分配空间的起始地址
	失败：NULL
*/
void test01()
{
	//开辟10个int类型40个字节的堆空间
	int* p = calloc(10, sizeof(int));
	for (int i = 0; i < 10; ++i)
		p[i] = i + 1;

	for (int i = 0; i < 10; ++i)
		printf("%d ", p[i]); //1 2 3 4 5 6 7 8 9 10


	if (p != NULL){
		free(p);  //释放堆空间
		p = NULL; //指向空指针
	}

	printf("\n");
}


/*
 2.realloc()
 #include <stdlib.h>
 void *realloc(void *ptr, size_t size);
 -功能：
	 重新分配用malloc或者calloc函数在堆中分配内存空间的大小。
	 realloc不会自动清理增加的内存，需要手动清理，如果指定的地址后面有连续的空间，
	 那么就会在已有地址基础上增加内存，如果指定的地址后面没有空间，那么realloc会
	 重新分配新的连续内存，把旧内存的值拷贝到新内存，同时释放旧内存。

 -参数：
	ptr：为之前用malloc或者calloc分配的内存地址，如果此参数等于NULL，那么和realloc与malloc功能一致。
	size：为重新分配内存的大小, 单位：字节。

 -返回值：
	成功：新分配的堆内存地址
	失败：NULL

*/
void test02()
{
	int* p = malloc(sizeof(int) * 10);
	for (int i = 0; i < 10; ++i)
		p[i] = i + 1;

	//打印
	for (int i = 0; i < 10; ++i)
		printf("%d ", p[i]); //1 2 3 4 5 6 7 8 9 10

	printf("%d\n", p);                 //12737336  #申请前的内存地址
	//p = realloc(p, sizeof(int) * 20);
	p = realloc(p, sizeof(int) * 200); //重新分配200个int类型800个字符空间
	printf("%d\n", p);                 //12758752  #申请后的内存地址

	//原来的10个数据都拷贝过来了
	for (int i = 0; i < 15; ++i)
		printf("%d ", p[i]); //1 2 3 4 5 6 7 8 9 10 -33686019 265257588 2082438784 16729 10312144

	printf("\n");
}


int main() {

	test01();
	printf("--------------------\n");
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1 2 3 4 5 6 7 8 9 10
--------------------
1 2 3 4 5 6 7 8 9 10 16407056
16440816
1 2 3 4 5 6 7 8 9 10 -842150451 -842150451 -842150451 -842150451 -842150451
请按任意键继续. . .
*/