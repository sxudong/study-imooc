#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include<sys/types.h>
#include <sys/stat.h>
//10M大小
#define MAXSIZE 1024*1024*10


/**
 * 这个程序运行不了，获取文件属性用“指针”的方式运行不了。
 * 百度没有看到这样的写法：struct stat *s = NULL;
 */
int main05(int argc,char * argv[])
{
	unsigned int start_time = time(NULL);
	if(argc < 3){
		printf("缺少参数\n");
		return -1;
	}
	//mycp    wow.2.mp4 wow.3.mp4
	//argv[0] argv[1]   arr[2]
	FILE * fp1 = fopen(argv[1],"r");
	FILE * fp2 = fopen(argv[2],"w");
	if(!fp1 || !fp2){
		printf("操作文件失败\n");
		return -2;
	}

	//获取文件属性
	struct stat *s = NULL;
	//获取源文件
	stat(argv[1],s);
	char * ch;
	int maxSize=0;

	if(s->st_size < MAXSIZE){
		maxSize = s->st_size;
		ch = (char *)malloc(sizeof(char)*s->st_size);
	} else {
		maxSize = MAXSIZE;
		ch = (char *)malloc(sizeof(char)*MAXSIZE);
	}

	while(!feof(fp1)){
		//memset(ch,0,maxSize);
		int len = fread(ch,1,100,fp1);//123
		fwrite(ch,1,len,fp2);	
	}	

    //关闭文件
	fclose(fp1);
	fclose(fp2);

	free(ch); //释放堆内存
	unsigned int end_time=time(NULL);
	
	printf("花费时间：%d(s)\n",end_time-start_time);
	
	return 0; 

}

