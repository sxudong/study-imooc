#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
 1. void����ֱ�Ӷ����������Ϊ��������֪����������ڴ������
    ������һ������������������Ҫ֪����������ڴ档
*/
#if 0 //0Ϊ�٣�0Ϊ�ٲ����룬Ч���൱��ע�͡�
struct Person
{
	char name[64];
	int age;
	struct Person p;
};
#endif

void test01()
{
	//void����ֱ�Ӷ����������Ϊ��������֪����������ڴ���������������ᱨ��
	//void a; 
	 
	//�������ᱨ������������Ҫ֪����������ڴ档 
	//struct Person p;
}


/*
 2. �Ժ������ص��޶����Ժ����������޶�
*/
//fun()
//{
//	return 10;
//}
int fun(void) //C++���������ͼ��
{
	return 10;
}


void test02()
{
	//printf("ret = %d\n",fun(100,200));
}


/*
* 3. void*������ָ��
* ��������ָ�������
* �κ����͵�ָ�붼���Բ�����ǿת ת����void*����
*/
void test03()
{
	void* p = NULL;


	int* pInt = NULL;
	char* pChar = (char*)pInt; //��Ҫǿת

	void* pVoid = pInt; // �κ����͵�ָ�붼���Բ�����ǿת��ת����void*����
}

//void *��Ҫ�������ݽṹ�ķ�װ





int main()
{

	test02();

	system("pause");
	return EXIT_SUCCESS;
}