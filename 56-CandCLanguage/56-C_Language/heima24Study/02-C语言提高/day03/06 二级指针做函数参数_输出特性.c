#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


void allocateSpace(int** temp)
{
	int* arr = malloc(sizeof(int) * 10);
	for (int i = 0; i < 10; ++i)
		arr[i] = i + 1;

	//ָ���Ӹ�ֵ��ָ���ﱣ����һ����ַ��
	*temp = arr; //�õ���arr���׵�ַ
}

void printArray(int* arr, int len)
{
	for (int i = 0; i < len; ++i)
		printf("%d ", arr[i]);
	printf("\n");
}

/*
* �ͷŶѿռ�
* freeSpace(void* arr)�����ڵ� arr ��ַ == freeSpace(int** arr)�����ڵ� *arr ��ַ
*/
#if 0
    void freeSpace(void* arr) //����Ҫ�������ͣ�ֱ���ͷž���
    {
        if (arr == NULL)
            return;

        //printf("arr��ֵ = %d\n", arr); //7088120

        free(arr);
        arr = NULL; //�ÿ�
    }
#else
    void freeSpace(int** arr) //**arr���յ���&pArray�ĵ�ַ��*arr������ֵ
    {
        if (arr == NULL)
            return;

        //printf("*arr��ֵ = %d\n", *arr); //7088120

        if (*arr != NULL){
            free(*arr);  //*arrȡ����&pArray��ֵ��ָ���ֵ�������arr����ĵ�ַ
            *arr = NULL; //�������pArray��ֵָ�����
            arr = NULL;  //���յ���ʱ�������ڿգ�����ط����Բ�д����ʱ�����ں���������������
        }
    }
#endif


void test01()
{
	int* pArray = NULL;
	allocateSpace(&pArray);
	printArray(pArray, 10);
#if 0
	freeSpace(pArray);  //������pArray�ﱣ��ĵ�ַ
	pArray = NULL;      //ָ��գ�������������ͻ��ΪҰָ��
#endif
	freeSpace(&pArray); //������pArrayָ������ĵ�ַ
	if (pArray == NULL){
		printf("pArray���ÿ�!\n");
	}
}

int main() {

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1 2 3 4 5 6 7 8 9 10
pArray���ÿ�!
�밴���������. . .
*/