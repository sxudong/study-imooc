#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
    #include <stdio.h>
    size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

    功能：以数据块的方式给文件写入内容

    参数：
        ptr：准备写入文件数据的地址
        size： size_t 为 unsigned int类型，此参数指定写入文件内容的块数据大小
        nmemb：写入文件的块数，写入文件数据总大小为：size * nmemb
        stream：已经打开的文件指针

    返回值：
        成功：实际成功写入文件数据的块数目，此值和nmemb相等
        失败：0
*/
/**
 * fwrite()可以控制存储的二进制文件大小
 */
int main1()
{
//	char arr[16] = "hello world";
//  FILE * fp = fopen("../../a.txt", "wb");
//	if (!fp)
//		return -1;
//    fwrite(arr, sizeof(char), 12, fp); //鼠标右键查看a.txt大小是12个字节
//    fclose(fp);

    int arr[] = { 888888,888888,888888,888888,5,6,7,8,10 }; //0000 0001

    //"wb" 以可读、可写的方式打开文件(如果文件存在则清空文件，文件不存在则创建一个文件)
    FILE * fp = fopen("../../b.txt", "wb");
    if (!fp)
        return -1;

    fwrite(arr, sizeof(int), 4, fp); //文件大小是16个字节
    //fprintf(fp, "12345678910"); //文件大小是11个字节大小，char类型

    fclose(fp);

    return EXIT_SUCCESS;
}



/*
    #include <stdio.h>
    size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);

    功能：以数据块的方式从文件中读取内容

    参数：
        ptr：存放读取出来数据的内存空间
        size： size_t 为 unsigned int类型，此参数指定读取文件内容的块数据大小
        nmemb：读取文件的块数，读取文件数据总大小为：size * nmemb
        stream：已经打开的文件指针

    返回值：
        成功：实际成功读取到内容的块数，如果此值比nmemb小，但大于0，说明读到文件的结尾。
        失败：0
*/
/**
 * fread()读取二进制文件
 */
int main()
{
    FILE * fp = fopen("../../b.txt", "rb"); //读取上一个main()生成的b.txt二进制文件
    if (!fp)
        return -1;

    int arr[10] = {0};
    int i = 0;
    while (!feof(fp)){ //循环把文件读完
        fread(&arr[i++], sizeof(int), 1, fp); //888888
    }

    //关闭文件
    fclose(fp);

    printf("%d\n", arr[0]);
    printf("%d\n", arr[1]);
    printf("%d\n", arr[2]);
    printf("%d\n", arr[3]);
    return -1;
}
/* Output:
888888
888888
888888
888888
*/