#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/**
 * 写入文件
 */
int main1()
{
    char * p = "hello world\n";
    //w 以"写"的方式打开文件 文件不存在会创建新文件 如果文件里面有内容会覆盖原始内容
    FILE * fp = fopen("../../d.txt", "w");
    if (!fp)
        return -1;

    fputs(p, fp);

    //关闭文件
    fclose(fp);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
将“hello world”写入到上上级目录下的d.txt中
*/


/**
 * 读取文件1
 */
int main2()
{
    //r 以只读形式打开文件 不会创建新文件，如果文件不存在会报错
    FILE * fp = fopen("../../d.txt", "r");
    if (!fp)
        return -1;

    //块读取
    //char buf[1024]; //1KB
    char buf[5]; //5个字节
    fgets(buf, 5, fp);
    printf("第一次读取结果：%s\n", buf);
    memset(buf, 0, 5); //内存清0 将buf的内存区域的前5个字节以参数0填入

    fgets(buf, 5, fp);
    printf("第二次读取结果：%s\n", buf);
    memset(buf, 0, 5);

    fgets(buf, 5, fp);
    printf("第三次读取结果：%s\n", buf);

    fgets(buf, 5, fp);
    printf("第四次读取结果：%s\n", buf);

    //关闭文件
    fclose(fp);
    return 0;
}
/* Output:
第一次读取结果：hell
第二次读取结果：o wo
第三次读取结果：rld

第四次读取结果：rld  //上一步没有清除，数据已经读完，把上一次的数据打印出来了。
*/

/**
 * 读取文件2
 */
int main()
{
    //r 以只读形式打开文件 不会创建新文件，如果文件不存在会报错
    FILE * fp = fopen("../../d.txt", "r");
    if (!fp)
        return -1;

    //char buf[1024*1024]; //1M
    char * buf = malloc(sizeof(char) * 1024); //开辟1024个字节堆空间

    //feof()判断文件流是否到结尾  EOF 判断字符是否到结尾
    while (feof(fp) == 0){
        memset(buf, 0, 1024);
        fgets(buf, 1024, fp);
        printf("%s", buf);
    }

    free(buf);  //释放堆空间
    fclose(fp); //关闭文件
}
/* Output:
hello world
*/