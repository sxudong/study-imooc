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
    char * p = NULL;
    char * temp = src; //要匹配的字符串的临时值

    //*dest：代表一个值，"\0"是假，代表不能运行了。
    while (*dest){
        p = dest;
        //匹配个数 = 字符串长度,第一次匹配成功：l l，第二次匹配不成功：l o
        //while (*dest == *temp && *dest != '\0') {
        while (*dest == *temp && *dest){ // "\0"是假(false)
            dest++;
            temp++;
        }
        //if(*temp == '\0')
        if (!*temp) // '\0' false
            return p;
        else
            temp = src; //要查询的字符串归位，这里的重置也没有意义
        dest = p;   //重置到while进来时位置的值，这个重置没有意义
        dest++;     //目标字符串加加，进行一下轮的比对
    }

    //返回值结果
    //return p;
    return NULL;
}

int main()
{
    char *p = mystrstr("hlllooolo", "lo");
    printf("%s\n", p);

    system("pause");
    return EXIT_SUCCESS;
}
/*
looolo
请按任意键继续. . .
*/