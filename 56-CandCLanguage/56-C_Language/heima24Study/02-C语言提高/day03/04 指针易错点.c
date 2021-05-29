#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* 当你操作某块内存的时候，这块内存一定要是合法的（自己申请的，在使用的时候还没有释放的）
*/
int main() {

	char* p = malloc(64);

	++p; //改变了指针的指向，free会down掉，释放时它不知道指针指向的内存空间大小是多少。
	if (p != NULL) {
	    //free(void* _Block)函数的参数类型是void *,无类型，可以看出编译器自己维护了一个数据，
	    //记录了p指向空间的大小。所以它不需要我们告诉它内存是多大。
		free(p);
		p = NULL;
	}

	system("pause");
	return EXIT_SUCCESS;
}