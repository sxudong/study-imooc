#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Person
{
	char mName[64];
	int mAge;
};

void PersonEat(struct Person *p)
{
	printf("%s �ڳ��˷� \n",p->mName);
}

void test01()
{
	struct Person p1;
	strcpy(p1.mName, "��������");

	PersonEat(&p1); //�������� �ڳ��˷�
}


struct Dog
{
	char mName[64];
	int mAge;
};

void DogEat(struct Dog * dog)
{
	printf("%s �ڳԹ��� \n", dog->mName);
}

void test02()
{
	struct Dog d;
	strcpy(d.mName, "����");

	DogEat(&d); //���� �ڳԹ���

	struct Person p1;
	strcpy(p1.mName, "����");

	DogEat(&p1); //���� �ڳԹ���

}
/*
* ���ۣ�C���Է�װ ���Ժ���Ϊ�ֿ�������,���ͼ�ⲻ��
*/


int main(){
	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�������� �ڳ��˷�
���� �ڳԹ���
���� �ڳԹ���
�밴���������. . .
*/
