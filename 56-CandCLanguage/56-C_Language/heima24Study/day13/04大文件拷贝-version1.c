#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

//10M大小
#define MAXSIZE 1024*1024*10


/**
 * 一个字节一个字节的拷贝
 *   411M文件花费时间：34(s)
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

    char ch;
    while(feof(fp1) == 0){
        ch = fgetc(fp1);
        fputc(ch, fp2);
    }

    //关闭文件
    fclose(fp1);
    fclose(fp2);

    unsigned int end_time=time(NULL); //结束时间

    printf("花费时间：%d(s)\n", end_time-start_time);

    return 0;
}
/* 411M文件
花费时间：34(s)
*/


void myfile_cp()
{
    FILE *rfp = fopen("D:\\tmp\\a.mp4", "rb");
    FILE *wfp = fopen("D:\\tmp\\b.mp4", "wb");

    char buf[4096] = {0};  // 缓冲区。

    int ret = 0;

    while (1){
        memset(buf, 0, sizeof(buf));
        ret = fread(buf, 1, sizeof(buf), rfp);
        if (ret == 0){
            break;
        }
        printf("ret = %d\n", ret);
        fwrite(buf, 1, ret, wfp);
    }

    fclose(wfp);
    fclose(rfp);
}

int main2(void)
{
    myfile_cp();

    printf("---------------------finish\n");

    system("pause");
    return EXIT_SUCCESS;
}
