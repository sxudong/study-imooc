#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#include <time.h>

/*
 * 1、以写方式打开文件 判断文件
 * 2、定义 三个变量  字符串
 * 3、循环100次
 * 4、格式化字符串
 * 5、录入内容
 * 6、文件关闭
 *
 * 循环四则运算100次
 * char arr[20]
 * sprintf(arr,"%d%c%d=\n",a,c,b);
 * while(arr!='\0'){
 *
 * }
 * 3*2=
 * 5/2=
 * 3-1=
 * 4+6=
**/
enum MyEnum
{
    add,sub,mlt,dive
}opt;


int main()
{
    srand((unsigned int)time(NULL)); //随机种子

//    char fileName[256];
//    printf("请输入文件名：\n");
//    scanf("%s", fileName);
//    getchar();
//    FILE * fp = fopen(fileName, "w");

    //1、以"写"方式打开文件 判断文件
    FILE * fp = fopen("../../c.txt", "w");
    if (!fp)
        return -1;

    //2、定义 三个变量
    int a, b;
    char c;
    char buf[20]; //20个字节缓冲buffer

    //3、循环100次
    for (int i = 0; i < 100; i++){
        switch (rand()%4){
            case add:
                c = '+';
                break;
            case sub:
                c = '-';
                break;
            case mlt:
                c = '*';
                break;
            case dive:
                c = '/';
                break;
        }
        a = rand() % 10 + 1; //2
        b = rand() % 10 + 1; //3
        memset(buf, 0, 20);  //清零（参见8.2.3 存储类型总结内存操作函数）
        //4、格式化字符串
        sprintf(buf, "%d%c%d=\n", a, c, b); //2*3=\n

        //5、录入内容
        int j = 0;
        while (buf[j])
            fputc(buf[j++], fp);
    }
    //6、关闭文件
    fclose(fp);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
会在上上一个目录下生成一个文件c.txt
5/6=
9+2=
10-2=
2*5=
6/6=
10-5=
1*1=
......
*/
