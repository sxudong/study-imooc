#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a = 10;
    int b = 20;
    int c = 30;
    int * arr[] = { &a, &b,&c };
    //arr[0]==&a;
    //arr[1]==&b;

    //arr[0]==&a，在地址前面加*就是值
    *arr[0] = 100;  //修改下标为0的的地址值
    printf("%d\n", a); //100
    printf("%d\n", b); //20
    printf("%d\n", c); //30

    system("pause");
    return EXIT_SUCCESS;
}
