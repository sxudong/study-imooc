#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct stra
{
    int a;       //4   4
    float b;     //4   8
    char c;      //1   12  9
    char arr[7]; //16
    double h;    //24
}abc;

struct  strb
{
    //结构体嵌套
    struct stra abc; //12  16
    short f;         //2
    char * e;        //4
    short g;
    //double d;        //8
};


/*
    技能cd：
    skill01 10
    skill02 3
    skill03 7
*/

/*
    名称
    等级
    攻击
    技能：
*/
int main()
{
    struct strb  strbb;
    strbb.abc.h = 10.0f;
    strbb.abc.a = 100;
    printf("%d\n", strbb.abc.a); //100

    printf("%d\n", sizeof(strbb)); //40

    struct stra stra;
    printf("%d\n", sizeof(stra)); //24

    system("pause");
    return EXIT_SUCCESS;
}
/*
100
40
24
请按任意键继续. . .
*/