#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"mydll.h" //导入动态库头文件

#pragma comment(lib,"./testDll.lib") //导入动态库


/*
* 12.3.2 动态库的使用
*/
//测试“外部函数”
int main(){

	int a = 10;
	int b = 20;
	int ret = myAdd(a, b);
	printf("ret = %d\n", ret);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 20
请按任意键继续. . .
*/



/*
* 13.3 递归函数调用
*/
void fun(int a) {

    //必需有退出条件，否则容易栈溢出
	if (a == 1) {
		printf("a = %d\n", a);
		return; //中断函数很重要
	}

	fun(a - 1); //递归调用
	printf("a = %d\n", a);
}


int main2(void) {

	fun(2);
	printf("main\n");

	return 0;
}