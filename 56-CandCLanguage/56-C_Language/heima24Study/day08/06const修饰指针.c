#include <stdio.h>
#include <stdlib.h>


int main()
{
    //这种方式不安全,可以通过“指针”修改
	//1、通过“指针”修改const修饰的常量
    const int a = 10;
    printf ("%d\n", a); //10

    int*p = &a;
    *p = 100;

    printf ("%d\n", a); //100
    printf("%d\n", *p); //100

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
10
100
100
请按任意键继续. . .
*/