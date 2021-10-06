#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main08()
{
    int arr[10] = { 7,4,2,3,5,8,9,6,1,10 };
    int len = sizeof(arr) / sizeof(arr[0]) - 1; // 40/4 -1

    //冒泡排序   从小到大
    //外层循环每次执行都能确定一个最大值
    for (int i = 0; i < len; i++)
    {
        //内层循环内次执行能确定两个数值中的最大值
        for (int j = 0; j < len - i; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                //两个数据交换位置
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    for (int i = 0; i < 10; i++)
    {
        printf("%d\n", arr[i]);
    }

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
1
2
3
4
5
6
7
8
9
10
请按任意键继续. . .