#include <stdio.h>
#include <stdlib.h>


int main()
{
    int arr[10] = {1,2,3,4,5,6,7,8,9,10};
    int* p = arr;
    p++;
    *p = 100;    //{ 1, 100,3,4,5,6,7,8,9,10 };
    p = 100; //野指针
    //*p = 100;  //非法操作野指针内存
    p = &arr[9];
    *p = 100;    //{ 1,100,3, 4,5,6,7,8,9, 100 };
    p--;
    *p = 20;     //{ 1, 100,3, 4,5,6,7,8, 20, 100 };
    p = &arr[0]; //{ 1, 100,3,4,5,6,7,8,20,100 };
    *p += 100;   //{ 101, 100,3,4,5,6,7,8,20,100 };
    printf("%d\n", p);
    p += 100;
    printf("%d\n", p);
    int len = p - arr;   //相差100个int位
    printf("%d\n", len); //100

    printf("%s\n", "##############");

    for(int i=0; i<10; i++){
        printf("%d\n", arr[i]);
    }

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
6356604
6357004
100
##############
101
100
3
4
5
6
7
8
20
100
请按任意键继续. . .
*/