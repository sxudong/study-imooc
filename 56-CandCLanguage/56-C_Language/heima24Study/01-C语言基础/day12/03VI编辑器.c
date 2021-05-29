#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
 #include <stdio.h>
 int fputc(int ch, FILE * stream);

 功能：将ch转换为unsigned char后写入stream指定的文件中
 参数：
	ch：需要写入文件的字符
	stream：文件指针
 返回值：
	成功：成功写入文件的字符
	失败：返回-1
*/


/**
 * 创建写入文件 muvi文本编辑器 abc.txt
 */
int main(int argc ,char * argv[])
{
    //1、指定一个文件名
    char fileName[256]; //文件名最长到255个字节，最后一个字符为结束符'\0'
    printf("请您输入一个需要创建的文件：\n");
    scanf("%s", fileName);
    //注意问题：用来接收换行。getchar函数默认从此终端获得数据
    getchar();

    FILE * fp = fopen(fileName, "w");
    if (fp == NULL){
        return -1;
    }
    //scanf("%[^\n]",buf);
    //fgets()

    //定义一个块，一次只能接收1024个字节
    char buf[1024];
    while (1){
        memset(buf, 0, 1024); //清空为0
        //scanf("%[^\n]", buf); //通过键盘获取
        fgets(buf, 1024, stdin); //fgets()写入到文件中

        //结束：录入"comm=exit"
        if (strncmp("comm=exit", buf,9) == 0){
            break;
        }
        //如果字符串不等于结束符'\0'，继续写入
        int i = 0;
        while (buf[i] != '\0'){
            fputc(buf[i++], fp);
            //i++;
        }
    }

    //关闭文件
    fclose(fp);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
请您输入一个需要创建的文件：
D:\tmp\abc.txt
perfect
hello
girl
comm=exit
请按任意键继续. . .
*/