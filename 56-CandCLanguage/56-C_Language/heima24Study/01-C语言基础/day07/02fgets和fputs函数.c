#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main02()
#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main2()
{
    //char arr[] = "he\0llo";
    char arr[10];

    //参数：字符指针，大小，文件流
    fgets(arr, 10, stdin);
	//自动换行
	//puts(arr);
	//printf("%s", arr);
    //参数：字符指针，流
    fputs(arr, stdout);

    system("pause");
    return EXIT_SUCCESS;
}
/* 手动输入“hello”:
hello
hello
请按任意键继续. . .
*/