#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a = 10;
    a = 20;
    int b = 100;
    printf("%p, %p\n", &a, &b); //打印a, b的地址: 0060FEA8, 0060FEA4

    //指针是一种数据类型，p是指针类型变量，用来指向一个变量的地址
    int* p = &a;
    p = &b;
    printf("%p\n", &b); //0060FEA4 内存地址
    printf("%X\n", p);  //60FEA4   内在地址
    printf("%d\n", *p); //100      加*取内存中的值
	printf("%s\n", p);  //d        内在值是100，转换成字符串对应ASCII码中的“d”
	
    //通过指针修改“变量”的值，改变对应内存空间的值
    *p = 200;
    printf("%d\n", b);  //100
    printf("%d\n", *p); //100  加*取内存中的值

    //sizeof()指针类型在内存中的大小
    printf("%d\n", sizeof(p));     //4 
    //在32位操作系统中所有"指针大小"都是4个字节大小
    //在内在中内在分配按无符号int来为每一个内在分配编号，2^32-1=4294967295 对应4GB内容
    //为什么32位系统只能用4G内存：https://blog.csdn.net/u011604775/article/details/81606194
    printf("int* = %d\n", sizeof(int *)); //4
    printf("char* = %d\n", sizeof(char *)); //4
    printf("short* = %d\n", sizeof(short *)); //4
    printf("long* = %d\n", sizeof(long *)); //4
    printf("float* = %d\n", sizeof(float *)); //4
    printf("double* = %d\n", sizeof(double *)); //4


    system("pause");
    return EXIT_SUCCESS;

}