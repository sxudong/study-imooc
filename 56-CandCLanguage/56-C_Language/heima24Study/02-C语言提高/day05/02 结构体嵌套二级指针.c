#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Teacher
{
	char* name;       //Ƕ��һ��ָ��
	char** students;  //Ƕ�׶���ָ��(ѧ������)
};

int allocateSpace(struct Teacher*** temp)
{
	if (NULL == temp)
		return -1; //������ ��ͬ�������ʾ��ͬ����

	//�����ڴ�
	struct Teacher** ts = malloc(sizeof(struct Teacher*) * 3);
	//��ÿ����ʦ�����ڴ�
	for (int i = 0; i < 3; ++i) {
		//����ʦ�ṹ��ָ�����ռ�
		ts[i] = malloc(sizeof(struct Teacher));

		//����ʦ���ַ���ռ�
		ts[i]->name = malloc(sizeof(char) * 64);
		sprintf(ts[i]->name, "Teacher_%d", i + 1); //����ʦ������

		//����ѧ������ָ�롱�����ڴ�
		ts[i]->students = malloc(sizeof(char*) * 4);
		//��ѧ�������������ڴ� �Լ���ֵ
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
		//1.���ͷ���ʦ����
		if (teachers[i]->name != NULL) {
			free(teachers[i]->name);
			teachers[i]->name = NULL;
		}
		//2.�ͷ�ѧ������
		for (int j = 0; j < 4; ++j) {
			if (teachers[i]->students[j] != NULL) {
				free(teachers[i]->students[j]);
				teachers[i]->students[j] = NULL;
			}
		}
		//�ͷ�ѧ��������
		if (teachers[i]->students != NULL) {
			free(teachers[i]->students);
			teachers[i]->students = NULL;
		}

		//�ͷ���ʦ
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
		printf("allocateSpace �������ó���!\n");
		return;
	}

	//��ӡ��ʦ����ѧ����Ϣ
	printTeachers(teachers);

	//�ͷ��ڴ�
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
�밴���������. . .
*/