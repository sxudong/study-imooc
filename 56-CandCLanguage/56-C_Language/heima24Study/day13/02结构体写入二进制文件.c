#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct students
{
    char name[20]; //20
    int age;       //4
    char sex;      //1
    char tel[15];  //15
};
typedef struct students stu;


/**
 * 使用结构体方式写入到c.txt二进制文件中
 */
int main1()
{
    stu s[5] = {
        { "李白",50,'M',"110" },
        { "李黑",20,'M',"120" },
        { "李逵",30,'M',"119" },
        { "李鬼",40,'M',"911" },
        { "李青",10,'M',"666" } };

    FILE * fp = fopen("../../c.txt", "wb");
    if (!fp)
        return -1;

    for (int i = 0; i < 5; i++){
        //fwrite(&s[i], 20, 1, fp); //一次读取20个字节
        fwrite(&s[i], sizeof(stu), 1, fp); //存储二进制文件（参阅“01块读写”）
    }

    //关闭文件
    fclose(fp);

    return EXIT_SUCCESS;
}


/**
 * 使用结构体方式读取c.txt二进制文件中
 */
int main()
{
//    printf("结构体大小：%d\n", sizeof(stu)); //40
//    return 0;
    FILE * fp = fopen("../../c.txt", "rb");
    if (!fp)
        return -1;

    //定义结构体数组（上面定义了结构体typedef）
    stu s[5];

    int i = 0;
    while (!feof(fp)){
        fread(&s[i++], sizeof(stu),1 , fp); //读取二进制文件（参阅“01块读写”）
    }

    //关闭文件
    fclose(fp);
    for (i = 0; i < 5; i++){
        printf("姓名：%s\t年龄：%d\t性别：%s\t电话：%s\n", s[i].name, s[i].age, s[i].sex == 'M' ? "男" : "女", s[i].tel);
    }

    return 0;
}
/* Output:
姓名：李白      年龄：50        性别：男        电话：110
姓名：李黑      年龄：20        性别：男        电话：120
姓名：李逵      年龄：30        性别：男        电话：119
姓名：李鬼      年龄：40        性别：男        电话：911
姓名：李青      年龄：10        性别：男        电话：666
*/