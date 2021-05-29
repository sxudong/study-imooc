#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
1、两个匹配的字符串 必须完全匹配  匹配个数 = 字符串长度
2、如果配匹一个字符串，需要记录被匹配字符串地址
3、如果匹配一半未成功 回到记录被匹配字符串地址+1
4、如果匹配的被匹配字符串的结尾  匹配个数 不等于 字符串长度
*/

//dest：目标字符串
//src:  要匹配的字符串
char * mystrstr(char * dest, char *src)
{
    int i = 0;
    int j = 0;

    //匹配个数
    int count = 0;
    int len = strlen(src);
    char * p = NULL;
    while (dest[i] != '\0'){
        //if (dest[i] == src[i]);

		//匹配个数 = 字符串长度,第一次匹配成功：l l，第二次匹配不成功：l o
		//while (dest[i] == src[j] && dest[i] != '\0') {
        while (dest[i] == src[j] && dest[i]) { // "\0"是假(false)
            if (!count){
                //如果匹配成功一个字符  需要记录位置
                p = &dest[i];
			}	
            count++;
            i++;
            j++;
            //匹配成功
            if (count == len){
                return p;
            }
        }

        //发生改变的值  i  j  count  p
        if (count < len){
            i = i - count;
            j = 0;
            //count 归 0
            count = 0;
            //continue; //或者直接跳出本次循环
        }
        i++;
    }

    //返回值结果
    //return p;
    return NULL;
}

int main()
{
    char *p = mystrstr("hello", "llo");
    printf("%s\n", p);

    system("pause");
    return EXIT_SUCCESS;
}
/*
llo
请按任意键继续. . .
*/