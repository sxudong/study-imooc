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
	//	printf("a的值为：%d", a);
	//	break;
	//case 10:
	//	printf("a的值为：%d\n", a);
	//	break;
	//default:
	//	printf("a是啥？\n");
	//	break;
	//}
	
	switch (a/10)
	{
	case 10:
		//printf("优秀\n");
		//break;
	case 9:
		printf("优秀\n");
		break;
	case 8:
		printf("良好\n");
		break;
	case 7:
		//printf("及格\n");
		//break;
	case 6:
		printf("及格\n");
		break;
	default:
		printf("不及格\n");
		break;
	}

	return EXIT_SUCCESS;
}