#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
1、打开文件  判断可用性
2、读取内容 再放堆空间中  关闭文件
3、再次打开文件 读取堆空间内容 写入文件中  关闭文件
//{"2+3=4\n","4*5=9\n",""}
//char * buf[100];  buf[1]
//char ** buf = (char **)malloc(sizeof(char *)*100);
//buf[i] = (char *)malloc(sizeof(char)*20);
*/
int main()
{
    //r+ 以可读、可写的方式打开文件(不创建新文件)
    FILE * fp = fopen("../../c.txt", "r+"); //读取"06四则运算.c"生成的c.txt文件
    if (!fp)
        return -1;

    //二级指针
    //开辟100个char*,400字节堆空间,由于char*是一线指针，所以要用二给指针接收
    char ** buf = (char **)malloc(sizeof(char *) * 100);
    //printf("%d\n",sizeof(char*)); //4

    int a, b;
    char c;
    float value;
    for (int i = 0; i < 100; i++){
        buf[i] = (char *)malloc(sizeof(char) * 20);

        //格式化读取 a c b 的值
        fscanf(fp, "%d%c%d=\n", &a, &c, &b);

        //计算
        switch (c){
            case '+':
                value = a + b;
                break;
            case '-':
                value = a - b;
                break;
            case '*':
                value = a * b;
                break;
            case '/':
                value = a * 1.0 / b;
                break;
        }
        //计算完之后，将格式化的数据写入字符串
        sprintf(buf[i], "%d%c%d=%.2f\n", a, c, b, value);
        //fgets(buf[i], 20, fp);

    }

    //关闭文件
    fclose(fp);


    //for (int i = 0; i < 100; i++)
    //{
    //	printf("%s", buf[i]);
    //}

    //将结果重新写入c.txt
    fp = fopen("../../c.txt", "r+"); //r+ 以可读、可写的方式打开文件(不创建新文件)
    if (!fp)
        return -1;

    for (int i = 0; i < 100; i++)
        fputs(buf[i], fp);
    //关闭文件
    fclose(fp);


    //内存释放
    for (int i = 0; i < 100; i++){
        free(buf[i]);
        buf[i] = NULL;
    }
    free(buf);

    system("pause");
    return EXIT_SUCCESS;
}
/* 读取"06四则运算.c"生成的c.txt文件，进行计算，并保存到c.txt中
5/6=0.83
0.83=0.83
9+2=11.00
11.0=11.00
11.0=11.00
...
*/