#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main3()
{
    char arr[100];
    int a, b, c;

    //1�����ջ��н��������Խ��տո�
    //scanf("%[^\n]", stdin);

    //2����scanf��ȡ����ʱ�����鲻Ҫ����κ��ַ�
    //scanf("%d %d %d", &a, &b, &c);
    /* Output:
    1
    2
    3
    1 2 3
    */

    //3�����޶��ַ���ȵĸ�ʽ��
    //scanf("%4d %4d %4d", &a, &b, &c);
    //printf("%d %d %d", a, b, c);
    /* Output:
    123456789120
    1234 5678 9120
    */

    //char arr1[100];
    //char arr2[100];
    //scanf("%1s%2s", arr1, arr2);
    //printf("%s\n", arr1);
    //printf("%s\n", arr2);
    /* Output:
     * helloworld
     * h           //��һ������arr1
     * el          //�ڶ�������arr2
     */

    //4�������ַ�����: %*d��ʾ�������֣�%*c��ʾ�����ַ�
    //scanf("%*d%s", arr);    // ����ǰ�����������
    //printf("%s\n", arr);
    /* Output:
    123dd
    dd
    */

    //scanf("%*c%s", arr);    // ���ε�һ��������ַ�
    //printf("%s\n", arr);
    /* Output:
    aa123
    a123
    */

    //5������һ������֮�ڵ��ַ���
    char ch;
    //scanf("%*[0-9]%c", &ch); //��������
    //scanf("%*[a-z]%c", &ch); //����Сд��ĸ
    //scanf("%*[123456]%c", &ch); //��������
    //printf("%c\n", ch);
    /* Output:
    1H
    H
    */


    printf("%2f\n", 3.1415); //3.141500
    printf("%5d\n", 12);     //   12
    printf("%05d\n", 12);    //00012
    //printf("%4s", "abcedf"); //abcedf�밴���������. . .
    //printf("%4s", "ab");       //  ab�밴���������. . .
    //printf("%.4s", "abcedf");  //abce�밴���������. . .
    printf("%-5d", 12);  //12   �밴���������. . .
    system("pause");
    return EXIT_SUCCESS;
}