#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Person
{
	char name[64];
	int age;
	int ID;
	double score;
};

//��ܵ�ַ���ݵĸ�����(��ʹ�á�����ָ�롱������£��п��������޸�����)��������Java�������ã����Ը��ݶ��������޸����ڲ�ֵ�����磺�ɱ����Date��
void PrintPerson(const struct Person* person)
//void PrintPerson(struct Person person) //Person��80���ֽڣ�ÿ�ε������������Ҫ����һ��80���ֽڣ����Բ�����ʹ�á�ֵ���ݡ����Ƽ�ʹ�á���ַ���ݡ�������������ṹ����ÿֻ����4���ֽڵ�ַ��
{
	//ʹ��const���������Է�ֹ�۸�
	//person->ID = 128;  //Name:Trump Age:30 ID:128 Score:59.900000 //�޸���ԭ���ݣ�ʹ��const���

	//������������ֹ���ģ���û�취��
	//struct Person *p = (struct Person *)person;
	//p->ID = 128;       //Name:Trump Age:30 ID:128 Score:59.900000


	printf("Name:%s Age:%d ID:%d Score:%f\n", person->name, person->age, person->ID, person->score);
	//Name:Trump Age:30 ID:250 Score:59.900000

}

void test()
{
	struct Person person = { "Trump", 30, 250, 59.9 };
	PrintPerson(&person);
}


int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/*
Name:Trump Age:30 ID:250 Score:59.900000
�밴���������. . .
*/