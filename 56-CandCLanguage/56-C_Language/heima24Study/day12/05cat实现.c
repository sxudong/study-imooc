#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
 #include <stdio.h>
 int fgetc(FILE * stream);

 功能：从stream指定的文件中读取一个字符
 参数：
	stream：文件指针
 返回值：
	成功：返回读取到的字符
	失败：-1
*/

/**
 * 查看文本文件  cat abc.txt
 */
int main()
{
    //1、指定一个文件名
    char fileName[256]; //文件名最长到255个字节，最后一个字符为结束符'\0'

    printf("请输入您查看的文件：\n");
    scanf("%s", fileName); //从键盘获取
    getchar(); //getchar函数默认从此终端获得数据

    //打开文件
    FILE * fp = fopen(fileName, "r");
    if (!fp)
        return -1;

    //文件的结束标志  EOF -1
    char ch;
    while ((ch = fgetc(fp)) != EOF) //fgetc()读取文件
        printf("%c", ch);

    //关闭文件
    fclose(fp);
    system("pause");
    return EXIT_SUCCESS;
}
/* Output：
请输入您查看的文件：
D:\tmp\cc.txt
#include <stdio.h>

int main(void)
{
    printf("hello world\n");
    return 0;
}
请按任意键继续. . .
*/
