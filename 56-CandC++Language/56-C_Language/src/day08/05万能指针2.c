#include <stdio.h>
#include <stdlib.h>


int main()
{
    int arr[10] = {0};
    void*p=arr;
    *(int *)p = 100; //arr[0]
    *((int *)p + 1) = 200; //arr[1]
    *((int *)p + 4) = 200; //arr[4]

    for(int i=0; i<10; i++)
    {
        printf("%d\n", arr[i]);
    }

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
100
200
0
0
200
0
0
0
0
0
请按任意键继续. . .
*/