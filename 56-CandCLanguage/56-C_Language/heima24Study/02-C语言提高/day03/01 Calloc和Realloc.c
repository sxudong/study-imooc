#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
1. calloc()

 #include <stdlib.h>
 void *calloc(size_t nmemb, size_t size);
 -���ܣ�
	 ���ڴ涯̬�洢���з���nmemb�鳤��Ϊsize�ֽڵ���������calloc�Զ���������ڴ���0��
 -������
	nmemb�������ڴ浥Ԫ����
	size��ÿ���ڴ浥Ԫ�Ĵ�С����λ���ֽڣ�
 -����ֵ��
	�ɹ�������ռ����ʼ��ַ
	ʧ�ܣ�NULL
*/
void test01()
{
	//����10��int����40���ֽڵĶѿռ�
	int* p = calloc(10, sizeof(int));
	for (int i = 0; i < 10; ++i)
		p[i] = i + 1;

	for (int i = 0; i < 10; ++i)
		printf("%d ", p[i]); //1 2 3 4 5 6 7 8 9 10


	if (p != NULL){
		free(p);  //�ͷŶѿռ�
		p = NULL; //ָ���ָ��
	}

	printf("\n");
}


/*
 2.realloc()
 #include <stdlib.h>
 void *realloc(void *ptr, size_t size);
 -���ܣ�
	 ���·�����malloc����calloc�����ڶ��з����ڴ�ռ�Ĵ�С��
	 realloc�����Զ��������ӵ��ڴ棬��Ҫ�ֶ��������ָ���ĵ�ַ�����������Ŀռ䣬
	 ��ô�ͻ������е�ַ�����������ڴ棬���ָ���ĵ�ַ����û�пռ䣬��ôrealloc��
	 ���·����µ������ڴ棬�Ѿ��ڴ��ֵ���������ڴ棬ͬʱ�ͷž��ڴ档

 -������
	ptr��Ϊ֮ǰ��malloc����calloc������ڴ��ַ������˲�������NULL����ô��realloc��malloc����һ�¡�
	size��Ϊ���·����ڴ�Ĵ�С, ��λ���ֽڡ�

 -����ֵ��
	�ɹ����·���Ķ��ڴ��ַ
	ʧ�ܣ�NULL

*/
void test02()
{
	int* p = malloc(sizeof(int) * 10);
	for (int i = 0; i < 10; ++i)
		p[i] = i + 1;

	//��ӡ
	for (int i = 0; i < 10; ++i)
		printf("%d ", p[i]); //1 2 3 4 5 6 7 8 9 10

	printf("%d\n", p);                 //12737336  #����ǰ���ڴ��ַ
	//p = realloc(p, sizeof(int) * 20);
	p = realloc(p, sizeof(int) * 200); //���·���200��int����800���ַ��ռ�
	printf("%d\n", p);                 //12758752  #�������ڴ��ַ

	//ԭ����10�����ݶ�����������
	for (int i = 0; i < 15; ++i)
		printf("%d ", p[i]); //1 2 3 4 5 6 7 8 9 10 -33686019 265257588 2082438784 16729 10312144

	printf("\n");
}


int main() {

	test01();
	printf("--------------------\n");
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1 2 3 4 5 6 7 8 9 10
--------------------
1 2 3 4 5 6 7 8 9 10 16407056
16440816
1 2 3 4 5 6 7 8 9 10 -842150451 -842150451 -842150451 -842150451 -842150451
�밴���������. . .
*/