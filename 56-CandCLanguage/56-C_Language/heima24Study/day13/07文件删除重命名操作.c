#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/**
 * 10.7 删除文件、重命名文件名
 */
int main()
{
    //1.删除指定文件(测试前先创建e.txt)
//    if (!remove("../../e.txt"))
//        printf("文件删除成功！\n");

    //2.文件重命名
//    if(!rename("../../e.txt", "../../eee.txt"))
//        printf("文件重命名成功！\n");

    //3.移动文件
    rename("../../eee.txt", "D://tmp/eee.txt");
    system("pause");
    return EXIT_SUCCESS;
}
