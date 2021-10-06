#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 读取文件内容存储到堆中，并打印
*/

//获得文件行数
int getFileLines(FILE* file)
{
	if (NULL == file)
		return -1;

	char buf[1024] = { 0 };

	int lines = 0;

	while (fgets(buf, 1024, file) != NULL)
		++lines;

	//恢复文件指针指向文件起始位置（指针已经到文件末尾，否则readFileData()读取不到数据）
	fseek(file, 0, SEEK_SET);

	return lines;
}


//读取文件数据
void readFileData(FILE* file, int lines, char** contents)
{
	if (NULL == file)
		return;

	if (NULL == contents)
		return;

	if (lines <= 0)
		return;

	//创建缓冲区
	char buf[1024] = { 0 };
	int index = 0;
	while (fgets(buf, 1024, file) != NULL){
		//printf("buf:%s", buf);
		int curLineLen = strlen(buf) + 1;
		//给当前行分配内存
		char* lineContent = malloc(sizeof(char) * curLineLen);
		//将行数据拷贝到空间中
		strcpy(lineContent, buf);

		contents[index++] = lineContent; //赋值给2级指针数组

		memset(buf, 0, 1024);
	}

}

void showFileContents(char** contents, int lines)
{
	for (int i = 0; i < lines; ++i)
		printf("%d行:%s", i + 1, contents[i]);
	printf("\n");
}

//释放文件数据内存
void freeFileSpace(char** contents, int lines)
{
	for (int i = 0; i < lines; ++i){
		if (contents[i] != NULL){
			free(contents[i]);
			contents[i] = NULL;
		}
	}

	free(contents);
	contents = NULL;
}

void test()
{
	//打开文件
	FILE* file = fopen("./text.txt", "r");
	if (NULL == file){
		printf("打开文件失败!\n");
		return;
	}

	//统计文件行数
	int lines = 10;
	lines = getFileLines(file);
	printf("lines:%d\n", lines); //6

	//char *是一级指针，所以要用二级指针接收
	char** pContents = malloc(sizeof(char*) * lines);
	//printf("%d\n",sizeof(char*)); //4

	//读取文件内容
	readFileData(file, lines, pContents);

	//关闭文件
	fclose(file);
	file = NULL;

	//打印文件内容
	showFileContents(pContents, lines);

	//释放文件数据
	freeFileSpace(pContents, lines);
}


int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
lines:6
1行:aaaaaaaaaaaaaaaaaaa
2行:bbbbbbbbbbbbbbbbbbbbbbbbbbb
3行:cccccccccc
4行:ddddddddddddddddddddddddddddddd
5行:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
6行:ffffffffffffff

请按任意键继续. . .
*/