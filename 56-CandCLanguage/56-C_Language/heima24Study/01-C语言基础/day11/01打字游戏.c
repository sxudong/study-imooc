#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <conio.h>
#include <time.h>

/**
 * 提示
 */
void tips()
{
    printf("==================打字游戏================\n");
    printf("================按任意键继续==============\n");
    printf("===============按Esc 退出游戏=============\n");
    char ch = _getch(); //接收字符
    if (ch == 27){ //ASCII码27是ESC键
        exit(0);
    }
}

/**
 * 随机数
 * @param arr
 */
void rand_ch(char * arr)
{
    //随机种子
    srand((unsigned int)time(NULL));
    for (int i = 0; i < 50; i++){
        arr[i] = rand() % 26 + 'a';
    }

}

/**
 * 输入字符
 * @param arr
 */
void print_ch(char * arr)
{
    //变量  计时器  开始 结束   计数器  val
    unsigned int start_time;
    unsigned int end_time;
    int val = 0; //正解率
    for (int i = 0; i < 50; i++){
        char ch = _getch(); //接收字符
        if (i == 0){
            start_time = time(NULL); //相当于于1970年1月1号到现在的毫秒数
        }
        if (ch == arr[i]){
            printf("%c", ch);
            val++;
        }else{
            printf("_");
        }
    }
    end_time = time(NULL);

    printf("\n用时：%d(秒)\n", end_time - start_time);
    printf("正确率：%.1f%%\n", val*1.0 / 50 * 100);
    if (val*1.0 / 50 * 100 > 80.0){
        printf("打字小能手！\n");
    }

}


int main()
{
    //字库
    char arr[51];
    memset(arr, 0, 51); //将arr的内存区域的前51个字节以参数0填入

    while (1){
        //1、提示
        tips();
        //2、随机字符
        rand_ch(arr);
        printf("%s\n", arr);
        //3、输入字符
        print_ch(arr);
    }
    return EXIT_SUCCESS;
}
/* Output:
==================打字游戏================
================按任意键继续==============
===============按Esc 退出游戏=============
qwneinxcboojqrtpulugucwctejisgtoxzjgmtavxqbxqajzom
qwneinx_boojqrtpulugucwcte_____oxz____________jzom
用时：23(秒)
正确率：64.0%
==================打字游戏================
================按任意键继续==============
===============按Esc 退出游戏=============
*/
