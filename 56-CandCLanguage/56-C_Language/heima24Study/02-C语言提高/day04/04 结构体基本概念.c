#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#if 0

typedef struct Person
{
	char name[64];
	int age;
}MyPerson;
typedef struct Person MyPerson;

#endif


struct Person
{
	char name[64];
	int age;
}person = { "John", 100 }; //�ṹ���ʼ����ʽ֮һ�����︳ֵ�ˣ�����Ĵ���Ͳ���Ҫ��ֵ��


struct {
	char name[64];
	int age;
}Obama = { "Edward",99 };

void test01()
{
	//�ṹ���ʼ����ʽ֮һ
	//strcpy(person.name, "Lily");
	//person.age = 100;

	printf("Name:%s Age:%d\n", person.name, person.age); //Name:John Age:100

	//�ڡ�ջ���Ϸ���ռ�
	struct Person p1 = { "John" , 30 };
	struct Person p2 = { "Obama", 33 };
	printf("Name:%s Age:%d\n", p1.name, p1.age); //Name:John Age:30
	printf("Name:%s Age:%d\n", p2.name, p2.age); //Name:Obama Age:33

	//��p2��ֵ��ֵ��p1
	p1 = p2;
	printf("Name:%s Age:%d\n", p1.name, p1.age); //Name:Obama Age:33
	printf("Name:%s Age:%d\n", p2.name, p2.age); //Name:Obama Age:33

	struct Person p;
}


/*
* �����ṹ�����
*/
void test02()
{
	//��ջ�Ϸ���ṹ������ռ�
	//struct Person person = { "Hanmeimei", 30 };
	//printf("Name:%s Age:%d\n",person.name,person.age);

	//�ڡ��ѡ��Ϸ���ṹ������ռ�
	struct Person* person = malloc(sizeof(struct Person));
	strcpy(person->name, "Lilei");
	person->age = 30;

	printf("Name:%s Age:%d\n", person->name, person->age); //Name:Lilei Age:30

}

void printPersons(struct Person* persons, int len)
{
	for (int i = 0; i < len; ++i) {
		printf("Name:%s Age:%d\n", persons[i].name, persons[i].age);
	}
}

/*
* ����ṹ�����
*/
void test03()
{
	//�ڡ�ջ���Ϸ���ṹ������ռ�
	struct Person persons[] = {
		{ "aaa", 20 },
		{ "bbb", 30 },
		{ "ccc", 40 },
		{ "ddd", 50 },
		{ "eee", 60 },
		{ "fff", 70 },
	};

	int len = sizeof(persons) / sizeof(struct Person);
	printPersons(persons, len); //��ӡ

	//��"��"�Ϸ���ṹ������ռ�
	struct Person* ps = malloc(sizeof(struct Person) * 6);
	for (int i = 0; i < 6; ++i) {
		sprintf(ps[i].name, "Name_%d", i + 1);
		ps[i].age = 100 + i;
	}

	printPersons(ps, 6); //��ӡ

}
int main() {

	test01();
	printf("-------------------\n");
	test02();
	printf("-------------------\n");
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Name:John Age:100
Name:John Age:30
Name:Obama Age:33
Name:Obama Age:33
Name:Obama Age:33
-------------------
Name:Lilei Age:30
-------------------
Name:aaa Age:20
Name:bbb Age:30
Name:ccc Age:40
Name:ddd Age:50
Name:eee Age:60
Name:fff Age:70
Name:Name_1 Age:100
Name:Name_2 Age:101
Name:Name_3 Age:102
Name:Name_4 Age:103
Name:Name_5 Age:104
Name:Name_6 Age:105
�밴���������. . .
*/