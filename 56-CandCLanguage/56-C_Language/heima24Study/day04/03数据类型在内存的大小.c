#include <stdio.h>

int main()
{

	int a = 10;
	//sizeof()求出数据类型在内存中占字节（Byte）大小
	int len1 = sizeof(a);
	//单精度浮点型
	float b = 3.14;
	//字符型
	char c = 'A';
	//双精度浮点型
	double d = 5.12;
	//短整形
	short e = 10;
	//长整型
	long f = 10;
	//长长整形
	long long g = 10;
	int len2 = sizeof(b);  
	int len3 = sizeof(c);
	int len4 = sizeof(d);
	int len5 = sizeof(e);
	int len6 = sizeof(f);
	int len7 = sizeof(g);
	printf("%d\n",a); //10
	printf("int =%d\n",len1); //4
	printf("float =%d\n",len2); //4
	printf("char = %d\n",len3); //1
	printf("double = %d\n",len4); //8
	printf("short = %d\n",len5); //2
	printf("long = %d\n",len6); //4
	printf("long long = %d\n",len7); //8
	return 0;
}
