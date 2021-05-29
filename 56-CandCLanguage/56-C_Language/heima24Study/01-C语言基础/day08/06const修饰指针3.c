#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a = 10;
    int b = 20;
    //3、const修饰“指针变量”，能改变“指针变量”指向地址的值
    //但“不能改变”指针指向的地址
    int * const p = &a;
    //p = &b; //不可以改变指针指向的地址
    *p = 100; //能改变“指针变量”指向的内存地址的值
    
    printf("%d\n", *p); //100
    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
100
请按任意键继续. . .
*/