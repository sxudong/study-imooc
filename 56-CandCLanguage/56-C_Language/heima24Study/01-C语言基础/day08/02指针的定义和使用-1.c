#include <stdio.h>
#include <stdlib.h>

/*
                             C语言中指针和取地址符&的关系
-概念定义：
    严格说起来，应该这么讲：指针存的是地址，而&运算符是取变量的地址。

-指针原理：
    其实计算机中的内存就像一个个抽屉（一兆内存就相当于1百万个抽屉），每个抽屉都有一个编号，用于存放数据。
    为了方便使用，编译器允许我们在写程序的时候，对抽屉进行命名（而不是使用抽屉的编号），这就是变量名。就
    比如说我们在程序中定义：char C; 这个时候系统会帮我们找一个空闲的抽屉（比方说编号为981的抽屉），命名
    为C，用于存放一个字符变量。以后我们在程序里只要使用C这个变量，系统就知道是要对981这个抽屉里的数据进行
    操作。

-指针是什么呢？
    指针是我们申请一个空抽屉，里面不放数据，而放编号。比如我们申请一个字符指针：char *ch＝&C; 这个时候，
    ch里面放的是C这个变量的地址（也就是981），其中&是取址符，也就是取C这个变量的地址，而不是值。*ch才是
    ch指向的值。
*/

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
    printf("%p\n", p);  //0060FEA4 内在地址

    printf("%d\n", *p); //100      加*取内存中的值
    printf("%s\n", p);  //d        内存值是100，转换成字符串对应ASCII码中的“d”

    //通过指针修改“变量”的值，改变对应内存空间的值
    *p = 200;
    printf("%d\n", b);  //100
    printf("%d\n", *p); //100  加*取内存中的值

    //sizeof()指针类型在内存中的大小
    printf("%d\n", sizeof(p));     //4
    //在32位操作系统中所有"指针大小"都是4个字节大小
    //在内在中内在分配按无符号int来为每一个内在分配编号，2^32-1=4294967295 对应4GB内容
    //为什么32位系统只能用4G内存：https://blog.csdn.net/u011604775/article/details/81606194
    printf("int* = %d\n", sizeof(int*));       //4
    printf("char* = %d\n", sizeof(char*));     //4
    printf("short* = %d\n", sizeof(short*));   //4
    printf("long* = %d\n", sizeof(long*));     //4
    printf("float* = %d\n", sizeof(float*));   //4
    printf("double* = %d\n", sizeof(double*)); //4

    system("pause");
    return EXIT_SUCCESS;

}
/* Output:
00B3FBEC, 00B3FBE0
00B3FBE0
B3FBE0
100
d
200
200
4
int* = 4
char* = 4
short* = 4
long* = 4
float* = 4
double* = 4
*/