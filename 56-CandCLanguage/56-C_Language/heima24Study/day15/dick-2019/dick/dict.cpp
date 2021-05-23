#define _CRT_SECURE_NO_WARNINGS
#include "dict.h"



////全局变量
//dic * p;

//1、打开文件 存储数据
void ReadFile(dic** p)
{
	//开辟堆空间
	//*p = (dic*)malloc(sizeof(dic)*WORDMAX);//  realloc()  链表
	*p = (dic*)malloc(sizeof(dic) * WORDMAX);

	//读取文件内容
	FILE* fp = fopen("D:\\tmp\\dict.txt", "r");
	if (!fp){
		//return -1;
		printf("未读取到密码文件，请检查路径！\n");
		printf("程序将退出。");
		exit (-1);
	}
	int i = 0;
	char buf[1024];
	while (!feof(fp))
	{
		memset(buf, 0, 1024);
		fgets(buf, 1024, fp);

		//格式化操作
		//buf[strlen(buf) - 1] = '\0';
		for (int i = strlen(buf); i > 0; i--)
		{
			if (buf[i] == '\n')
			{
				buf[i] = '\0';
				break;
			}
		}

		//开辟堆空间
		(*p + i)->word = (char*)malloc(strlen(buf) + 1);
		memset((*p + i)->word, 0, strlen(buf) + 1);
		strcpy((*p + i)->word, &buf[1]);//#abc\n

		memset(buf, 0, 1024);
		fgets(buf, 1024, fp);
		(*p + i)->trans = (char*)malloc(strlen(buf) + 1);
		memset((*p + i)->trans, 0, strlen(buf) + 1);
		strcpy((*p + i)->trans, buf);
		i++;
	}


	fclose(fp);
}

//2、文件查找
//ch 输入单词
//content 单词对应的翻译
int SearchWord(char* ch, char* content, dic* p)
{
	memset(content, 0, 1024);
	for (int i = 0; i < WORDMAX; i++)
	{
		if (!strcmp(ch, p[i].word))
		{
			printf("%s\n", p[i].trans);
			return 1;
		}
	}
	return 0;
}


//3、释放
void clear(dic* p)
{
	for (int i = 0; i < WORDMAX; i++)
	{
		free(p[i].word);
		free(p[i].trans);
	}
	free(p);
}


int main()
{
	dic* p;
	//读取文件
	ReadFile(&p);


	//单词翻译：
	char content[1024];

	char ch[1024];

	while (1)
	{
		//fgets(ch, 1024, stdin);
		gets_s(ch); //VisualStudio2019已经废弃gets()函数

		if (!strncmp("comm=exit", ch, 9))
		{
			break;
		}
		//结果判断
		int flag = SearchWord(ch, content, p);
		if (flag)
			printf("%s\n", content);
		else
			printf("未找到该单词的解释！\n");
	}

	//释放堆空间
	clear(p);

	return EXIT_SUCCESS;
}