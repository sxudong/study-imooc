#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
	01 ĳ�������ļ������˼�ͥ��Ա�����䡣 һ����ͥ������Ա������λ��ͬһ�У��ɿո�ָ����
	   ��������ݣ�
	   --------------------
	   45 42 22
	   36 35 7 3 1
	   22 30
	   --------------------
	   ������������ͥ�����г�Ա�����䣬���Ƿֱ���3����5����2����Ա��
	   ��дһ�����򣬼����������ļ���ʾ��ÿ����ͥ���г�Ա��ƽ�����䡣����Ӧ���ø�ʽ����85.2f
	   ��ӡ��ƽ�����䣬��ͥÿ����Ա�����䡣atoi();

	02 ��дһ������sort�ĺ����� �����ڶ�һ���������͵������������Ϊ��ʹ������Ϊͨ�ã�����
	   ����һ������������ - ��ָ��Ƚϻص�������ָ�룬�ûص������ɵ��ó����ṩ���ȽϺ�������
	   ����������Ҳ��������ָ����Ҫ�Ƚϵ�ֵ��ָ�롣�������ֵ��ȣ���������0; �����1��ֵС
	   �ڵ�2������������һ��С��0�������������1��ֵ���ڵ�2��ֵ����������һ������0��������

	   sort�����Ĳ����� :
		 1.һ��ָ����Ҫ���������ĵ�1��ֵ��ָ�롣
		 2.������Ԫϵ�ĸ�����
		 3.һ��ָ��Ƚϻص�������ָ�롣
*/



/*
* ѡ������
*
* ������
*     *ptr����Ҫ���������
*     ele_size������ÿ��Ԫ�ص��ֽڴ�С
*     len�����鳤��
*     *compare�����򷽷�
*/
//��һ��������������(�׵�ַ)���ڶ�������Ϊ���鳤�ȣ�������ÿ��Ԫ����ռ�ֽ�
void selectSort( void* pAddr, int ele_size, int len, int(*compare)(void *,void *))
{
    //��temp����size�ֽڸ���С����char���ʹ洢
	char* temp = malloc(ele_size);

	for (int i = 0; i < len; ++i) {
        //��¼�±�
		int minOrMax = i; //���塰��Сֵ�����ߡ����ֵ���±�

		for (int j = i + 1; j < len; ++j) {
            //�Ѵ�arr��ʼ��j*size���ֽ���char*����pJ
			//����� j Ԫ�ء���ַ��
			char* pJ = (char*) pAddr + j * ele_size; //�׵�ַ ƫ���� = j * Ԫ��size
			char* pMinOrMax = (char*) pAddr + minOrMax * ele_size; //����Ԫ������Ųһλ

			if (compare(pJ, pMinOrMax))
				minOrMax = j; //���¡���Сֵ�����ߡ����ֵ���±�
		}

		if (minOrMax != i) {
			//���� i �� minOrMax �±�Ԫ��
			char* pMinOrMax = (char*) pAddr + minOrMax * ele_size;
			char* pI = (char*) pAddr + i * ele_size;

			//���±�Ϊ j �� minormax �����������н���
			memcpy(temp, pI, ele_size);
			memcpy(pI, pMinOrMax, ele_size);
			memcpy(pMinOrMax, temp, ele_size);
		}
	}

	if (temp != NULL){
		free(temp);
		temp = NULL;
	}
}

int compareInt(void *d1,void *d2)
{
	int *p1 = (int *)d1;
	int *p2 = (int *)d2;

	return *p1 > *p2;
}

void test01()
{
	int arr[] = { 7, 4, 9, 2, 1 };
	//���������㷨����
	selectSort(arr, sizeof(int), sizeof(arr) / sizeof(int), compareInt);
	for (int i = 0; i < 5; ++i)
		printf("%d ",arr[i]); //9 7 4 2 1

	printf("\n");
}

void doLogic(int *p)
{
	if (NULL == p){
		printf("%s �� %d�г���\n",__FILE__,__LINE__);
		printf("%s\n", __DATE__);
		printf("%s\n", __TIME__);

		return;
	}
}

struct Person
{
	char name[64];
	int age;
};

int myComparePerson(void* data1, void* data2)
{
	struct Person* p1 = data1;
	struct Person* p2 = data2;

	//if ( p1->age < p2->age)
	//{
	//	return  1;
	//}
	//return 0;
	//�������� ��������
	return  p1->age < p2->age;

}

void test02()
{
	struct Person pArray[] =
	{
		{ "aaa", 10 },
		{ "bbb", 40 },
		{ "ccc", 20 },
		{ "ddd", 30 },
	};

	int len = sizeof(pArray) / sizeof(struct Person);
	selectSort(pArray, sizeof(struct Person), len, myComparePerson);

	for (int i = 0; i < len; i++)
		printf("������%s ����:%d\n", pArray[i].name, pArray[i].age);
}

int main(){
	//printf("%d", 10 > 5); //1
	test01();
	doLogic(NULL);
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
9 7 4 2 1
G:\VisualStudioWorkSpace\01 ��ҵ_�����㷨\01 ��ҵ_�����㷨.c �� 72�г���
May 29 2021
10:02:25
������aaa ����:10
������ccc ����:20
������ddd ����:30
������bbb ����:40
�밴���������. . .
*/