#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Person
{
	char name[64];
	int age;
};

void test01()
{
	struct Person person1 = { "aaa", 20 };
	struct Person person2 = { "bbb", 30 };

	//��ֵ����
	person1 = person2;  //person2������person1

	printf("Name:%s Age:%d\n", person1.name, person1.age); //Name:bbb Age:30
	printf("Name:%s Age:%d\n", person2.name, person2.age); //Name:bbb Age:30
}


struct Teacher
{
	char* name;
	int age;
};

void test02()
{
	struct Teacher teacher1;
	teacher1.name = malloc(sizeof(char) * 64); //���ٶ��ڴ�
	memset(teacher1.name, 0, 64);
	strcpy(teacher1.name, "aaa");
	teacher1.age = 20;

	struct Teacher teacher2;
	teacher2.name = malloc(sizeof(char) * 128); //���ٶ��ڴ�
	memset(teacher2.name, 0, 128);
	strcpy(teacher2.name, "bbbbbbbbbbbbb");
	teacher2.age = 30;

	printf("Name:%s Age:%d\n", teacher1.name, teacher1.age); //Name:aaa Age:20
	printf("Name:%s Age:%d\n", teacher2.name, teacher2.age); //Name:bbbbbbbbbbbbb Age:30

    //ջ�Ͽռ�һ����
	printf("teacher1 size: %d\n", sizeof(teacher1)); //teacher1 size: 8
	printf("teacher2 size: %d\n", sizeof(teacher2)); //teacher2 size: 8

	/*
	* ��ֵ����
	* ����ṹ���ڲ���ָ�룬����ָ��ѿռ䡣��ô���������ֵ��Ϊ���ͻ�����������⣺
	* 1.ͬһ��ռ䱻�ͷ�2�Ρ�
	* 2.�ڴ�й¶
	*   �������ν�ġ��������
	*/
	//��ʹ��Ĭ�ϵĽṹ�帳ֵ��Ϊ
	//teacher1 = teacher2;  //������������������teacher1.nameָ��ͬһ���ڴ��ַ�������ͷ��ڴ��ͷ���2�Ρ�teacher1.nameԭ���Ķ��ڴ�ռ�͵ò����ͷţ������ڴ�й¶��
	//����ṹ���ڲ���"ָ��"ָ�򡰶��ڴ桱����ô�Ͳ���ʹ�ñ�����Ĭ�ϵĸ�ֵ��Ϊ��Ӧ�á��ֶ����ơ���ֵ���̡�

	//----------------------------------------------

	if (teacher1.name != NULL){
		free(teacher1.name);
		teacher1.name = NULL;
	}

    //���ֶ����ơ���ֵ����
	teacher1.name = malloc(strlen(teacher2.name) + 1); //���¿��ٿռ�
	strcpy(teacher1.name, teacher2.name); //����ֵ
	teacher1.age = teacher2.age;

	//----------------------------------------------

	printf("---------------\n");
	printf("Name:%s Age:%d\n", teacher1.name, teacher1.age); //Name:bbbbbbbbbbbbb Age:30
	printf("Name:%s Age:%d\n", teacher2.name, teacher2.age); //Name:bbbbbbbbbbbbb Age:30

	//�ͷŶ��ڴ�
	if (teacher1.name != NULL){
		free(teacher1.name);
		teacher1.name = NULL;
	}

	if (teacher2.name != NULL){
		free(teacher2.name);
		teacher2.name = NULL;
	}

}


int main() {

	test01();
	printf("----------02----------\n");
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Name:bbb Age:30
Name:bbb Age:30
----------02----------
Name:aaa Age:20
Name:bbbbbbbbbbbbb Age:30
teacher1 size: 8
teacher2 size: 8
---------------
Name:bbbbbbbbbbbbb Age:30
Name:bbbbbbbbbbbbb Age:30
�밴���������. . .
*/