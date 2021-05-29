#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct sinfo
{
    char *name;
    int age;
}stu;


/**
 * 结构体指针
 */
int main()
{
    //现在这个stu是结构体变量
    //结构体指针 struct sinfo * s 接收一个地址。
    struct sinfo * s = &stu;

    //s->name相当于s.name（参见：3.6 运算符优先级表）
    s->name = (char *)malloc(sizeof(char) * 21); //开辟21个字符的堆空间
    strcpy(s->name, "李芮");

    s->age = 50;
    printf("%s   %d\n", s->name, s->age);

    //释放s.name堆空间
    free(s->name);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
李芮   50
请按任意键继续. . .
*/