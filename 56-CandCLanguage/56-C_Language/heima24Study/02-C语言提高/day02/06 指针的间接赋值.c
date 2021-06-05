#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


//间接赋值三大条件
// 一个普通变量  和 指针变量   或  一个实参和一个形参
// 建立关系
// * 操作内存

void changeValue(int* p, long* l, char* letter) // int * p = &a;
{
	*p = 100; //值可以修改，指针地址不可以修改
	*l = 2;
	*letter = 'b';
}

//指针存的是地址，而&运算符是取变量的地址。
void test01()
{
	int a = 10;
	long l = 1;
	char letter = 'a';
	//char* p = "hello world!";  //字符串常量是不可以修改，存储在常量区
	//char a[] = "hello world!"; //普通数组，存储在栈中，可以修改

	changeValue(&a, &l, &letter);

	printf("%d\n", a);   //100
	printf("%d\n", l);   //2
	printf("%c\n", letter); //b

	printf("----------------\n");
}


// 这个函数在Qt编译串可以测试，VS中内存地址总是在变，没办法测试。
void test02()
{
	int b = 10;
	printf("b的内存地址：%d\n", &b); //15989896

	//只要拿到内存的地址，就可以修改内存空间的值
	*(int*) 15989896 = 100;
	printf("b = %d\n", b); //100

    //int *p = &b;
	int *p = 15989896;
	*(int*) p = 200;  //*((int*) p) = 200;  //强转为 int * 类型，加括号后加 * 指向内存。可以省略外层括号。
	printf("p = %d\n", *p); //200

	printf("----------------\n");
}


void changePointer(int** val)
{
	*val = 0x008;
}

void test03()
{
	int* p = NULL;
	changePointer(&p);

	printf("p = %x\n", p); //p = 8
}

int main() {

	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
100
2
b
----------------
b的内存地址：6356616
b = 100
p = 200
----------------
p = 8
请按任意键继续. . .
*/