#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
fseek(文件流，移动字节，模式)  移动光标位置
模式：SEEK_SET 以文件开头为标准
      SEEK_CUR 以光标当前位置为标准
      SEEK_END 以文件结尾为标准

ftell(文件流)  获取光标当前位置  返回值是long  -1代表失败

rewind(文件流)  重置光标到文件开始位置

*/

/**
 * 写一个d.txt文件
 */
int main1()
{
    char * arr = "hello world";
    FILE * fp = fopen("../../d.txt", "w");

    fputs(arr, fp);

    fclose(fp);

    system("pause");
    return EXIT_SUCCESS;
}


/**
 * ftell 获取当前光标所在位置
 *   返回值是long  -1代表失败
 * fseek 移动光标位置
 */
int main2()
{
    //以只读的方式开打一个文件
    FILE * fp = fopen("../../d.txt", "r"); //"hello world"
    if (!fp)
        return -1;

    //SEEK_SET 文件起始位置 0
    //SEEK_END 文件结尾位置

    //在读之前改变光标位置,从6之后开始读取
//    fseek(fp, 6, SEEK_SET);
//    char ch;
//    while ((ch = getc(fp)) != EOF){
//        printf("%c", ch); //world
//    }

    //在读之前改变光标位置,从后往前读5个字符，不包含结束符'\0'
//    fseek(fp, -5, SEEK_END);
//    char ch;
//    while ((ch = getc(fp)) != EOF){
//        printf("%c", ch); //world
//    }

    //读取一个值，往后跳5个字符
//    char ch;
//    while ((ch = getc(fp)) != EOF){
//        fseek(fp, 5, SEEK_CUR);
//        printf("%c", ch); //hw
//    }

    char ch;
    int len = ftell(fp); //光标从0开始
    printf("%d\n", len);
    //读一个移动一个位置
    while ((ch = getc(fp)) != EOF){
        int len = ftell(fp);
        printf("%c", ch);
        printf("%d\n", len);
    }

    //关闭文件
    fclose(fp);
    return 0;
}
/* Output:
0
h1
e2
l3
l4
o5
 6
w7
o8
r9
l10
d11
*/


/**
 * ftell 获取当前光标所在位置
 *   返回值是long  -1代表失败
 */
int main03()
{
    //在文件中保存多个hello world
    FILE * fp = fopen("../../d.txt", "r"); //打开文件
    if (!fp)
        return -1;

    char  buf[20];
    while (!feof(fp)){
        fgets(buf, 20, fp);
        printf("%s", buf);
        printf("%ld\n", ftell(fp)); //光标位置 1
    }

    //关闭文件
    fclose(fp);
    return 0;
}
/* Output:
hello world hello w19
orld hello world he38
llo world hello wor57
ld hello world hell76
o world hello world95
 hello world hello 114
world119
*/


int main()
{
    FILE * fp = fopen("../../d.txt", "r"); //打开文件
    if (!fp)
        return -1;

    char  buf[20];
    for (int i = 0; i < 5; i++){
        fgets(buf, 20, fp);
        printf("%s", buf);
        printf("%ld\n", ftell(fp));
    }

    //重置光标（光标移到文件起始位置）
    rewind(fp);
    printf("%ld\n", ftell(fp)); //0

    //关闭文件
    fclose(fp);
    return 0;
}
/* Output:
hello world hello w19
orld hello world he38
llo world hello wor57
ld hello world hell76
o world hello world95
0
*/
