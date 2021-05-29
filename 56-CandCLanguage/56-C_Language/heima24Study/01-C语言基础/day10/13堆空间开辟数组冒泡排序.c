#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <time.h>

#define MAX 10

//13.堆空间开辟数组冒泡排序
int main()
{
    //随机数种子
    srand((unsigned int)time(NULL));
    //void *malloc(size_t size)在内存的动态存储区(堆区)中分配一块长度为size字节的连续区域，用来存放类型说明符指定的类型。
    int * p = (int *)malloc(sizeof(int) * MAX); //开辟40个字节的空间

    //int len = sizeof(p)
    for (int i = 0; i < MAX; i++){
        //*(p + i) = rand() % 50; //方式一
        p[i] = rand() % 50;       //方式二
        //*p++ = rand() % 50;     //方式三不能用,没有这种写法的。
    }

    //打印随机存放在p数组中的数据（不能用方式三，方式三是指针数加加,这里会数组下标越界）
    for (int i = 0; i < MAX; i++){
        printf("排序前：\n");
        printf("%d\n", p[i]);
    }

    //冒泡排序
    for (int i = 0; i < MAX - 1; i++){
        for (int j = 0; j < MAX - i - 1; j++){
            if (p[j] > p[j + 1]){
                int temp = p[j];
                p[j] = p[j + 1];
                p[j + 1] = temp;
            }
        }
    }
    printf("排序后：\n");

    for (int i = 0; i < MAX; i++){
        printf("%d\n", p[i]);
    }

    //释放p所指向的一块内存空间
    free(p);


    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
排序前：
39
排序前：
42
排序前：
28
排序前：
15
排序前：
34
排序前：
25
排序前：
29
排序前：
8
排序前：
31
排序后：
8
13
15
25
28
29
31
34
39
42
请按任意键继续. . .
*/