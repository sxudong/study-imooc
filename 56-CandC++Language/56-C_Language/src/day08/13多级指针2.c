#include <stdio.h>
#include <stdlib.h>


int main()
{
    int a =10;
    int *p = &a;
    int **pp = &p;
    int ***ppp = &pp;
    //*ppp = &pp = &p;
    //**ppp = &p = &a = **pp;  //**pp里存的值是p
    //***ppp = &a = *p = **pp; //*p里存有a的地址，**pp里存的值是p
}