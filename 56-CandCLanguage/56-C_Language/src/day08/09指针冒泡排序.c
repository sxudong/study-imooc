#include <stdio.h>
#include <stdlib.h>

void bubble(int *p, int len){
    for (int i = 0; i < len - 1; i++){
        //内层循环内次执行能确定两个数值中的最大值
        for (int j = 0; j < len - i - 1; j++){
            //
            if (*(p + j) < *(p + j + 1)){
                //两个数据交换位置
                int temp = *(p + j);
                *(p + j) = *(p + j + 1);
                *(p + j + 1) = temp;
            }
        }
    }
}

int main()
{
    int arr[10] = {4,9,10,3,5,7,1,8,2,6};
    //数组名和指针的区别数组名通过sizeof可以求出数组大小,
    //“指针”只包含数组的首地址信息
    int *p = arr;
//    printf("%d\n", sizeof (arr)); //40
//    printf("%d\n", sizeof(p)) ;   //4
    int len = sizeof(arr)/sizeof(arr[0]); //10
    bubble(arr, len);
    for(int i=0; i<len; i++){
        printf("%d\n", arr[i]);
    }
    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
10
9
8
7
6
5
4
3
2
1
请按任意键继续. . .
*/
