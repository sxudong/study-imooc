#include "ConfigFile.h"

/*
* ����ļ���Ч����
*/
int getLines_ConfigFile(FILE* file)
{

	char buf[1024] = { 0 };
	int lines = 0;
	while (fgets(buf, 1024, file) != NULL) {
		//���з���false����������while��ִ����һ��while
		if (!isValid_ConfigFile(buf))
			continue;

		memset(buf, 0, 1024);

		++lines;
	}

	//���ļ�ָ�����õ��ļ��Ŀ�ͷ
	fseek(file, 0, SEEK_SET);

	return lines;
}

/*
* ���������ļ�
*/
void loadFile_ConfigFile(const char* filePath, char*** fileData, int* line)
{

	FILE* file = fopen(filePath, "r");
	if (NULL == file)
		return;

	int lines = getLines_ConfigFile(file);

	//��ÿ�����ݿ����ڴ�
	char** temp = malloc(sizeof(char*) * lines);

	char buf[1024] = { 0 };

	int index = 0;

	while (fgets(buf, 1024, file) != NULL) {
		//���з���false����������while��ִ����һ��while
		if (!isValid_ConfigFile(buf))
			continue;

		temp[index] = malloc(strlen(buf) + 1);
		strcpy(temp[index], buf);
		++index;
		//���buf
		memset(buf, 0, 1024);
	}

	//�ر��ļ�
	fclose(file);

	*fileData = temp;
	*line = lines;
}

/*
* ���������ļ�
*/
void parseFile_ConfigFile(char** fileData, int lines, struct ConfigInfo** info)
{

	struct ConfigInfo* myinfo = malloc(sizeof(struct ConfigInfo) * lines);
	memset(myinfo, 0, sizeof(struct ConfigInfo) * lines);

	for (int i = 0; i < lines; ++i) {
		char* pos = strchr(fileData[i], ':');

		strncpy(myinfo[i].key, fileData[i], pos - fileData[i]);

		int flag = 0;
		if (fileData[i][strlen(fileData[i]) - 1] == '\n') {
			printf("���һ���ǻ���!\n");
			flag = 1;
		}

		strncpy(myinfo[i].val, pos + 1, strlen(pos + 1) - flag);

		printf("key:%s val:%s\n", myinfo[i].key, myinfo[i].val);
	}

	//�ͷ��ļ���Ϣ
	for (int i = 0; i < lines; ++i) {
		if (fileData[i] != NULL) {
			free(fileData[i]);
			fileData[i] = NULL;
		}
	}

	*info = myinfo;
}

/*
* ���ָ��������Ϣ
*/
char* getInfo_ConfigFile(const char* key, struct ConfigInfo* info, int line)
{
	for (int i = 0; i < line; ++i) {
		if (strcmp(key, info[i].key) == 0)
			return info[i].val;
	}

	return NULL;
}

/*
* �ͷ������ļ���Ϣ
*/
void destroInfo_ConfigFile(struct ConfigInfo* info)
{
	if (NULL == info)
		return;

	free(info);
	info = NULL;
}

/*
* �жϵ�ǰ���Ƿ���Ч
*/
int isValid_ConfigFile(const char* buf)
{
	if (buf[0] == '#' || buf[0] == '\n' || strchr(buf, ':') == NULL)
		return 0;

	return 1;
}