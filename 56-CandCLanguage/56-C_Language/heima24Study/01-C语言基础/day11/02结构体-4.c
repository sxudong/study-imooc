#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


//定义结构体格式
/*
struct 结构体名称
{
    结构体成员列表
};

 //定义结构体变量
 struct 结构体名称 结构体变量名   //这就是定义了一个结构体变量
 //给结构体的变量赋值
 结构体变量名.结构体成员列表 = 值
 如果是字符串类型，需要使用strcpy()

struct 结构体名称
{
    结构体成员列表
}结构体变量名;
*/

struct students
{
    //成员列表
    char name[21];
    unsigned int age;
    char tel[16];
    float scores[3];
    char sex;
}stu = { "尼古拉斯",500,"13888888888",100.0f,200,300,'M' }; //第五种方式：结构体赋值
//}stu1={ "尼古拉斯",500,"13888888888",100.0f,200,300,'M' }, stu2={ "尼古拉斯",500,"13888888888",100.0f,200,300,'M' }; //可以定义多个

int main()
{
    printf("姓名：%s\n", stu.name);
    printf("年龄：%d\n", stu.age);
    printf("电话: %s\n", stu.tel);
    printf("成绩: %.1f   %.1f   %.1f\n", stu.scores[0], stu.scores[1], stu.scores[2]);
    printf("性别: %s\n", stu.sex == 'M' ? "男" : "女");
    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
姓名：尼古拉斯
年龄：500
电话: 13888888888
成绩: 100.0   200.0   300.0
性别: 男
请按任意键继续. . .
*/
