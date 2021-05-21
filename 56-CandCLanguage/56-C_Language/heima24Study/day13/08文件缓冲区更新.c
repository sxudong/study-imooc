#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
#include <stdio.h>
int fflush(FILE *stream);

 功能：更新缓冲区，让缓冲区的数据立马写到文件中。

 参数：
   stream：文件指针
   返回值：
 成功：0
 失败：-1
*/

int main()
{
    char fileName[256];
    printf("请输入文件：\n");
    scanf("%s", fileName);
    getchar();

    FILE * fp = fopen(fileName, "w"); //打开文件
    if (!fp)
        return -1;

    char buf[1024];
    while (1){
        //读取文件
        fgets(buf, 1024, stdin);
        //往文件中写入"comm=exit"代表退出
        if (!strncmp(buf, "comm=exit", 9))
            break;

        //写入文件
        fputs(buf, fp);

        //更新缓冲区，让缓冲区的数据“立马”写到文件中
        fflush(fp); //参见：10.8.3更新缓冲区
    }

    //关闭文件
    fclose(fp);

    //FILE * p = _popen()
    //_pclose
    return EXIT_SUCCESS;
}
/* 执行结果：
在打开的文件中写入数据
*/