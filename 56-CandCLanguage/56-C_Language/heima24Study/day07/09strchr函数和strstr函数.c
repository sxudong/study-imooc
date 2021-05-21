#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main09()
{
//    char arr[] = "hello";
//    char ch = 'l';
//    char *p = strchr(arr, 'l'); //这个p接收的是一个地址，返回'l'以后的字符串
//    printf("%s", p);


    char arr[] = "hee哈eello world";
    char ch = 'l';
    char ha[] = "哈哈哈哈"; //加末尾0，共9个字符
    char * p = strchr(arr, '哈');//"哈" == 哈\0
    if (strchr(arr, 104) != NULL)
    {
        printf("找到了！");
    }


    char *p1 = strstr(arr, "哈"); 
    printf("%s", p1);

    system("pause");
    return EXIT_SUCCESS;
}