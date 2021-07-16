//调用offset函数测试结构体成员变量的偏移量
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	struct s 
	{
		int i;
		char c;
		double d;
		char a[1];
	};

	/* Output is compiler dependent */

	printf("offsets: i=%zd; c=%zd; d=%zd a=%zd\n",
			offsetof(struct s, i), offsetof(struct s, c),
			offsetof(struct s, d), offsetof(struct s, a));
	printf("sizeof(struct s)=%zd\n", sizeof(struct s));

	return 0;
}
/*
aaron@aaron-virtual-machine:~$ make offsetof
cc     offsetof.c   -o offsetof
aaron@aaron-virtual-machine:~$ ./offsetof 
offsets: i=0; c=4; d=8 a=16
sizeof(struct s)=24
*/