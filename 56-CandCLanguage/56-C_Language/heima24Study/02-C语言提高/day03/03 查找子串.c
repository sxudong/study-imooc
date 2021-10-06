#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* 查找子串第一次出现的位置
*
* 思路：abcdefgdfpoiq  查找df
*       首先遍历找到d
*       找到d之后，再遍历d之后的子串，比较第2个字符是否相等，
*       如果不相等结束此次while循环，到外层while循环中继续
*       寻找d,找到d之后，再遍历d之后的子串，比较第一次个循环
*       直到找到为止。
*/
char* myStrStr(const char* str, const char* substr)
{
	//printf("%s\n",str); //abcdefgdfpoiq
	//printf("%s\n", substr); //df

	const char* mystr = str;
	const char* mysub = substr;

	while (*mystr != '\0')
	{
		//比较首地址值是否相等（d = d）
		if (*mystr != *mysub)
		{
			++mystr;
			continue; //跳出本次循环，进入下一次while循环
		}


		//临时指针变量
		const char* temp_mystr = mystr;
		const char* temp_mysub = mysub;

		while (*temp_mysub != '\0') //如果要找的字符串还没到结尾
		{
			//比较首地址值是否相等（d = d），相等则各自++，比较第2个字符
			if (*temp_mystr != *temp_mysub)
			{
				++mystr; //不相等，查找的源子符串++,向后移一个字符
				break;   //结束while循环，进入外层while循环继续遍历mystr，寻找首字母匹配的字符串
			}

			++temp_mysub;
			++temp_mystr;
		}

		//说明匹配成功
		if (*temp_mysub == '\0') //'\0'说明已经找到的字符串最后结尾
		{
			return (char*)mystr;
		}

	}

	return NULL;
}


void test()
{
	char* str = "abcdefgdfpoiq";
	char* sub = "df";
	char* pos = myStrStr(str, sub);
	printf("pos = %s\n", pos); //pos = dfpoiq

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}