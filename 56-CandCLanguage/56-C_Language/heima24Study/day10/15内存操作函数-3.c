#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
8.2.3 存储类型总结内存操作函数

 memmove()功能用法和memcpy()一样，区别在于：dest和src所指的内存空间重叠时，
 memmove()仍然能处理，不过执行效率比memcpy()低些。

 */
int main()
{
    int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
    //memmove拷贝重叠内存地址不会出现问题，但是效率比较低。
    //如果拷贝源和拷贝目标没有重叠,两个函数效率一样.
    memmove(&arr[2], arr, 20);

    for (int i = 0; i < 10; i++){
        printf("%d\n", arr[i]);
    }
}
/* Output:
1
2
1
2
3
4
5
8
9
10
*/