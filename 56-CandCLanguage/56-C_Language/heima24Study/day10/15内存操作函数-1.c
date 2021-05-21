#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{
    //开辟10个int类型40个字节的堆空间
    int * p = (int *)malloc(sizeof(int) * 10);

    //将一块内存区域重置为0
    //void *memset(void *s, int c, size_t n);
    //将s的内存区域的前n个字节以参数c填入
    //s：需要操作内存s的首地址
    //c：填充的字符，c虽然参数为int，但必须是unsigned char , 范围为0~255
    //n：指定需要设置的大小
    memset(p, 0, 40);
    for (int i = 0; i < 10; i++){
        printf("%d\n", p[i]); //0
    }
    /* Output:
    0
    0
    0
    0
    0
    0
    0
    0
    0
    0
    */

    //重置为A
    char * b = malloc(sizeof(char) * 10);
    memset(b, 65, 10);
    //直到打印到'\0'为止
    printf("%s\n", b); //AAAAAAAAAA\Arron?憕蕟


    //重置数组
    int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
    memset(arr, 0, 40);
    for (int i = 0; i < 10; i++){
        printf("%d\n", arr[i]);
    }
    /* Output:
    0
    0
    0
    0
    0
    0
    0
    0
    0
    0
    */
    
    //free(p);
    //system("pause");
    return EXIT_SUCCESS;
}