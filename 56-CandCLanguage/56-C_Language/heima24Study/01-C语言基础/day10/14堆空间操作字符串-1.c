#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{
    //开辟多大堆空间，就要操作多大堆空间
    char * p = malloc(sizeof(char) * 10); // \0 char类型占比个字节，1*10开辟10个字节空间大小

    //5.5.6 字符串处理函数
    //把src所指向的字符串复制到dest所指向的空间中，'\0'也会拷贝过去.如果没有'\0'会一直往后读，会出错。
    strcpy(p, "hello world"); //11个字符，数组下标越界

    printf("%s", p);

    free(p); //释放空间

    system("pause");
    return EXIT_SUCCESS;
}