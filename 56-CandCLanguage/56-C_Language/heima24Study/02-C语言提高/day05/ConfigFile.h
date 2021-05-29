#define _CRT_SECURE_NO_WARNINGS

//��ֹͷ�ļ��ظ�����
#pragma once

#include<stdio.h>
#include<string.h>
#include<stdlib.h>


struct ConfigInfo
{
	char key[64];
	char val[128];
};


//Ŀ��Ϊ����C++���ܹ�����Cд�ĺ���
#ifdef __cplusplus
	extern "C"{ //extern:�ⲿ
#endif

        /*
        * ��������Ҫ�ĺ����������� ConfigFile.c ��ʵ����Щ������
        */

		//����ļ���Ч����
		int getLines_ConfigFile(FILE *file);
		//���������ļ�
		void loadFile_ConfigFile(const char *filePath,char ***fileData,int *lines);
		//���������ļ�
		void parseFile_ConfigFile(char **fileData, int lines, struct ConfigInfo **info);
		//���ָ��������Ϣ
		char* getInfo_ConfigFile(const char *key, struct ConfigInfo *info,int line);
		//�ͷ������ļ���Ϣ
		void destroInfo_ConfigFile(struct ConfigInfo *info);
		//�жϵ�ǰ���Ƿ���Ч
		int isValid_ConfigFile(const char *buf);

#ifdef __cplusplus
	}
#endif