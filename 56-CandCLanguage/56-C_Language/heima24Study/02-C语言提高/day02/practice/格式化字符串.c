#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void gerstring()
{
	char** pp = malloc(sizeof(char *) * 5); //char* ��һ��ָ�룬Ҫ�ö���ָ�����
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
	//����һ���ַ����鲢��ʼ��Ϊ0
	char buf[1024] = { 0 };
	memset(buf, 0, 1024);

	sprintf(buf, "%o", 10); 
	printf("%s\n", buf);

	memset(buf, 0, 1024);
	//��ʮ�������ָ�ʽ��Ϊ�˽��ƺ�ʮ������
	sprintf(buf, "ʮ����=%d �˽���=%o ʮ������=%x", 10, 10, 10);
	printf("%s\n", buf);


	int num = 666;
	memset(buf, 0, 1024);
	//���ָ�ʽ��Ϊ�ַ���
	sprintf(buf, "%d", num);

	printf("%s\n", buf);


	memset(buf, 0, 1024);
	//����Ҳ���Ը�ʽ���ַ�������
	sprintf(buf, "%s", "�����յ��磬ѧC������Ŀ࣡");
	printf("%s\n", buf);

}




int main()
{
	gerstring();
	test01();
	system("pause");

	return 0;

}