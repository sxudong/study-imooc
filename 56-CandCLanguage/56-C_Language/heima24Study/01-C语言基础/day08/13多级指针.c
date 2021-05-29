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

int main2()
{
    int * a = 20;
    int ** b = &a;
    printf("%d\n", a);   //20
    printf("%p\n", a);   //00000014
    printf("%p\n", *b);  //00000014  //**b存储的是*b的指针地址

    system("pause");
    return EXIT_SUCCESS;
}
