#pragma once
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define WORDMAX 111104


struct dicts
{
	char* word;
	char* trans;
};
typedef struct dicts dic;

void ReadFile(dic** p);
int SearchWord(char* ch, char* content, dic* p);
void clear(dic* p);
