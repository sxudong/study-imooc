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
* 1. ������������������һ�������ġ�������
*/
void doLogic(int(*pFunc) (int, int))
{
	int a = 10;
	int b = 20;
	int ret = pFunc(a, b);
	printf("ret = %d\n", ret); //ret = 227
}


/*
* 2. ����ָ������
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
	* ���塰����ָ�����顱
	*     void������ֵ����
	*     func_array������������
	*     ()�������б�
	*     [3]����������
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

	doLogic(con5); //����������ֻ�к����������ı仯���������������û�䡣�������á�
}


/*
* ������ָ�롱���������� ���� �ص�����
*
*  arr�������׵�ַ
*  eleSize��ÿһ��Ԫ�ش�С��ÿ��Ԫ��ռ�����ֽڣ�
*  len��Ԫ�ظ���
*  void(*print)(void*)���û��Զ��庯������ָ��
*/
void printAllArray(void* arr, int eleSize, int len, void(*print)(void*)) //void:�޷���ֵ��print���Զ���ĺ�����������void*��:����������
{
	//��ΪeleSize���ֽڴ�С����������ҪǿתΪchar*�����������ֽ�ƫ����
	char* start = (char*)arr;

	for (int i = 0; i < len; ++i) {
		//printf("%d\n", start + (i * eleSize)); //ÿ��Ԫ���׵�ַ
		char* eleAddr = start + (i * eleSize);
		//int* p = (int *)eleAddr;
		//printf("%d ", *p); //1 2 3 4 5
		print(eleAddr);
	}
	printf("\n");
}

//C���Բ�֧�ֺ������أ�C�����еĺ��������ܹ���ͬ
void MyPrint(void* data)
{
	int* p = (int*) data;
	printf("%d ", *p); //��ӡ�ڴ����ֵ
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

	struct Person persons[] = { //����ṹ������
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

�밴���������. . .
*/