#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main02()
#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main2()
{
    //char arr[] = "he\0llo";
    char arr[10];

    //�������ַ�ָ�룬��С���ļ���
    fgets(arr, 10, stdin);
	//�Զ�����
	//puts(arr);
	//printf("%s", arr);
    //�������ַ�ָ�룬��
    fputs(arr, stdout);

    system("pause");
    return EXIT_SUCCESS;
}
/* �ֶ����롰hello��:
hello
hello
�밴���������. . .
*/