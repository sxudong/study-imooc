#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int arr[10];

int con1(int a, int b)
{
	return a + b;
}

int con2(int a, int b)
{
	return a + b + 10;
}

int con3(int a, int b)
{
	return a + b - 10;
}

int con4(int a, int b)
{
	return a * b - 10;
}

int con5(int a, int b)
{
	return a + b - 3 + 100 * 2;
}

/*
* 1. “函数”可以做另外一个函数的“参数”
*/
void doLogic(int(*pFunc) (int, int))
{
	int a = 10;
	int b = 20;
	int ret = pFunc(a, b);
	printf("ret = %d\n", ret); //ret = 227
}


/*
* 2. 函数指针数组
*/
void func1()
{
	printf("func1\n");
}

void func2()
{
	printf("func2\n");
}

void func3()
{
	printf("func3\n");
}

void test03()
{
	/*
	* 定义“函数指针数组”
	*     void：返回值类型
	*     func_array：函数变量名
	*     ()：参数列表
	*     [3]：数组容量
	*/
	void(*func_array[3])();
	func_array[0] = func1;
	func_array[1] = func2;
	func_array[2] = func3;

	for (int i = 0; i < 3; ++i) {
		func_array[i]();
	}
}

void test02()
{
	//int(*pFunc)(int, int) = con1;
	//int ret = pFunc(10, 20);
	//printf("ret = %d\n", ret); //ret = 30

	doLogic(con5); //传函数名，只有函数名发生的变化，里面的其它代码没变。代码重用。
}


/*
* “函数指针”做函数参数 —— 回调函数
*
*  arr：数组首地址
*  eleSize：每一个元素大小（每个元素占多少字节）
*  len：元素个数
*  void(*print)(void*)：用户自定义函数名的指针
*/
void printAllArray(void* arr, int eleSize, int len, void(*print)(void*)) //void:无返回值，print：自定义的函数变量，（void*）:参数无类型
{
	//因为eleSize是字节大小，所以这里要强转为char*类型来计算字节偏移量
	char* start = (char*)arr;

	for (int i = 0; i < len; ++i) {
		//printf("%d\n", start + (i * eleSize)); //每个元素首地址
		char* eleAddr = start + (i * eleSize);
		//int* p = (int *)eleAddr;
		//printf("%d ", *p); //1 2 3 4 5
		print(eleAddr);
	}
	printf("\n");
}

//C语言不支持函数重载，C语言中的函数名不能够相同
void MyPrint(void* data)
{
	int* p = (int*) data;
	printf("%d ", *p); //打印内存里的值
}


struct Person
{
	char name[64];
	int age;
};


void MyPrintPerson(void* data)
{
	struct Person* person = (struct Person*) data;
	printf("Name:%s Age:%d\n", person->name, person->age);
}


void test04()
{
	int arr[] = { 1, 2, 3, 4, 5 };
	printAllArray(arr, sizeof(int), 5, MyPrint);

	struct Person persons[] = { //定义结构体数组
		{ "aaa", 10 },
		{ "bbb", 20 },
		{ "ccc", 30 },
		{ "ddd", 40 },
		{ "eee", 50 },
	};

	printAllArray(persons, sizeof(struct Person), 5, MyPrintPerson);
}


int main() {

	test02();
	printf("-------------------\n");
	test03();
	printf("-------------------\n");
	test04();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 227
-------------------
func1
func2
func3
-------------------
1 2 3 4 5
Name:aaa Age:10
Name:bbb Age:20
Name:ccc Age:30
Name:ddd Age:40
Name:eee Age:50

请按任意键继续. . .
*/