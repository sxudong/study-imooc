#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct info
{
	char name[21];
	int age;
};

void fun01(struct info s)
{
	strcpy(s.name, "李四");
	s.age = 20;

	printf("%s   %d\n", s.name, s.age);

}
void fun02(struct info *s)
{
	strcpy(s->name, "李四");
	s->age = 20;

}



int main1001()
{
	struct info s = { "张三",18 };

	//fun01(s);
	fun02(&s);

	printf("%s   %d\n", s.name, s.age);

	system("pause");
	return EXIT_SUCCESS;
}

struct info  fun03()
{
	struct info s;
	strcpy(s.name, "李四");
	s.age = 20;

	return s;

}

struct info * fun04()
{
	struct info s;
	strcpy(s.name, "李四");
	s.age = 20;

	return &s;
}

//int fun04()
//{
//	int a = 10;
//	return a;
//}
int main1002()
{
	//struct info s = fun03();
	//printf("%s   %d\n", s.name, s.age);

	//int a = fun04();

	struct info * s = fun04();
	printf("%s   %d\n", s->name, s->age);

	return 0;

}