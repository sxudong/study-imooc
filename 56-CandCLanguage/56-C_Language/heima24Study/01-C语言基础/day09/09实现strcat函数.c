#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//在字符串arr后追加字符串s1
void mystrcat(char * arr, char * s1)
{
    //方法一：
    //while (*arr)
    //	arr++;
    //while (*arr++ = *s1++);

    //方法二：
    while (*arr)
        arr++;

    while (*s1) // *s1 == '\0' 假false
    {
        *arr = *s1;
        arr++;
        s1++;
    }
    *arr = '\0'; //给数组加结束符'\0'
}

int main()
{
    char arr[100] = "hello";
    char * s1 = "world";
    mystrcat(arr, s1);
    printf("%s\n", arr); //helloworld

    //system("pause");
    return EXIT_SUCCESS;
}


