#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Teacher
{
	char* name;       //嵌套一级指针
	char** students;  //嵌套二级指针(学生数组)
};

int allocateSpace(struct Teacher*** temp)
{
	if (NULL == temp)
		return -1; //错误码 不同错误码表示不同错误

	//开辟内存
	struct Teacher** ts = malloc(sizeof(struct Teacher*) * 3);
	//给每个老师分配内存
	for (int i = 0; i < 3; ++i) {
		//给老师结构体指针分配空间
		ts[i] = malloc(sizeof(struct Teacher));

		//给老师名字分配空间
		ts[i]->name = malloc(sizeof(char) * 64);
		sprintf(ts[i]->name, "Teacher_%d", i + 1); //给老师起名称

		//给“学生数组指针”分配内存
		ts[i]->students = malloc(sizeof(char*) * 4);
		//给学生的姓名开辟内存 以及赋值
		for (int j = 0; j < 4; ++j) {
			ts[i]->students[j] = malloc(sizeof(char) * 64);
			sprintf(ts[i]->students[j], "%s_Stu_%d", ts[i]->name, j + 1);
		}
	}

	*temp = ts;

	return 0;
}

void printTeachers(struct Teacher** teachers)
{
	if (NULL == teachers)
		return;

	for (int i = 0; i < 3; ++i) {
		printf("%s\n", teachers[i]->name);
		for (int j = 0; j < 4; ++j)
			printf("   %s\n", teachers[i]->students[j]);
	}
}


void freeSpace(struct Teacher** teachers)
{
	if (NULL == teachers)
		return;

	for (int i = 0; i < 3; ++i) {

		if (teachers[i] == NULL)
			continue;
		//1.先释放老师姓名
		if (teachers[i]->name != NULL) {
			free(teachers[i]->name);
			teachers[i]->name = NULL;
		}
		//2.释放学生姓名
		for (int j = 0; j < 4; ++j) {
			if (teachers[i]->students[j] != NULL) {
				free(teachers[i]->students[j]);
				teachers[i]->students[j] = NULL;
			}
		}
		//释放学生的数组
		if (teachers[i]->students != NULL) {
			free(teachers[i]->students);
			teachers[i]->students = NULL;
		}

		//释放老师
		if (teachers[i] != NULL) {
			free(teachers[i]);
			teachers[i] = NULL;
		}
	}

	free(teachers);
	teachers = NULL;
}

void test()
{
	struct Teacher** teachers = NULL;

	int ret = 0;
	ret = allocateSpace(&teachers);
	if (ret < 0) {
		printf("allocateSpace 函数调用出错!\n");
		return;
	}

	//打印老师及其学生信息
	printTeachers(teachers);

	//释放内存
	freeSpace(teachers);
	teachers = NULL;
}


int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Teacher_1
   Teacher_1_Stu_1
   Teacher_1_Stu_2
   Teacher_1_Stu_3
   Teacher_1_Stu_4
Teacher_2
   Teacher_2_Stu_1
   Teacher_2_Stu_2
   Teacher_2_Stu_3
   Teacher_2_Stu_4
Teacher_3
   Teacher_3_Stu_1
   Teacher_3_Stu_2
   Teacher_3_Stu_3
   Teacher_3_Stu_4
请按任意键继续. . .
*/