#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a = 10;
    int b = 30;
    int * p = &a;
    printf("%d\n", *p);   //10

    int ** pp = &p;
    printf("%d\n", **pp); //10
    //二级指针前 面加*代表以及指针的值
    //*pp = &a = p;
    *pp = &b;
    printf("%d\n", *p);   //30
    printf("%d\n", **pp); //30

    //二级指针前面加**代表指针指向一级指针指向地址的值
    **pp = 20;
    printf("%d\n", *p);   //20
    printf("%d\n", **pp); //20
    
    system("pause");
    return EXIT_SUCCESS;
}