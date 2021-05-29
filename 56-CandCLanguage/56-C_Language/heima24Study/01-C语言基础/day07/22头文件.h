//#pragma once //即使重包含，只包含一次，下一次不再包含
//如果版本底写下面这两句，它跟“#pragma once”功能一样
#ifndef __HEAD_FILE_H__
#define __HEAD_FILE_H__




#include<stdio.h>
#include<string.h>
#include<stdlib.h>
//extern int aaa;
//头文件作用
//1、函数、变量的声明
//2、系统库的调用
extern int max0223(int a, int b);


#endif // __HEAD_FILE_H__
