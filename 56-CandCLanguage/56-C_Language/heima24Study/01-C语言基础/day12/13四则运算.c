#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/**
 * 使用结构体实现的“四则运算”
 */
struct opter
{
    int a;       //4
    int b;       //4
    char c;      //1
    float value; //4
};
typedef struct opter opt;

int main()
{
    opt * p = (opt *)malloc(sizeof(opt) * 100); //开辟100个结构体opt对象的堆空间
    FILE * fp = fopen("../../c.txt", "r+");     //r+ 以可读、可写的方式打开文件(不创建新文件)，读取"06四则运算.c"生成的c.txt文件
    if (!fp)
        return -1;

    for (int i = 0; i < 100; i++){
        //格式化读取 a c b 的值
        fscanf(fp, "%d%c%d=\n", &(p + i)->a, &p[i].c, &p[i].b);
        //printf("%d   %d\n", &(p+i).a, p[i].b);

        //计算
        switch (p[i].c){
            case '+':
                p[i].value = p[i].a + p[i].b;
                break;
            case '-':
                p[i].value = p[i].a - p[i].b;
                break;
            case '*':
                p[i].value = p[i].a * p[i].b;
                break;
            case '/':
                p[i].value = p[i].a* 1.0 / p[i].b;
                break;
        }
    }

    //关闭文件
    fclose(fp);

    fp = fopen("../../c.txt", "r+"); //r+ 以可读、可写的方式打开文件(不创建新文件)
    if (!fp)
        return -1;

    for (int i = 0; i < 100; i++)
        fprintf(fp, "%d%c%d=%.2f\n", p[i].a, p[i].c, p[i].b, p[i].value);
    fclose(fp); //关闭文件

    free(p); //释放堆空间

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
10/9=1.11
10/2=5.00
5*3=15.00
1-6=-5.00
1/7=0.14
10*10=100.00
......
*/
