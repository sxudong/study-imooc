#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void gerstring()
{
	char** pp = malloc(sizeof(char *) * 5); //char* 是一线指针，要用二级指针接收
	//printf("%d\n",sizeof(char*)); //4
	for (int i = 0; i < 5; ++i)
	{
		pp[i] = malloc(64);
		memset(pp[i], 0, 64);
		sprintf(pp[i], "name_%d", i+1);
	}



	for (int i = 0; i < 5; ++i)
	{
		printf("%s\n", pp[i]);
	}



	for (int i = 0; i < 5; ++i)
	{
		if (pp[i] != NULL)
		{
			free(pp[i]);
			pp[i] = NULL;
		}
	}
	free(pp);


}


void test01()
{
	//定义一个字符数组并初始化为0
	char buf[1024] = { 0 };
	memset(buf, 0, 1024);

	sprintf(buf, "%o", 10); 
	printf("%s\n", buf);

	memset(buf, 0, 1024);
	//把十进制数字格式化为八进制和十六进制
	sprintf(buf, "十进制=%d 八进制=%o 十六进制=%x", 10, 10, 10);
	printf("%s\n", buf);


	int num = 666;
	memset(buf, 0, 1024);
	//数字格式化为字符串
	sprintf(buf, "%d", num);

	printf("%s\n", buf);


	memset(buf, 0, 1024);
	//汉字也可以格式化字符数组中
	sprintf(buf, "%s", "锄禾日当午，学C真他妈的苦！");
	printf("%s\n", buf);

}




int main()
{
	gerstring();
	test01();
	system("pause");

	return 0;

}