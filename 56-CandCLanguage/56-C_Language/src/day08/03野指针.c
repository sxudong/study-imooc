#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a =10;
    int* p =&a;

    //指向内存编号为100的内存地址
    //0-255都是系统保留的，可以读，也不能写
    //野指针是指向一个“未知的内存空间”，可能在读写的时候出现错误
    p = 100;
    p = 0xff00;
    
    //*p = 100; //相修改内存里的值

    printf("%d\n", *p);
    system("pause");
    return EXIT_SUCCESS;

}