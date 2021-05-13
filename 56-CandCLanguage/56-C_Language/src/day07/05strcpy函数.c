#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main05()
{
    char arr1[] = "hello word";
    char arr2[100];

    //参数：目标字符串 源字符串
    //if (strcpy(arr2, arr1) != NULL)
    //{
    //	printf("拷贝成功！");
    //}
    //printf("%s\n", arr2); //拷贝成功！hello word


    //参数：目标字符串 源字符串 字符长度
    //注:有限拷贝不会将\0拷贝到目标字符串中
    strncpy(arr2, arr1, 20); //此时arr2=hello word
    arr2[5] = '\0'; //在数组下标5添加结束符0
    printf("%s\n", arr2);

    system("pause");
    return EXIT_SUCCESS;
}