#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>



/*
字符串的标准输入输出
    scanf("%d,%d,%d",ch)    printf("%0d",1);
    格式化字符串   char arr[]="相约98"   char ch[10]="恋曲"; int a=1990;
    sscanf() sprintf()   数据类型  char *    format
    sscanf(arr,"%s%d",ch,&a);
    sprintf(arr,"%s%d",ch,a);

格式化文件读写 数据类型  FILE *  fp    format
    fscanf() fprintf()
    fscanf(fp,"%s%d",ch,&a);
    fprintf(fp,"%s%d",ch,a);
*/

/**
 * 格式化写内容
 */
int main1()
{
    //w 以"写"的方式打开文件 文件不存在会创建新文件 如果文件里面有内容会覆盖原始内容
    FILE * fp1 = fopen("../../f.txt", "w");
    if (!fp1)
        return -1;

    fprintf(fp1, "%d+%d=%d\n", 1, 2, 3);

    fclose(fp1);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
文件中写入
1+2=3
*/


/**
 * 格式化读内容
 */
int main2()
{
    //r 以只读形式打开文件 不会创建新文件，如果文件不存在会报错
    FILE * fp1 = fopen("../../f.txt", "r");
    if (!fp1)
        return -1;

    int a, b, c;
    fscanf(fp1, "%d+%d=%d\n", &a, &b, &c);

    printf("%d   %d   %d\n", a, b, c);

    //关闭文件
    fclose(fp1);
    return 0;
}
/* Output:
1   2   3
*/


/**
 * 格式化读内容
 */
int main()
{
    //r 以只读形式打开文件 不会创建新文件，如果文件不存在会报错
    FILE * fp1 = fopen("../../c.txt", "r");
    if (!fp1)
        return -1;

    int a, b, c;
    char ch;
    for (int i = 0; i < 100; i++){
        fscanf(fp1, "%d%c%d=\n", &a, &ch, &b);
        printf("%d%c%d=\n", a, ch, b);
    }

    //关闭文件
    fclose(fp1);
    return 0;
}
/*
读取"06四则运算.c"生成的c.txt文件：
5/6=
9+2=
10-2=
2*5=
6/6=
......
*/