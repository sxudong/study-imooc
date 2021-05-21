#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct stuinfo
{
    char *name;
    int age;
};


int main()
{
    struct stuinfo si;
    si.name = (char *)malloc(sizeof(char)* 21); //开辟name堆空间

    strcpy(si.name, "张三");
    si.age = 18;

    printf("%s   %d\n", si.name, si.age);

    free(si.name); //释放name堆空间

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
张三   18
请按任意键继续. . .
*/