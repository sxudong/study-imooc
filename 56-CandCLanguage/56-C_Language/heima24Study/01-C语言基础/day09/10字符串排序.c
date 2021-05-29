#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


//字符串排序 —— 根据字符串首字符，按照a-z的顺序排序。
//例如“student tree new bee”排序后得“bee new student tree”

void bubble(char** arr, int len)
{
    //冒泡排序
    for (int i = 0; i < len - 1; i++){ // 数组下标0~3
        for (int j = 0; j < len - i - 1; j++){
            //比对两个字符串的首字母
            //1、指针判断
            //if (**(arr + j) < **(arr + j + 1)){
            //	char * temp = *(arr+j);
            //	*(arr + j) = *(arr + j + 1);
            //	*(arr + j + 1) = temp;
            //}

            //2、数组判断
            //if (arr[j][0] > arr[j+1][0]){
            //	char * temp = arr[j];
            //	arr[j] = arr[j+1];
            //	arr[j + 1] = temp;
            //}

            //3、混合判断
            if (*arr[j] > *arr[j + 1]){
                char * temp = arr[j];
                arr[j] = arr[j+1];
                arr[j + 1] = temp;
            }
        }
    }
}

int main()
{
    char* arr[] = { "student", "tree", "new", "bee" };

    //把它想象成一个二维数组。
    /*arr[0][0]
    student //arr[0]
    tree    //arr[1]
    new     //arr[2]
    bee     //arr[3]
    */
    printf("%c\n", arr[0][0]); //s
    printf("%c\n", arr[1][0]); //t
    printf("%c\n", arr[2][0]); //n
    printf("%c\n", arr[3][0]); //b

    //因为这里定义的是 char* 数组(一级指针)，所以bubble函数要用 char** arr(二级指针)接收，才能对应得上。
    //一级指针形参接收0级指针实参，二级指针形参接收一级指针的实参，以此类推
    bubble(arr, 4); //bubble(&arr, 4); 这种写法也行
    for (int i = 0; i < 4; i++){
        printf("%s\n", arr[i]);
    }
    system("pause");
    return EXIT_SUCCESS;
}
/*
s
t
n
b
bee
new
student
tree
请按任意键继续. . .
*/