#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct stu
{
    //成员列表
    char name[21];
    unsigned int age;
    char tel[16];
    float scores[3]; //scores[0]
    char sex;
};

int main()
{
    /**
     * 定义结构体数组
     */
    struct stu  s[2];
    for (int i = 0; i < 2; i++){
        printf("请您输入 姓名  年龄  电话  成绩1 成绩2 成绩3 性别:\n");
        scanf("%s%d%s%f%f%f,%c", s[i].name, &s[i].age, s[i].tel, &s[i].scores[0], &s[i].scores[1], &s[i].scores[2], &s[i].sex);
    }

    for (int i = 0; i < 2; i++){
        printf("姓名：%s\n", s[i].name);
        printf("年龄：%d\n", s[i].age);
        printf("电话: %s\n", s[i].tel);
        printf("成绩: %.1f   %.1f   %.1f\n", s[i].scores[0], s[i].scores[1], s[i].scores[2]);
        printf("性别: %s\n", s[i].sex == 'M' ? "男" : "女");
    }

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
请您输入 姓名  年龄  电话  成绩1 成绩2 成绩3 性别:
Lucy 18 13145679876 90 100 99,F
请您输入 姓名  年龄  电话  成绩1 成绩2 成绩3 性别:
Cici 20 13545671234 100 100 100,M
姓名：Lucy
年龄：18
电话: 13145679876
成绩: 90.0   100.0   99.0
性别: 女
姓名：Cici
年龄：20
电话: 13545671234
成绩: 100.0   100.0   100.0
性别: 男
请按任意键继续. . .
*/