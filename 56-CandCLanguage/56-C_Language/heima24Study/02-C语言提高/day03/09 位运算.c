#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 1. ��λȡ�� ~
*/
void test01()
{
	/*
	  int������32λ��
	  0000 0010
	  1111 1101
	  1000 0011  =  1*2^0 + 1*2^1 = 3���з��� -3
	*/
	int number = 2; //010   101  ����ʹ�ò���洢 110 + 1 ��111  -3  //1*2^0 + 1*2^1 = 3
	printf("~number : %d\n", ~number); //~number : -3
}

/*
* 2. λ�� &
*/
void test02()
{
	int number = 332;
	if ((number & 1) == 0){
		printf("%d��ż��!\n", number); //332��ż��!
	}else{
		printf("%d������!\n", number);
	}

	//number = number & 0;
	number &= 0;
	printf("number:%d\n", number); //number:0
}

/*
* 3. λ�� |
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
* 4 λ�ֻ� ^
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
    //num1��num2ֵ���������£�
	printf("num1:%d num2:%d\n", num1, num2); //num1:5 num2:9

	num1 = num1 ^ num2;  // num1=12
	num2 = num1 ^ num2;  // num2=5
	num1 = num1 ^ num2;  // num1=9

	printf("num1:%d num2:%d\n", num1, num2); //num1:9 num2:5

}

/*
* ���������
*    ���Ƽ�λ���൱�ڳ���2�ļ��η�
*/
void test05()
{
	int number = 20;
	//����2������2*2
	printf("number = %d\n", number <<= 2); //number = 80
	//����1������2
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
332��ż��!
number:0
------------------
num1 | num2 = 7
------------------
num1:5 num2:9
num1:9 num2:5
------------------
number = 80
number = 40
�밴���������. . .
*/