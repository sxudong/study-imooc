#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
8.2.3 存储类型总结内存操作函数
 int memcmp(const void *s1, const void *s2, size_t n);

 功能：比较s1和s2所指向内存区域的前n个字节
 参数：
    s1：内存首地址1
    s2：内存首地址2
    n：需比较的前n个字节
 返回值：
    相等：=0
    大于：>0
    小于：<0
 */
int main()
{
    int arr1[10] = { 1,2,3,4,5,6,7,8,9,10 };
    int arr2[5] = { 1,2,3,4 };

    int val1 = memcmp(arr1, arr2, 20);
    printf("%d\n", val1); //1
    int val2 = memcmp(arr1, arr2, 8);
    if (val2 == 0){
        printf("前两个数组元素内容相同"); //前两个数组元素内容相同
    }else if(val2 > 0){
        printf("arr1 > arr2");
    }else{
        printf("arr1 < arr2");
    }
    printf("%d\n", val2); //0

    int * p1 = malloc(sizeof(int) * 10);   //开辟40个字节堆空间
    char * p2 = malloc(sizeof(char) * 40); //开辟40个字节堆空间

    memcpy(p1, "hello", 6);
    memcpy(p2, "hello", 6);
    if (!memcmp(p1, p2, 6)){
        printf("内容相同\n"); //内容相同
    }else{
        printf("内容不相同\n");
    }


    int a = 10;
    char b = 10;
    printf("%d\n", b); //-1
    //int类型4个字节里的前2位与char类型1个字节里的二进制比较
    if (!memcmp(&a, &b, 2)){
        printf("内容相同\n");
    }
    else{
        printf("内容不相同\n"); //内容不相同
    }
    //int类型4个字节的最低位里装着的2进制与char类型1个字节里的二进制比较
    if (!memcmp(&a, &b, 1)){
        printf("内容相同\n");  //内容相同
    }
    else{
        printf("内容不相同\n");
    }

    int a2 = 0xffff;
    char b2 = 0xffff;
    printf("%d\n", b2); //-1
    if (!memcmp(&a2, &b2, 2)){
        printf("内容相同\n");
    }else{
        printf("内容不相同\n");
    }

    if (!memcmp(&a2, &b2, 1)){
        printf("内容相同\n"); //内容相同
    }else{
        printf("内容不相同\n");
    }

    //free(p1);
    //free(p2);
    //练习   求出三名学生 三门功课成绩,并排序,通过堆空间来实现 arr[3][3];
    int ** p = (int **)malloc(sizeof(int *) * 3);
    p[0] = (int *)malloc(sizeof(int) * 3); //第一个学生
    p[1] = (int *)malloc(sizeof(int) * 3); //第二个学生
    p[2] = (int *)malloc(sizeof(int) * 3); //第三个学生

	//第一名学生学习成绩赋值
    p[0][0] = 90;
    p[0][1] = 80;
    p[0][2] = 70;

    //排序

	//释放堆空间，先释放内层，再释放外层
    free(p[0]);
    free(p[1]);
    free(p[2]);

    free(p);

    return 0;
}
/* Output:
1
前两个数组元素内容相同
0
内容相同
10
内容不相同
内容相同
-1
内容相同
内容相同
*/