#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 1. 按位取反 ~
*/
void test01()
{
	/*
	  int类型是32位的
	  0000 0010
	  1111 1101
	  1000 0011  =  1*2^0 + 1*2^1 = 3，有符号 -3
	*/
	int number = 2; //010   101  负数使用补码存储 110 + 1 ，111  -3  //1*2^0 + 1*2^1 = 3
	printf("~number : %d\n", ~number); //~number : -3
}

/*
* 2. 位与 &
*/
void test02()
{
	int number = 332;
	if ((number & 1) == 0){
		printf("%d是偶数!\n", number); //332是偶数!
	}else{
		printf("%d是奇数!\n", number);
	}

	//number = number & 0;
	number &= 0;
	printf("number:%d\n", number); //number:0
}

/*
* 3. 位或 |
*/
void test03()
{
	int num1 = 5;
	int num2 = 3;

    /*
      101  //5
      011  //3
      111  =  1*2^0 + 1*2^1 + 1*2^2 = 7
    */
	printf("num1 | num2 = %d\n", num1 | num2); //num1 | num2 = 7
}

/*
* 4 位抑或 ^
*/
void test04()
{
	int num1 = 5;
	int num2 = 9;

#if 0
	int temp = num1;
	num1 = num2;
	num2 = temp;
#endif
    //num1和num2值交换，如下：
	printf("num1:%d num2:%d\n", num1, num2); //num1:5 num2:9

	num1 = num1 ^ num2;  // num1=12
	num2 = num1 ^ num2;  // num2=5
	num1 = num1 ^ num2;  // num1=9

	printf("num1:%d num2:%d\n", num1, num2); //num1:9 num2:5

}

/*
* 左移运算符
*    左移几位就相当于乘以2的几次方
*/
void test05()
{
	int number = 20;
	//左移2，乘以2*2
	printf("number = %d\n", number <<= 2); //number = 80
	//右移1，除以2
	printf("number = %d\n", number >>= 1); //number = 40
}


int main() {

	test01();
	printf("------------------\n");
	test02();
	printf("------------------\n");
	test03();
	printf("------------------\n");
	test04();
	printf("------------------\n");
	test05();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
~number : -3
------------------
332是偶数!
number:0
------------------
num1 | num2 = 7
------------------
num1:5 num2:9
num1:9 num2:5
------------------
number = 80
number = 40
请按任意键继续. . .
*/