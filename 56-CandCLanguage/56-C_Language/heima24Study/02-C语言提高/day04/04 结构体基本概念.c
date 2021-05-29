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
}person = { "John", 100 }; //结构体初始化方式之一，这里赋值了，下面的代码就不需要赋值了


struct {
	char name[64];
	int age;
}Obama = { "Edward",99 };

void test01()
{
	//结构体初始化方式之一
	//strcpy(person.name, "Lily");
	//person.age = 100;

	printf("Name:%s Age:%d\n", person.name, person.age); //Name:John Age:100

	//在“栈”上分配空间
	struct Person p1 = { "John" , 30 };
	struct Person p2 = { "Obama", 33 };
	printf("Name:%s Age:%d\n", p1.name, p1.age); //Name:John Age:30
	printf("Name:%s Age:%d\n", p2.name, p2.age); //Name:Obama Age:33

	//将p2的值赋值给p1
	p1 = p2;
	printf("Name:%s Age:%d\n", p1.name, p1.age); //Name:Obama Age:33
	printf("Name:%s Age:%d\n", p2.name, p2.age); //Name:Obama Age:33

	struct Person p;
}


/*
* 单个结构体变量
*/
void test02()
{
	//在栈上分配结构体变量空间
	//struct Person person = { "Hanmeimei", 30 };
	//printf("Name:%s Age:%d\n",person.name,person.age);

	//在“堆”上分配结构体变量空间
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
* 多个结构体变量
*/
void test03()
{
	//在“栈”上分配结构体数组空间
	struct Person persons[] = {
		{ "aaa", 20 },
		{ "bbb", 30 },
		{ "ccc", 40 },
		{ "ddd", 50 },
		{ "eee", 60 },
		{ "fff", 70 },
	};

	int len = sizeof(persons) / sizeof(struct Person);
	printPersons(persons, len); //打印

	//在"堆"上分配结构体数组空间
	struct Person* ps = malloc(sizeof(struct Person) * 6);
	for (int i = 0; i < 6; ++i) {
		sprintf(ps[i].name, "Name_%d", i + 1);
		ps[i].age = 100 + i;
	}

	printPersons(ps, 6); //打印

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
请按任意键继续. . .
*/