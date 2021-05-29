#include<stdlib.h>

/*
 * 只能使用QT编译器测试
 */

void func()
{
    printf("hello world!");
    printf("\n");
}

/*
* "函数名"其实就是函数的"入口地址"
*/
int main() {

    //先运行记录下地址，然后放到第二条代码上测试
    printf("函数入口地址：%d\n", func);

    int* funcAddr = (int *) 4199984;
    //int* funcAddr = (int *) func;  //也行
    //int* funcAddr = (int *) &func;

    void(*myfunc)() = funcAddr;
    myfunc(); //通过函数地址来执行方法

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
函数入口地址：4199984
hello world!
请按任意键继续. . .
*/