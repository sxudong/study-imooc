#include <stdio.h>
#include <stdlib.h>


int main()
{
    int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
    int *p;
    p = &arr[9];
    int len = p - arr; //9
    printf("%d\n", len);

    printf("%s\n", "");

    for (p=arr; p < &arr[10]; p++){
        //printf("%d\n", *p);
        //printf("%d\n”，p);
        printf("%d\n", p[0]);
    }

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
9

1
2
3
4
5
6
7
8
9
10
请按任意键继续. . .
*/