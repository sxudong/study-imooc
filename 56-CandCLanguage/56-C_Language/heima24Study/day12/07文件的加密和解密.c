#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/**
 * 从源文件中读取字符
 *   进行加密 -> 生成一个新文件
 */
int main1()
{
    // r 以只读形式打开文件 不会创建新文件，如果文件不存在会报错
    FILE * fp1 = fopen("D:\\tmp\\src.txt", "r");
    FILE * fp2 = fopen("D:\\tmp\\pas.txt", "w");
    if (!fp1 || !fp2)
        return -1;

    //读源文件内容  直到EOF
    char ch;
    while ((ch = fgetc(fp1)) != EOF){
        ch++; //以++的方式加密
        fputc(ch, fp2);
    }

    //关闭文件
    fclose(fp1);
    fclose(fp2);

    system("pause");
    return EXIT_SUCCESS;
}

/**
 * 从加密文件中读取字符
 *   进行解密 -> 变成源文件
 */
int main(void)
{
    FILE * fp1 = fopen("D:\\tmp\\pas.txt", "r");
    FILE * fp2 = fopen("D:\\tmp\\src1.txt", "w");
    if (!fp1 || !fp2)
        return -1;

    char ch;
    while ((ch = fgetc(fp1)) != EOF){
        ch--; //以--的方式加密
        fputc(ch, fp2);
    }

    //关闭文件
    fclose(fp1);
    fclose(fp2);
}