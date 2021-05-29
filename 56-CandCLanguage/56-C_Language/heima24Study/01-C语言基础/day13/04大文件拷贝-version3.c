#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

//10M大小
#define MAXSIZE 1024*1024*10


/**
 * 使用缓存和二进制函数fread()和fwrite()方法一行一行拷贝
 *    411M文件，花费2秒时间
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

    char ch[1024];
    while(!feof(fp1)){
        memset(ch,0,1024);
//        fgets(ch, 1024, fp1);
//        fputc(ch, fp1);
//        fread(ch,1024,1,fp1);
//        fwrite(ch, 1024, 1, fp2);
        int len = fread(ch,1,1024,fp1); //返回读取到的大小
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
花费时间：2(s)
*/
