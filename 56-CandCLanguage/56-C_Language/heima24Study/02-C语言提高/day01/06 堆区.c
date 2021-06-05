#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* 1. �ѵ��ڴ��Ա�ֶ����룬�ֶ��ͷš�
*/
int* getSpace()
{
	//���ļ�����׺��ΪC����".c"�����Ա���ͨ����C���Ի����ǿת
	//int* p = malloc(sizeof(int) * 5);

	//�����C++����".cpp"��������ͬ����������Ҫǿ��ת���ģ�������ֱ�Ӹ�ֵ
	int* p = (int*)malloc(sizeof(int) * 5); //�ֲ�������������ʱ�ᱻ�ͷŵ������ϵ��ڴ治�ᱻ�ͷŵ�����Ҫ�ֶ��ͷŵ���

	//�շ�ǰ�棬�����дһ���Ⱥţ��ᱨ����Ϊ���ǲ����Ա���ֵ��
	if (NULL == p)
	{
		return NULL;
	}

	int  j = 0;

	//����ʹ��ǰ��++
	//ǰ��--����Ϊ�������Լ�����++ --���ظ�ֵ��
	//����++ --�����һ���м�������ȸ�ֵ���أ��������Լ�����Ҫ���浱ǰ��״̬���أ�Ȼ��Ա�������++ --�������һ����ʱ����������������ͷš�

	//ֻҪ���������ڴ�ռ䣬����ʹ���±�ķ�ʽ�����ڴ�
	for (int i = 0; i < 5; ++i)
	{
		p[i] = 100 + i;
	}

	return p;
}

void test01()
{
	int* ret = getSpace();
	for (int i = 0; i < 5; ++i)
	{
		printf("%d ", ret[i]); //100 101 102 103 104
	}

	//������ڴ棬һ��Ҫ�ͷ�
	free(ret);
	ret = NULL;
}


/*
* 2.���������ʱ��һ��Ҫ��ʼ�����ܶ��Bug������������û�г�ʼ����ɵġ�
*/
void allocateSpace(char* memorystr)
{
	//����100���ֽڶѿռ�
	memorystr = (char*) malloc(100);
	memset(memorystr, 0, 100); //���㣬��ʼ��
	strcpy(memorystr, "hello world!"); //���������,����p�������ͷţ������ڴ�û�б��ͷţ�����ɶ����
}


/*
* ע���βθı��ǲ���Ӱ�쵽ʵ�ε�ֵ�������ٷ���allocateSpace(p)��ʵ����һ����ָ��p��
* �β�Ϊmemorystr������ʱ����p����memorystr��Ȼ��ִ��memorystr = (char*)malloc(100)��
* ��ʱ�� memorystr�����100��char�ռ䣬������Ϊ"�β�"�ı䲻��Ӱ�쵽"ʵ��"��ֵ��p��ֵ��û
* �ı䣬����NULL���������濽�����ɹ���
*/
void test02()
{
	char* p = NULL;
	printf("\np = %s\n", p); //p = (null)
	allocateSpace(p);        //���ﴫ����p����������ָ���ַ�����Դ�ӡ���ǿ�
	printf("p = %s\n", p);   //p = (null)
}
//ps: ����ƽ��ʹ��ָ��Ѳ����Ӻ����д��ݳ��������ݵ���ָ����ָ������ݣ�
//    ����ָ�뱾�����ϵ�������ͼ�ı����ָ�뱾��


/*
* ˫��ָ����÷�
* https://blog.csdn.net/gdjason/article/details/51123978
*/
//���Կ���*(*p)ָ��ָ��ı���������ָ����洢����һ��ָ��*p
void allocateSpace02(char** p)
{
	printf("%p\n", *p); //ָ���ַ��00000000

	//ʹ��һ����ʱָ�����������
	char* temp = (char*) malloc(100);  //�ı���ָ���ַ
	memset(temp, 0, 100);              //���㣬��ʼ��
	strcpy(temp, "hello world!");

	*p = temp;
}

void test03()
{
	char* p = NULL;
	printf("%p\n", p);     //ָ���ַ��00000000

	allocateSpace02(&p);

	printf("%p\n", p);     //ָ���ַ�ı䣺009B59F0
	printf("p = %s\n", p); //p = hello world!
}


int main() {

	test01();
	test02();
	test03();

	int* a = (int*) 20;
	int** b = &a;
	printf("%d\n", a);   //20
	printf("%d\n", *b);  //20
	printf("%p\n", a);   //00000014
	printf("%p\n", *b);  //00000014   //**b��洢����*b��ָ���ַ

	system("pause");
	return EXIT_SUCCESS;
}