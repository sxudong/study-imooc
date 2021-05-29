#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stdlib.h>


int * test01()
{
    //开辟4*10=40个字节空间
    int *p = (int *)malloc(sizeof(int) * 10);
    //free(p);  //1.释放
    //p = NULL; //2.指向空（释放之后，如果这个空间没有被使用，程序就不会出问题。如果有使用，则会出问题。）
    return p;
}

/**
 * 堆空间的误区
 */
int main()
{
    free(NULL); //释放空的空间是没有错误的

    int *p = test01(); //返回指针首地址

    printf("%d\n", p);  //16977808
    printf("%d\n", !p); //0
    //如果p=null,p没有值，没有获取到空间，程序没有必要往下运行
    if (!p)
        return;

    for (int i = 0; i < 10; i++){
        p[i] = i;
    }

    for (int i = 0; i < 10; i++)
        printf("%d\n", p[i]);

    //free(p); //如果程序释放2次会报错

    printf("%d\n", p); //16977808

    //step1: 先判断，再释放
    //if (p)
    if (p != NULL) //正常写法
        //前面如果定义了p = NULL，那么p=0.如果是0，证明已经释放了。
        free(p);

    //step2: 释放完成，变成空指针。
    //free释放后但p的指向并没有变。用语句 p=NULL 才真正的把p置空。
    p = NULL;
    printf("%d\n", p); //0

    //p已经指向空，再释放不会报错。释放空的空间是没有错误的，但释放野指针的堆空间会有错误。
    free(p);
    return 0;
}
/* Output:
16977808
0

0
1
2
3
4
5
6
7
8
9

16977808
0
*/
