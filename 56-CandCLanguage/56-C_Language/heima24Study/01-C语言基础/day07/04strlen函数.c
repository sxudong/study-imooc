#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main04()
{
    char arr[] = "he\nsfds\0llo";
    //char arr[] = "\0he\nsfds\0llo";
    //char arr[] = "hello";

    //char arr[] = { 'h','e','l','l','o' }; //字符串的有效长度：6
    int len = strlen(arr);
    printf("字符串的有效长度：%d\n", len);
    //printf("字符串的长度：%d", sizeof(arr));
    int index = 0;
    while (arr[index] != '\0')
    {
        index++;
    }
    printf("%d\n", index);
    system("pause");
    return EXIT_SUCCESS;
}
/* Output
字符串的有效长度：5
5
请按任意键继续. . .
*/