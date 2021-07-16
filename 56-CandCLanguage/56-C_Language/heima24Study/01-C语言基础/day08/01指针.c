#include <stdio.h>

int main()
{
    int var_runoob = 10;
    int* p;              // 定义指针变量
    p = &var_runoob;

    printf("var_runoob 变量的地址： %p\n", p);
    printf("var_runoob 变量的值： %d\n", *p);
    return 0;
}
/*Output:
var_runoob 变量的地址： 006FFD78
var_runoob 变量的值： 10
*/