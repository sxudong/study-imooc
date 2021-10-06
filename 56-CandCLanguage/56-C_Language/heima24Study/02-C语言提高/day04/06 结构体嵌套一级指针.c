#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct Person
{
	char* name; //内嵌指针
	int age;
};

//分配内存
struct Person** allocateSpace()
{
    //开辟“结构体指针数组”，堆区里是3个“Person*型”的指针
	struct Person** temp = malloc(sizeof(struct Person*) * 3);

	for (int i = 0; i < 3; ++i){
	    //创建结构体内存
	    //给里面的每一个元素开辟堆空间，创建堆空间存储到temp[i]里，temp[i]里保存的是指向堆空间的指针
		temp[i] = malloc(sizeof(struct Person));
        //给“name指针”分配内存，将结构体姓名创建在堆区。
		temp[i]->name = malloc(sizeof(char) * 64);
		sprintf(temp[i]->name, "Name_%d", i + 1); //给姓名赋值
		temp[i]->age = 100 + i;
	}

	return temp;
}

//打印
void printPerson(struct Person** person)
{
	if (NULL == person)
		return;

	for (int i = 0; i < 3; ++i)
		printf("Name:%s Age:%d\n", person[i]->name, person[i]->age);
}

//释放内存
void freeSpace(struct Person** person)
{
	if (NULL == person)
		return;

	for (int i = 0; i < 3; ++i){
		if (person[i] == NULL)
			continue;
        //1.先释放"name指针"内存
		if (person[i]->name != NULL){
			printf("Name:%s的内存被释放!\n", person[i]->name);
			free(person[i]->name);
			person[i]->name = NULL;
		}
        //2.再释放“结构体数组”内存
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
Name:Name_1的内存被释放!
Name:Name_2的内存被释放!
Name:Name_3的内存被释放!
请按任意键继续. . .
*/