#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* ��������NULL�ͷǷ���ַ�����ڴ棺
*/
int main() {

    char *p = NULL;
    //��pָ����ڴ����򿽱�����
    strcpy(p, "1111"); //err

    char *q = 0x1122;
    //��qָ����ڴ����򿽱�����
    strcpy(q, "2222"); //err

}
