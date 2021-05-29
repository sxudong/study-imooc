#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* ��ȡ�ļ����ݴ洢�����У�����ӡ
*/

//����ļ�����
int getFileLines(FILE* file)
{
	if (NULL == file)
		return -1;

	char buf[1024] = { 0 };

	int lines = 0;

	while (fgets(buf, 1024, file) != NULL)
		++lines;

	//�ָ��ļ�ָ��ָ���ļ���ʼλ�ã�ָ���Ѿ����ļ�ĩβ������readFileData()��ȡ�������ݣ�
	fseek(file, 0, SEEK_SET);

	return lines;
}


//��ȡ�ļ�����
void readFileData(FILE* file, int lines, char** contents)
{
	if (NULL == file)
		return;

	if (NULL == contents)
		return;

	if (lines <= 0)
		return;

	//����������
	char buf[1024] = { 0 };
	int index = 0;
	while (fgets(buf, 1024, file) != NULL){
		//printf("buf:%s", buf);
		int curLineLen = strlen(buf) + 1;
		//����ǰ�з����ڴ�
		char* lineContent = malloc(sizeof(char) * curLineLen);
		//�������ݿ������ռ���
		strcpy(lineContent, buf);

		contents[index++] = lineContent; //��ֵ��2��ָ������

		memset(buf, 0, 1024);
	}

}

void showFileContents(char** contents, int lines)
{
	for (int i = 0; i < lines; ++i)
		printf("%d��:%s", i + 1, contents[i]);
	printf("\n");
}

//�ͷ��ļ������ڴ�
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
	//���ļ�
	FILE* file = fopen("./text.txt", "r");
	if (NULL == file){
		printf("���ļ�ʧ��!\n");
		return;
	}

	//ͳ���ļ�����
	int lines = 10;
	lines = getFileLines(file);
	printf("lines:%d\n", lines); //6

	//char *��һ��ָ�룬����Ҫ�ö���ָ�����
	char** pContents = malloc(sizeof(char*) * lines);
	//printf("%d\n",sizeof(char*)); //4

	//��ȡ�ļ�����
	readFileData(file, lines, pContents);

	//�ر��ļ�
	fclose(file);
	file = NULL;

	//��ӡ�ļ�����
	showFileContents(pContents, lines);

	//�ͷ��ļ�����
	freeFileSpace(pContents, lines);
}


int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
lines:6
1��:aaaaaaaaaaaaaaaaaaa
2��:bbbbbbbbbbbbbbbbbbbbbbbbbbb
3��:cccccccccc
4��:ddddddddddddddddddddddddddddddd
5��:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
6��:ffffffffffffff

�밴���������. . .
*/