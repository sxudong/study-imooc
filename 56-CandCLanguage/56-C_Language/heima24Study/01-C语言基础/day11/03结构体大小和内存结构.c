#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/**
 * 结构体需要根据数据类型进行内存对齐
 * 建议：写结构体时，按照数据类型从大到小排序。
 */
//struct stus
//{
//    char name[20];    //20
//    unsigned int age; //4
//    char tel[15];     //15
//    char sex;         //1
//    float scores[3];  //12  (如果把float类型的scores放在char类型的sex上面，结构体的大小是：56)
//}stu;
/* Output:
结构体大小52
*/

struct stus
{
    //1.调整结构体顺序前大小是：40
//    char * p;    //4
//    char arr[2]; //2  8
//    int c;       //4
//    short d;     //2  16
//    double f;    //8  24
//    long g;      //4
//    float h[2];  //8  40

    //2.调整结构体顺序后大小是：32
//    char * p;    //4
//    char arr[2]; //2  8
//    short d;     //2  16
//    int c;       //4
//    long g;      //4
//    double f;    //8  24
//    float h[2];  //8  40


    //3.调整结构体
    //按数据类型从大到小排序，结果输出是：32
    //缺点：不利于阅读。
    double f;    //8  24
    float h[2];  //8  40
    long g;      //4
    int c;       //4
    char * p;    //4
    short d;     //2  16
    char arr[2]; //2  8

    /*
    姓名：   char name[200];
    等级：   int
    当前经验：int
    攻击：   int
    防御：   int
    技能冷却：foat
    */
}stu;


int main()
{
    printf("结构体大小%d\n", sizeof(stu));

    system("pause");
    return EXIT_SUCCESS;
}
