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
	//加载配置文件
	loadFile_ConfigFile("./config.ini", &fileData, &lines);
	//解析配置文件
	parseFile_ConfigFile(fileData, lines, &info);
	printf("IP:%s\n", getInfo_ConfigFile("ip", info, lines));
	printf("ppp:%s\n", getInfo_ConfigFile("ppp", info, lines));
	printf("TTT:%s\n", getInfo_ConfigFile("TTT", info, lines));

	//释放配置信息内存
	destroInfo_ConfigFile(info);

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
最后一个是换行!
key:ip val:127.0.0.1
最后一个是换行!
key:port val:8080
最后一个是换行!
key:username val:root
最后一个是换行!
key:password val:admin
IP:127.0.0.1
ppp:(null)
TTT:(null)
请按任意键继续. . .
*/