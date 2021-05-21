#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//函数返回类型 char* 类型,通过数组实现
char * mystrchr(char * arr1, char ch){ //数组不用char*还不能运行了
    int i = 0;
    while (arr1[i] != '\0'){
        if (arr1[i] == ch){
            return &arr1[i]; //返回对应地址
        }
        i++;
    }
    return NULL;
}

//通过“指针”的方式实现
char * const_strchr(const char * arr, char ch){
    char* p = arr;
    while (*p != '\0'){
        if (*p == ch){
            return p;
        }
        p++;
    }
    return NULL;
}


int main()
{
    char arr1[] = "hello world";
    char ch = 'o';
    char * c = &arr1;
    printf("%d\n", *c); //104 //数组首字母是h，对应ASCII码数字是104，所以内存中值是104
    printf("%X\n", c);  //60FE98 //内存地址
    printf("%s\n", c);  //hello world //根据ASCII码转换成字符串后对应的内容

    //char* p = strchr(arr1, ch);
    //char* p = mystrchr(arr1, ch);
    char * p = const_strchr(arr1, ch);
    printf("%s\n", p); //o world  //printf()函数打印数组直到出现字符串结束符'\0'为止

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
104
60FE98
hello world
o world
请按任意键继续. . .
*/
