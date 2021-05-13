#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc,char *argv[])
{
	//argc接收传递参数的个数
	//argv接受传递参数的内容
	if(argc<=1)
	{	
		printf("缺少参数\n");
		return -1;
	}
	char arr[1000];
	char temp[256];
	strcpy(arr,"gcc -o ");
	strcpy(temp,argv[1]);
	char *p = strtok(temp,".");
	strcat(arr,p);
	strcat(arr," ");
	strcat(arr,argv[1]);
	system(arr);
	//printf("%s\n",arr);		

	return 0;
}
