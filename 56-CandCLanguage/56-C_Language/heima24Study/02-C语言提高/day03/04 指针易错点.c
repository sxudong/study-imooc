#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* �������ĳ���ڴ��ʱ������ڴ�һ��Ҫ�ǺϷ��ģ��Լ�����ģ���ʹ�õ�ʱ��û���ͷŵģ�
*/
int main() {

	char* p = malloc(64);

	++p; //�ı���ָ���ָ��free��down�����ͷ�ʱ����֪��ָ��ָ����ڴ�ռ��С�Ƕ��١�
	if (p != NULL) {
	    //free(void* _Block)�����Ĳ���������void *,�����ͣ����Կ����������Լ�ά����һ�����ݣ�
	    //��¼��pָ��ռ�Ĵ�С������������Ҫ���Ǹ������ڴ��Ƕ��
		free(p);
		p = NULL;
	}

	system("pause");
	return EXIT_SUCCESS;
}