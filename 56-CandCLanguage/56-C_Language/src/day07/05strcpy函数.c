#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main05()
{
    char arr1[] = "hello word";
    char arr2[100];

    //������Ŀ���ַ��� Դ�ַ���
    //if (strcpy(arr2, arr1) != NULL)
    //{
    //	printf("�����ɹ���");
    //}
    //printf("%s\n", arr2); //�����ɹ���hello word


    //������Ŀ���ַ��� Դ�ַ��� �ַ�����
    //ע:���޿������Ὣ\0������Ŀ���ַ�����
    strncpy(arr2, arr1, 20); //��ʱarr2=hello word
    arr2[5] = '\0'; //�������±�5��ӽ�����0
    printf("%s\n", arr2);

    system("pause");
    return EXIT_SUCCESS;
}