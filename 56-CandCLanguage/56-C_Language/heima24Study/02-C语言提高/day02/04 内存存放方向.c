#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main(){

    int* p1 = 0x1234;    //һ��ָ��
    int*** p2 = 0x1111;  //����ָ��

    printf("p1 size:%d\n",sizeof(p1)); // p1 size:4
    printf("p2 size:%d\n",sizeof(p2)); // p2 size:4


    //ָ���Ǳ�����ָ�뱾��Ҳռ�ڴ�ռ䣬ָ��Ҳ���Ա���ֵ
    int a = 100;
    p1 = &a;

    //ָ���ַ��Ҫ�ö���ָ����գ�
    printf("p1 address:%p\n", &p1); // p1 address:0060FEA8
    //�ҵ���a�ĵ�ַ
    printf("p1 address:%p\n", p1);  // p1 address:0060FEA4
    printf("a address:%p\n", &a);   // a address:0060FEA4

    printf("%s\n", p1); //d

    system("pause");
    return EXIT_SUCCESS;
}