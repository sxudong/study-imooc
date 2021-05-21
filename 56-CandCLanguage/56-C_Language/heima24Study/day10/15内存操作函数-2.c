#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
8.2.3 存储类型总结内存操作函数

 void *memcpy(void *dest, const void *src, size_t n);

 功能：拷贝src所指的内存内容的前n个字节到dest所值的内存地址上。
 参数：
    dest：目的内存首地址
    src： 源内存首地址，注意：dest和src所指的内存空间不可重叠
    n：   需要拷贝的字节数
 返回值：dest的首地址
 */
int main()
{
    int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
    int *p = malloc(sizeof(int) * 10); //开辟40个字节堆空间

    memcpy(p, arr, 40);
    for (int i = 0; i < 10; i++){
        printf("%d\n", p[i]);
    }

    free(p); //释放堆空间

    //拷贝的目标地址和源地址尽可能的不要冲突，可能会出现错误。
    //从数组下标2开始覆盖
    memcpy(&arr[2], arr, 20);
    for (int i = 0; i < 10; i++){
        printf("%d\n", arr[i]);
    }

    char arr1[] = { 'h','e','l','l','o' };
    char * b = malloc(100);

    memset(b, 0, 100);
    //1、函数参数不同
    //2、strcpy拷贝字符串，memcpy拷贝一块内存。
    //3、拷贝结束标志不同 strcpy以'\0'结尾，memcpy以个数为结尾
    //strcpy(b, arr1);  //hello乱码（超出界限会报错）
    memcpy(b, arr1, 5); //hello （超出界限会报错和拷贝重复的地址会报错）
    printf("%s\n", b);

    free(b); //释放堆空间
    return 0;
}
/* Output:
1
2
3
4
5
6
7
8
9
10

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

hello
*/