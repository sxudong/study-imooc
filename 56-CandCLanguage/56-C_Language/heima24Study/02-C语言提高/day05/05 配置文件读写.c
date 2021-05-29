#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#include"ConfigFile.h"

void test()
{
	char** fileData = NULL;
	int lines = 0;
	struct ConfigInfo* info = NULL;
	//���������ļ�
	loadFile_ConfigFile("./config.ini", &fileData, &lines);
	//���������ļ�
	parseFile_ConfigFile(fileData, lines, &info);
	printf("IP:%s\n", getInfo_ConfigFile("ip", info, lines));
	printf("ppp:%s\n", getInfo_ConfigFile("ppp", info, lines));
	printf("TTT:%s\n", getInfo_ConfigFile("TTT", info, lines));

	//�ͷ�������Ϣ�ڴ�
	destroInfo_ConfigFile(info);

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
���һ���ǻ���!
key:ip val:127.0.0.1
���һ���ǻ���!
key:port val:8080
���һ���ǻ���!
key:username val:root
���һ���ǻ���!
key:password val:admin
IP:127.0.0.1
ppp:(null)
TTT:(null)
�밴���������. . .
*/