#define _CRT_SECURE_NO_WARNINGS
#pragma once

#include<stdlib.h>
#include<string.h>
#include<stdio.h>

/*
* 接口（接口实现在CSckImp1.c）
*/

//初始化
void init_CSckImp1(void **handle);
//发送接口
void send_CSckImp1(void *handle, unsigned char* sendData, int sendLen);
//接收接口
void recv_CSckImp1(void *handle, unsigned char* recvData, int* recvLen);
//关闭
void close_CSckImp1(void *handle);