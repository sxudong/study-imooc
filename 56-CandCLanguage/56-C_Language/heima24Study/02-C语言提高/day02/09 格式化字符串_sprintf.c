#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
int sprintf(char *str, const char *format, ...);
	���ܣ�
	  ���ݲ���format�ַ�����ת������ʽ�����ݣ�Ȼ�󽫽�������strָ���Ŀռ��У�
	  ֱ�������ַ��������� '\0'  Ϊֹ��

	������
		str���ַ����׵�ַ
		format���ַ�����ʽ���÷���printf()һ��
	����ֵ��
		�ɹ���ʵ�ʸ�ʽ�����ַ�����
		ʧ�ܣ� - 1
*/

void test()
{

	//1. ��ʽ���ַ���
	char buf[1024] = { 0 };
	sprintf(buf, "Hello %s!", "Obama");
	printf("buf:%s\n", buf); //buf:Hello Obama!

	//2. ƴ���ַ���
	char* s1 = "hello";
	char* s2 = "world";
	memset(buf, 0, 1024);
	sprintf(buf, "%s %s", s1, s2);
	printf("buf:%s\n", buf); //buf:hello world

	//3. ����ת���ַ�����ʽ
	int number = 666;
	memset(buf, 0, 1024);
	sprintf(buf, "%d", number);
	printf("buf:%s\n", buf); //buf:666

	//4. ��ʽ�����ְ˽��� ʮ������
	memset(buf, 0, 1024);
	sprintf(buf, "%o", number);
	printf("�˽���:%s\n", buf); //�˽���:1232
	memset(buf, 0, 1024);
	sprintf(buf, "%x", number);
	printf("ʮ������:%s\n", buf); //ʮ������:29a


	char** p = malloc(sizeof(char*) * 5);
	for (int i = 0; i < 5; ++i)
	{
		p[i] = malloc(64);
		memset(p[i], 0, 64);
		sprintf(p[i], "Name_%d", i + 1); //Name_1 Name_2 Name_3 Name_4 Name_5
	}

	//��ӡ�ַ���
	for (int i = 0; i < 5; ++i)
	{
		printf("%s\n", p[i]);
	}

	//�ͷ��ڴ�
	for (int i = 0; i < 5; ++i)
	{
		if (p[i] != NULL)
		{
			free(p[i]);
			p[i] = NULL;
		}
	}

	if (p != NULL)
	{
		free(p);
		p = NULL;
	}

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
buf:Hello Obama!
buf:hello world
buf:666
�˽���:1232
ʮ������:29a
Name_1
Name_2
Name_3
Name_4
Name_5
�밴���������. . .
*/