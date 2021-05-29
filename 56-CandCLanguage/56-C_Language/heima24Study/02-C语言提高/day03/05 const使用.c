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

//规避地址传递的副作用(在使用“对象指针”的情况下，有可能意外修改数据)，类似于Java对象引用，可以根据对象引用修改其内部值，例如：可变对象Date。
void PrintPerson(const struct Person* person)
//void PrintPerson(struct Person person) //Person有80个字节，每次调用这个方法就要拷贝一份80个字节，所以不建议使用“值传递”，推荐使用“地址传递”，这样不管你结构体多大，每只传递4个字节地址。
{
	//使用const常量，可以防止篡改
	//person->ID = 128;  //Name:Trump Age:30 ID:128 Score:59.900000 //修改了原数据，使用const规避

	//如果是以下这种故意的，就没办法了
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
请按任意键继续. . .
*/