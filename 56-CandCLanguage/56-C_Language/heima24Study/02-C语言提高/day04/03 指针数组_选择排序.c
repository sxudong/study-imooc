#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* ѡ������
*     �ȡ�ð������Ҫ�ٺܶ�ν�����
*/
void SelectSort(char** arr, int len)
{
	for (int i = 0; i < len; ++i) {
	    //1.ֻ�����±꣬������
		int min = i;
		for (int j = i + 1; j < len; ++j) {
		    //���"����Ԫ��"С�ڡ���minΪ�±��Ԫ��"��min��¼�¡��±ꡱ��jΪ�±������Ԫ�ء��±ꡰ
			if (strcmp(arr[j], arr[min]) < 0) {
				min = j;
			}
		}

		//2.����
		if (min != i) {
		    //��ǰmin�±��ֵ �� ��ǰi�±�Ԫ�ؽ��н���
			char* temp = arr[min];
			arr[min] = arr[i];
			arr[i] = temp;
		}
	} //i++
}

void PrintArray(char** arr, int len)
{
	for (int i = 0; i < len; ++i) {
		printf("%s\n", arr[i]);
	}
}

void test()
{
	char* pArr[] = { "ddd", "ccc", "fff", "hhh", "ppp", "rrr" };
	//pArr��ʲô���͵ģ� char **���͵�
	int len = sizeof(pArr) / sizeof(char*);

	PrintArray(pArr, len);
	//ѡ������
	SelectSort(pArr, len);
	printf("-------------------\n");
	PrintArray(pArr, len);
}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ddd
ccc
fff
hhh
ppp
rrr
-------------------
ccc
ddd
fff
hhh
ppp
rrr
�밴���������. . .
*/