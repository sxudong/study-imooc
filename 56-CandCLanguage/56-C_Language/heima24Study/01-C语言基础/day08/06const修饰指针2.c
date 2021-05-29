#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a = 10;
    int b = 20;
    //2、如果const修饰“int *”不能改变“指针变量”指向的内存地址的值
    //但是可以改变指针指向的地址
    const int * p;
    p = &a;
    p = &b; //改变指针指向的地址
    //*p = 100; //不能改变“指针变量”指向的内存地址的值
    printf("%d\n", *p); //100

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
20
请按任意键继续. . .
*/