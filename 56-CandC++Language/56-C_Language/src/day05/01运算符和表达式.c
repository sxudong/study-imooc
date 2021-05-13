#include <stdio.h>

int main01(void)
{
	//比较运算符
	//int a = 10;
	//int b = 20;
	//printf("10 小于 20 ： %d\n", a <= b);
	//赋值运算符
	//int a = 10;
	//int b = 20;
	////加加在后 先计算表达式的结果在计算变量的值
	////a++;
	////int c = b * a++;
	////加加在前 先计算变量的值在进行表达式计算
	////++a;
	//int c = b * ++a;

	//printf("c=%d\n", c);
	//printf("a=%d\n", a);
	//逻辑运算符
	int a = 10;
	int b = 20;
	printf("%d\n", (a > b && b > a ));
	//int a = 10;
	//int b = 20;
	//int c = a * (b + a);
	return 0;

}