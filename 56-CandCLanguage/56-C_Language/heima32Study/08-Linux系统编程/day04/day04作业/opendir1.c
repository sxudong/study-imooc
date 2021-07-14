//目录操作测试: opendir readdir closedir
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <dirent.h>

int checkdir(char *path)
{
	//打开目录
	//DIR *opendir(const char *name);
	DIR *pDir = opendir(path);
	if(pDir==NULL){
		perror("opendir error");
		return -1;
	}

	//循环读取目录项
	//struct dirent *readdir(DIR *dirp);
	int n  = 0;
	char sFullPath[1024];
	
	struct dirent *pDent = NULL;
	while((pDent=readdir(pDir))!=NULL){
		//过滤掉.和..文件
		if(strcmp(pDent->d_name, ".")==0 || strcmp(pDent->d_name, "..")==0)
			continue;

		printf("文件名：[%s/%s]-->", path, pDent->d_name);

		//判断文件类型
		switch(pDent->d_type)
		{
			case DT_DIR:
				printf("目录文件\n");
				memset(sFullPath, 0x00, sizeof(sFullPath));
				//sprintf把数据写入字符串，而不是打印在显示器上。该函数可以把多个元素组合成一个字符串。
				sprintf(sFullPath, "%s/%s", path,pDent->d_name); 
				n+=checkdir(sFullPath); //递归调用
				break;		
				
			case DT_REG:
				printf("普通文件\n");
				n++; //统计普通文件的个数
				break;

			case DT_LNK:
				printf("链接文件\n");
				break;

			default:
				printf("未知文件\n");
		}

		printf("\n");
	}

	//关闭目录
	closedir(pDir);

	return n;
}

int main(int argc, char *argv[])
{
	int n = checkdir(argv[1]);
	printf("n==[%d]\n",n);
}


