#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//1、“数组”作为函数参数可以退化为“指针”
//2、在传递数组时需要加上“数组的个数”

void print01(int * arr,int len)
{
    // 函数参数中如有有数组,都会转化为指针 sizeof(int *)  4
    // 所以求出来的值不能作为数组的循环条件存在
    for (int i = 0; i < len; i++)
    {
        printf("%d\n", arr[i]);
    }
}
/*
1
2
3
4
6
0
7
8
9
10
*/

void print2(char * arr)
{
    //两种方式可以求出字符串长度 \0
    int len = strlen(arr); //11
    int i = 0;
    while (arr[i] != '\0')
    {
        printf("%c\n", arr[i]);
        i++;
    }
}
/*
h
e
l
l
o

w
o
r
l
d
*/

int main()
{
    int arr[] = { 1,2,3,4,6,0,7,8,9,10 };

	//传递数组元素个数，也就是数组的长度
    print01(arr, sizeof(arr)/sizeof(arr[0])); //sizeof(int *)  4

    //system("pause");

    char arr2[] = "hello world"; //字符串
    //char arr2[] = { 'h','e','l','l','o' }; //字符数组,没有“\0”结尾
    print2(arr2);
    return EXIT_SUCCESS;
}
