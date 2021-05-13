#include <stdio.h>
#include <stdlib.h>


int main()
{
    int *p;
    //"空指针"就是指向内存编号为0的空间,操作该内存空间会报错,
    //一般情况空指针用于条件判断.
    p = NULL;
    *p = 100;
    printf("%d\n", *p);
    if(p != NULL)
    {
        //free();
    }
    
    system("pause");
    return EXIT_SUCCESS;

}