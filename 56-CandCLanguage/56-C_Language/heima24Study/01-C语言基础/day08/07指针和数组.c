#include <stdio.h>
#include <stdlib.h>


int main()
{
    //数组名是数组的首地址这是一一个常量
    int arr[10] = { 0 };
    //printf("%p\n”，arr);
    //printf("%p\n"，&arr[0]) ;
    //p=arr; [数据类型 *]变量名
    //1、指向数组的指针,当操作指针的时候，间接操作了数组
    int* p = arr;
    for(int i=0; i<10; i++){
        printf("%d\n",p[i]); //下标0~9
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
    请按任意键继续. . .
    */

    printf("%s\n", "");

    int arr2[10] = {1,2,3,4,5,6,7,8,9,10};
    int* c = arr2;
    for(int i=0; i<10; i++){
        //*(p+i) //内存地址变成：1*sizeof(int)
        printf("%d\n", *(c + i)); //下标0~9
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
    */

    printf("%s\n", "");

    //指针的降级操作
    *p = 100;
    *(p +1) = 200;
    p[5] = 300;
    for(int i=0; i<10; i++){
        printf("%d\n",*(p + i));
    }
    /* Output:
    100
    200
    0
    0
    0
    300
    0
    0
    0
    0
    */

    printf("%s\n", "");

    int arr3[10] = {1,2,3,4,5,6,7,8,9,10};
    int* d = arr3;
    //d = d + 1; //等同于内存地址中加了一个int类型的大小
    d++;
    *d = 200;
    d[2] = 300;   //d++之后，下标0往后移了一位
    arr3[2] = 400;        
    for(int i=0; i<10; i++){
        printf("%d\n",arr3[i]); //下标0~9
    }
    /* Output:
    1
    200
    400
    300
    5
    6
    7
    8
    9
    10
    */

    system("pause");
    return EXIT_SUCCESS;
}