#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main3()
{
    char arr[100];
    int a, b, c;

    //1、接收换行结束，可以接收空格
    //scanf("%[^\n]", stdin);

    //2、在scanf获取数据时，建议不要添加任何字符
    //scanf("%d %d %d", &a, &b, &c);
    /* Output:
    1
    2
    3
    1 2 3
    */

    //3、有限定字符宽度的格式化
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
     * h           //第一个数组arr1
     * el          //第二个数组arr2
     */

    //4、屏蔽字符类型: %*d表示屏蔽数字，%*c表示屏蔽字符
    //scanf("%*d%s", arr);    // 屏蔽前面输入的数字
    //printf("%s\n", arr);
    /* Output:
    123dd
    dd
    */

    //scanf("%*c%s", arr);    // 屏蔽第一个输入的字符
    //printf("%s\n", arr);
    /* Output:
    aa123
    a123
    */

    //5、屏蔽一个区间之内的字符串
    char ch;
    //scanf("%*[0-9]%c", &ch); //屏蔽数字
    //scanf("%*[a-z]%c", &ch); //屏蔽小写字母
    //scanf("%*[123456]%c", &ch); //屏蔽数字
    //printf("%c\n", ch);
    /* Output:
    1H
    H
    */


    printf("%2f\n", 3.1415); //3.141500
    printf("%5d\n", 12);     //   12
    printf("%05d\n", 12);    //00012
    //printf("%4s", "abcedf"); //abcedf请按任意键继续. . .
    //printf("%4s", "ab");       //  ab请按任意键继续. . .
    //printf("%.4s", "abcedf");  //abce请按任意键继续. . .
    printf("%-5d", 12);  //12   请按任意键继续. . .
    system("pause");
    return EXIT_SUCCESS;
}