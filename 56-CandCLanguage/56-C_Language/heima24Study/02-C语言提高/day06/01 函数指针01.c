#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int arr[10];

/*
* �����ĺ���������Ӧ���ǣ������ķ���ֵ  �����Ĳ����б�
*/

void func() //func��������ʵ�Ǵ���������ڵ�ַ
{
	printf("hello world!");
}


//���ȥ����һ��ָ������ָ��
int myfunc(int a, char b)
{
	printf("int myfunc(int a,char b) !\n");
	return 0;
}

void test01()
{
	/*
	* 1.���塰�������͡���ͨ�������͡������塰����ָ�롱
	*/
	typedef int(FUN_TYPE)(int, char);  //int myfunc(int a, char b)
	FUN_TYPE* pFunc = myfunc;

	pFunc(10, 'a');    //����myfunc()����
	(*pFunc)(20, 'b'); //����myfunc()����
	myfunc(30, 'c');   //�������ú���������


	/*
	* 2. ֱ�Ӷ��塰����ָ�����͡�
	*/
	typedef int(*FUNC_P)(int, char);  //int myfunc(int a, char b)
	FUNC_P pFunc2 = myfunc;
	pFunc2(20, 'd'); //����myfunc()����

	//����������ָ�롱��Ҫָ��ͬ����
	//pFunc2 = func;  //����ʱ����


	/*
	* 3. ֱ�Ӷ��塰����ָ�������
	*/
	//��"ָ��"ת��Ϊ"����ָ��"����д��
	int(*pFunc3)(int, char) = (int(*)(int, char))NULL;  //int myfunc(int a, char b)
	pFunc3 = myfunc;
	pFunc3(50, 'p'); //����myfunc()����

	printf("pFunc3 size:%d\n", sizeof(pFunc3)); //4  �κ�ָ�붼��4���ֽ�

	//����0x001�Ǻ�����ַ������ת��Ϊ������ָ�����͡������£�
	//(int(*)(int,int)) 0x001;
}


int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
int myfunc(int a,char b) !
int myfunc(int a,char b) !
int myfunc(int a,char b) !
int myfunc(int a,char b) !
int myfunc(int a,char b) !
pFunc3 size:4
�밴���������. . .
*/