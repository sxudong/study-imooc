#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stdlib.h>

/**
 * 堆空间的误区
 *
 * 《C语言参考手册》上说“如果请求的长度为0，则标准C语言函数
 * 返回一个null指针”或不能用于访问对象的非null指针。
 */
int main()
{
    //第一个错误：操作野指针问题
    int * p = (int *)malloc(0); //开辟0空间大小,返回地址
    if(p == NULL)
        puts("[ptr]Got a null pointer");
    else
        puts("[ptr]unique pointer value"); //返回唯一的待释放指针，不是正常的开辟空间地址，所以是野指针

    //因此输出也不是确定的
    printf("%p\n", p); //00F10F90（这个地址每次运行都不一样，是一个野指针）

    //给野指针赋值
    *p = 100;

    printf("%d\n", *p); //100

    //system("pause");
    //堆空间开辟没有释放,释放会报错
    //free(p);

    return EXIT_SUCCESS;
}
