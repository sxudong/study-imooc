#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/**
 * 9.3 枚举
 *
 */
enum colors
{
    red=10,bule=20,yellow=30,black=40,white=50,green=60
}clo;
/*
    插卡
    输入密码
    锁定
    取款
    查询
    退卡
    锁定解除
*/

/*
10
    移动
    攻击
    技能
    死亡
20
    亮牌子
    跳舞
*/
int main()
{
    clo = 0;
    int val;
    scanf("%d", &val);

    switch (val){
        case red:
            printf("请输入您的密码");
            clo = 1;
            printf("红色\n");
            break;
        case bule:
            printf("");
            clo = 2;
            clo = 3;
            clo = 4;
            printf("蓝色\n");
            break;
        case yellow:
            printf("黄色\n");
            break;
        case black:
            printf("黑色\n");
            break;
        case white:
            printf("白色\n");
            break;
        case green:
            printf("绿色\n");
            break;
        default:
            break;
    }

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
20
蓝色
请按任意键继续. . .
*/