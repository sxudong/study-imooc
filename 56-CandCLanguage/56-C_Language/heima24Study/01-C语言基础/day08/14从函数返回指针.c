#include <stdio.h>
#include <time.h>
#include <stdlib.h>

/* 要生成和返回随机数的函数 */
int* getRandom()
{
    static int  r[10];
    int i;

    /* 设置种子 */
    srand((unsigned)time(NULL));
    for (i = 0; i < 10; ++i)
    {
        r[i] = rand();
        printf("%d\n", r[i]);
    }

    return r;
}

/* 要调用上面定义函数的主函数 */
int main()
{
    /* 一个指向整数的指针 */
    int* p;
    int i;

    p = getRandom();
    for (i = 0; i < 10; i++)
    {
        printf("*(p + [%d]) : %d\n", i, *(p + i));
    }

    return 0;
}
/* Output:
25554
15109
4757
15961
1508
26668
2632
11784
13760
21024
*(p + [0]) : 25554
*(p + [1]) : 15109
*(p + [2]) : 4757
*(p + [3]) : 15961
*(p + [4]) : 1508
*(p + [5]) : 26668
*(p + [6]) : 2632
*(p + [7]) : 11784
*(p + [8]) : 13760
*(p + [9]) : 21024
*/