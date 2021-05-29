#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Person
{
	char* name; //��Ƕָ��
	int age;
};

//�����ڴ�
struct Person** allocateSpace()
{
    //���١��ṹ��ָ�����顱����������3����Person*�͡���ָ��
	struct Person** temp = malloc(sizeof(struct Person*) * 3);

	for (int i = 0; i < 3; ++i){
	    //�����ṹ���ڴ�
	    //�������ÿһ��Ԫ�ؿ��ٶѿռ䣬�����ѿռ�洢��temp[i]�temp[i]�ﱣ�����ָ��ѿռ��ָ��
		temp[i] = malloc(sizeof(struct Person));
        //����nameָ�롱�����ڴ棬���ṹ�����������ڶ�����
		temp[i]->name = malloc(sizeof(char) * 64);
		sprintf(temp[i]->name, "Name_%d", i + 1); //��������ֵ
		temp[i]->age = 100 + i;
	}

	return temp;
}

//��ӡ
void printPerson(struct Person** person)
{
	if (NULL == person)
		return;

	for (int i = 0; i < 3; ++i)
		printf("Name:%s Age:%d\n", person[i]->name, person[i]->age);
}

//�ͷ��ڴ�
void freeSpace(struct Person** person)
{
	if (NULL == person)
		return;

	for (int i = 0; i < 3; ++i){
		if (person[i] == NULL)
			continue;
        //1.���ͷ�"nameָ��"�ڴ�
		if (person[i]->name != NULL){
			printf("Name:%s���ڴ汻�ͷ�!\n", person[i]->name);
			free(person[i]->name);
			person[i]->name = NULL;
		}
        //2.���ͷš��ṹ�����顱�ڴ�
		free(person[i]);
		person[i] = NULL;
	}

	free(person);
	person = NULL;
}

void test()
{
	struct Person** person = NULL;
	person = allocateSpace();
	printPerson(person);
	freeSpace(person);
}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Name:Name_1 Age:100
Name:Name_2 Age:101
Name:Name_3 Age:102
Name:Name_1���ڴ汻�ͷ�!
Name:Name_2���ڴ汻�ͷ�!
Name:Name_3���ڴ汻�ͷ�!
�밴���������. . .
*/