#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include<sys/types.h>
#include <sys/stat.h>

//10M大小
#define MAXSIZE 1024*1024*10


/**
 * 一行一行拷贝
 *    1.使用缓存
 *    2.二进制函数fread()和fwrite()方法
 *    3.根据文件大小来开辟堆空间
 */
//gcc -o mycp main.c
//mycp 生日快乐.mp4 wow.mp4
int main(int argc,char * argv[])
{
    unsigned int start_time= time(NULL); //开始时间

//    if(argc < 3){
//        printf("缺少参数\n");
//        return -1;
//    }

    /*
     * mycp     wow.2.mp4  wow.3.mp4
     * argv[0]  argv[1]    arr[2]
     */
//    FILE * fp1 = fopen(argv[1], "rb"); //打开文件
//    FILE * fp2 = fopen(argv[2], "wb"); //打开文件
    FILE * fp1 = fopen("D:\\tmp\\test.mp4", "rb");
    FILE * fp2 = fopen("D:\\tmp\\test2.mp4", "wb");

    if(!fp1 || !fp2){
        printf("操作文件失败\n");
        return -2;
    }

    //char ch[1024]; //1KB
    //char * ch = malloc(sizeof(char)*MAXSIZE); //开辟10M堆空间

    //根据文件大小来开辟堆空间

    //获取文件属性
    struct stat s;
    //获取源文件
    //stat(argv[1], &s);
    stat("D:\\tmp\\test.mp4", &s);
    char * ch;
    int maxSize=0;
    if(s.st_size < MAXSIZE){
        maxSize = s.st_size;
        ch = (char *)malloc(sizeof(char)*s.st_size);
    } else {
        maxSize = MAXSIZE;
        ch = (char *)malloc(sizeof(char)*MAXSIZE);
    }

    while(!feof(fp1)){
        memset(ch,0,MAXSIZE);
//        fgets(ch, 1024, fp1);
//        fputc(ch, fp1);
//        fread(ch,1024,1,fp1);
//        fwrite(ch, 1024, 1, fp2);
        int len = fread(ch,1,MAXSIZE,fp1); //返回读取到的大小
        fwrite(ch,1,len,fp2);
    }

    //关闭文件
    fclose(fp1);
    fclose(fp2);

    unsigned int end_time=time(NULL); //结束时间

    printf("花费时间：%d(s)\n", end_time-start_time);

    return 0;
}
/* 411M文件
花费时间：0(s)
*/
