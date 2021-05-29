#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
8.2.3 �洢�����ܽ��ڴ��������

 void *memcpy(void *dest, const void *src, size_t n);

 ���ܣ�����src��ָ���ڴ����ݵ�ǰn���ֽڵ�dest��ֵ���ڴ��ַ�ϡ�
 ������
    dest��Ŀ���ڴ��׵�ַ
    src�� Դ�ڴ��׵�ַ��ע�⣺dest��src��ָ���ڴ�ռ䲻���ص�
    n��   ��Ҫ�������ֽ���
 ����ֵ��dest���׵�ַ
 */
int main()
{
    int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
    int *p = malloc(sizeof(int) * 10); //����40���ֽڶѿռ�

    memcpy(p, arr, 40);
    for (int i = 0; i < 10; i++){
        printf("%d\n", p[i]);
    }

    free(p); //�ͷŶѿռ�

    //������Ŀ���ַ��Դ��ַ�����ܵĲ�Ҫ��ͻ�����ܻ���ִ���
    //�������±�2��ʼ����
    memcpy(&arr[2], arr, 20);
    for (int i = 0; i < 10; i++){
        printf("%d\n", arr[i]);
    }

    char arr1[] = { 'h','e','l','l','o' };
    char * b = malloc(100);

    memset(b, 0, 100);
    //1������������ͬ
    //2��strcpy�����ַ�����memcpy����һ���ڴ档
    //3������������־��ͬ strcpy��'\0'��β��memcpy�Ը���Ϊ��β
    //strcpy(b, arr1);  //hello���루�������޻ᱨ��
    memcpy(b, arr1, 5); //hello ���������޻ᱨ��Ϳ����ظ��ĵ�ַ�ᱨ��
    printf("%s\n", b);

    free(b); //�ͷŶѿռ�
    return 0;
}
/* Output:
1
2
3
4
5
6
7
8
9
10

1
2
1
2
3
4
5
8
9
10

hello
*/