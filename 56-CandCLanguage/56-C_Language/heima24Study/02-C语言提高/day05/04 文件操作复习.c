#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test01()
{
	FILE* f = fopen("./test.txt", "r");
	if (NULL == f){
		printf("���ļ�ʧ��!\n");
		return;
	}

	char ch;

	//abcdefEOF
		  //A
#if 0
	//��ȡ��ӡ�ļ�
	while (!feof(f)){
		ch = fgetc(f);

		//ֻҪ������EOF��_flag����true
		if (feof(f)) //��������жϣ�����2������2���ո����EOF
			break;

		printf("%c", ch);
	}
	printf("\n");
#endif
	//ֻҪû�ж���EOF���ͼ�����ȡ��ӡ
	while ((ch = fgetc(f)) != EOF)
		printf("%c", ch); //��ӡ��ȡ��������
	printf("\n");

	//�ر��ļ�
	fclose(f);
	f = NULL;
}

struct Person
{
	//Ƕ��һ��ָ�룬��fread()ֻ�ǰ�nameָ��д���ļ������ˣ���������û��д���ļ�����
	//���name��һ��ָ��Ļ������ܰ�ָ��д���ļ�����ȥ���������رգ����ٴ��ļ�������ݣ����������Ѿ���ʧ�ˡ�
	char* name;
	int age;
};

void test02()
{
	//struct Person p1 = { "aaa", 20 };
}

int main() {

	test01();
	//printf("%c",EOF); //EOF:end of

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
aaaaaaaaaaaaaaaaaaaaaaaaaaaa
�밴���������. . .
*/