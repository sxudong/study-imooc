#include <stdio.h>
#include <stdlib.h>

//一指针数组
int main()
{
    //存储char *类型的地址数组
    char * arr[] = { "hello", "world1", "nihao12", "baobei22" };
    int len = strlen(arr[1]);     //数组下标1的地址长度
    printf("%d\n", len);          //6
    printf ("%c\n", *(arr[1]+2)); //r

    system("pause");
    return EXIT_SUCCESS;
}