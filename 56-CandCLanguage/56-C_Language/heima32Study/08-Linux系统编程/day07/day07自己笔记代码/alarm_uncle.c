//测试1秒钟数多少数字
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>


int main()
{
	alarm(1);
	
	int i = 0;
	while(1){
		printf("[%d]\n", i++);
	}

	return 0;
}

/*
aaron@aaron-virtual-machine:~/桌面/test$ make alarm_uncle
cc     alarm_uncle.c   -o alarm_uncle
aaron@aaron-virtual-machine:~/桌面/test$ time ./alarm_uncle  
......
[219997]
[219998]
[219999]
[220000]
[220001]
闹钟

实际执行时间 = 系统时间 + 用户时间 + 损耗时间

每一个数字都直接打印:printf("[%d]\n", i++);
real	0m1.002s
user	0m0.040s  0.497
sys	    0m0.457s  
损耗时间=1.002-(0.040+0.457)=0.505

//文件重定向之后:
aaron@aaron-virtual-machine:~/桌面/test$ time ./alarm_uncle > test.log
real	0m1.001s
user	0m0.184s
sys	    0m0.814s  0.998
损耗时间=1.001-(0.184+0.814)=0.003

原因是: 
	调用printf函数打印数字遇到\n才会打印，打印过程涉及到从
	用户区到内核区的切换，切换次数越多消耗的时间越长，效率越低；
	而使用文件重定向，由于文件操作是“带缓冲”的，所以涉及到用
	户区到内核区的切换次数大大减少，从而使损耗降低。
*/