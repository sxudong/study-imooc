#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main06()
{
	int a;
	scanf("%d", &a);
	//switch (a)
	//{
	//case 1:
	//	printf("a��ֵΪ��%d", a);
	//	break;
	//case 10:
	//	printf("a��ֵΪ��%d\n", a);
	//	break;
	//default:
	//	printf("a��ɶ��\n");
	//	break;
	//}
	
	switch (a/10)
	{
	case 10:
		//printf("����\n");
		//break;
	case 9:
		printf("����\n");
		break;
	case 8:
		printf("����\n");
		break;
	case 7:
		//printf("����\n");
		//break;
	case 6:
		printf("����\n");
		break;
	default:
		printf("������\n");
		break;
	}

	return EXIT_SUCCESS;
}