#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a =10;
    int *p = &a;
    int **pp = &p;
    int ***ppp = &pp;
    //*ppp = &pp = &p;
    //**ppp = &p = &a = **pp;  // **pp 里存的值是 p
    //***ppp = &a = *p = **pp; // *p 里存有a的地址，**pp 里存的值是 p
}