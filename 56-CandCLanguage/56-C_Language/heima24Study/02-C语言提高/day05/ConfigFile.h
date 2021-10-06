#define _CRT_SECURE_NO_WARNINGS

//防止头文件重复包含
#pragma once

#include<stdio.h>
#include<string.h>
#include<stdlib.h>


struct ConfigInfo
{
	char key[64];
	char val[128];
};


//目的为了在C++中能够调用C写的函数
#ifdef __cplusplus
	extern "C"{ //extern:外部
#endif

        /*
        * 定义所需要的函数方法（在 ConfigFile.c 中实现这些方法）
        */

		//获得文件有效行数
		int getLines_ConfigFile(FILE *file);
		//加载配置文件
		void loadFile_ConfigFile(const char *filePath,char ***fileData,int *lines);
		//解析配置文件
		void parseFile_ConfigFile(char **fileData, int lines, struct ConfigInfo **info);
		//获得指定配置信息
		char* getInfo_ConfigFile(const char *key, struct ConfigInfo *info,int line);
		//释放配置文件信息
		void destroInfo_ConfigFile(struct ConfigInfo *info);
		//判断当前行是否有效
		int isValid_ConfigFile(const char *buf);

#ifdef __cplusplus
	}
#endif