#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test01()
{
	
	//char *arr[4] = { "aaa", "bbb", "ccc", "ddd" }; //�ȼ��������д��

#if 0
	char *p1 = "aaa";
	char *p2 = "bbb";
	char *p3 = "ccc";
	char *p4 = "ddd";

	char *arr[] = { p1, p2, p3, p4 };
#endif

	//���ص��ǡ���Ԫ�ء��ĵ�ַ
	char **arr = malloc(sizeof(char *)* 4);

	//����д��
	//char **arr = { "aaa", "bbb", "ccc", "ddd" };
}

void printArray1(int* arr, int len){

}
void printArray2(int (*arr)[3], int len){

}
void printArray1(int** arr, int len){

}

void test02()
{

	//����sizeof ��������ȡ��ַ����������£������κ����������������ָ����Ԫ�ء���ָ��
	int arr1[10]; //arr1 �� int*����
	printArray1(arr1,10);

	int arr2[3][3] = {
		{1,2,3},
		{4,5,6},
		{7,8,9}

	};  //arr2 ��ʲô���ͣ� int(*)[3];
	printArray2(arr2,3);

	char* arr3[] = { "aaa", "bbb", "ccc" };
	//arr3��ʲô���ͣ� ��Ԫ����char*���͵ģ�����arr3��char**����
	//printArray3(arr3,3);

    //arr4ʲô���ͣ� ����һ��һά���飬ÿ��Ԫ����char**���͵ģ�����arr4��char***���͡�
	char** arr4[3];
}

void test03()
{
	typedef int(ARRAY_TYPE)[10]; //�ñ����������飬��������Զ����
	typedef int(*ARRAY_POINTER_TYPE)[10]; //������ı���ֱ�Ӿ���һ��ָ��

	int arr[10];
	int arr2[11];
	ARRAY_TYPE *p1=  &arr;
	ARRAY_POINTER_TYPE p2 = &arr;
	//p2 = &arr2;
	int(*p3)[10] = &arr;
}

struct Person
{
	char name[64];
	int age;
};
//ֻҪ�ṹ�塰�ڲ������漰����ָ�롱ָ����ڴ棬��ôʹ��Ĭ�ϲ�����û������ġ�

struct Teacher
{
	char *name; //�漰����ָ�롱
	int age;
};

void test04()
{
    /*
    * �ṹ�帳ֵ
    * ����ṹ���ڲ���ָ�룬����ָ��ѿռ䡣��ô���������ֵ��Ϊ���ͻ�����������⣺
    * 1.ͬһ��ռ䱻�ͷ�2�Ρ�
    * 2.�ڴ�й¶
    *   �������ν�ġ��������
    */
	struct Teacher p1, p2;
	//p1 = p2;
}

int main(){

	system("pause");
	return EXIT_SUCCESS;
}