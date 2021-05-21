#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct tec
{
    char *name; //4
    int age;    //4
}t;


/**
 * 堆空间开辟结构体
 */
int main()
{
    //开辟3个tec结构体的堆空间
    struct tec * p = (struct tec *)malloc(sizeof(t) * 3);
    //p[i].name
    //struct tec ** p = (struct tec **)malloc(sizeof(struct tec *) * 3);
    //p[1]->name =
    p->name = (char *)malloc(sizeof(char) * 21); //开辟21个字节的name堆空间
    strcpy(p->name, "牛玲");

    p->age = 18;
    printf("%s   %d\n", p->name, p->age);

    //释放name堆空间
    if (p->name != NULL){
        free(p->name);
        p->name = NULL; //指向空指针
    }

    //释放“结构体”堆空间
    if (p){
        free(p);
        p = NULL; //指向空指针
    }

    //所有的指针都是4个字节
    printf("%d\n", sizeof(struct tec *));

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
牛玲   18
4
请按任意键继续. . .
*/