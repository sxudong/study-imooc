#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//字符串反转
char * rec(char * arr){
    int len = strlen(arr); //11
    printf("%d\n", len);
    //字符串的首地址
    char *p1 = arr;
    //字符串最后一个有效字符的地址
    char *p2 = &arr[len - 1];
    while (p1 < p2){
        char temp = *p1;
        *p1 = *p2;
        *p2 = temp;
        p1++;
        p2--;
    }
}


int main()
{
    char arr[] = "hello world"; //dlrow olleh
    rec (arr) ;
    printf("%s\n", arr);

    system("pause");
    return EXIT_SUCCESS;
}