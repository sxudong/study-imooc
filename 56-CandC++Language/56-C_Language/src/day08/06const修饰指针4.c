#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a = 10;
    int b = 20;
    //4、const修饰“指针类型”，也修饰“指针变量”，
    //那么不能改变指针指向的地址，也不能修改指针指向的值
    const int * const p = &a;
    //p = &b;   //不可以改变指针指向的地址
    //*p = 100; //不能改变“指针变量”指向的内存地址的值

    printf("%d\n", *p); //100
    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
10
请按任意键继续. . .
*/