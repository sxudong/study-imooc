#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 不允许向NULL和非法地址拷贝内存：
*/
int main() {

    char *p = NULL;
    //给p指向的内存区域拷贝内容
    strcpy(p, "1111"); //err

    char *q = 0x1122;
    //给q指向的内存区域拷贝内容
    strcpy(q, "2222"); //err

}
