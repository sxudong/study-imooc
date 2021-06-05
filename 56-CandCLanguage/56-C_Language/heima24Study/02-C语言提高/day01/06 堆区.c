#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


/*
* 1. 堆的内存成员手动申请，手动释放。
*/
int* getSpace()
{
	//将文件名后缀改为C语言".c"，可以编译通过，C语言会帮助强转
	//int* p = malloc(sizeof(int) * 5);

	//如果是C++编译".cpp"两个不相同的类型是需要强制转换的，不可以直接赋值
	int* p = (int*)malloc(sizeof(int) * 5); //局部变量函数结束时会被释放掉，堆上的内存不会被释放掉，需要手动释放掉。

	//空放前面，如果少写一个等号，会报错，因为空是不可以被赋值的
	if (NULL == p)
	{
		return NULL;
	}

	int  j = 0;

	//优先使用前置++
	//前置--，因为先自增自减后再++ --返回赋值。
	//后置++ --，多出一个中间变量，先赋值返回，再自增自减。它要保存当前的状态返回，然后对变量本身++ --，多产生一个临时变量，有申请就有释放。

	//只要是连续的内存空间，都能使用下标的方式访问内存
	for (int i = 0; i < 5; ++i)
	{
		p[i] = 100 + i;
	}

	return p;
}

void test01()
{
	int* ret = getSpace();
	for (int i = 0; i < 5; ++i)
	{
		printf("%d ", ret[i]); //100 101 102 103 104
	}

	//用完堆内存，一定要释放
	free(ret);
	ret = NULL;
}


/*
* 2.定义变量的时候一定要初始化，很多的Bug产生都是由于没有初始化造成的。
*/
void allocateSpace(char* memorystr)
{
	//申请100个字节堆空间
	memorystr = (char*) malloc(100);
	memset(memorystr, 0, 100); //清零，初始化
	strcpy(memorystr, "hello world!"); //函数体结束,变量p被销毁释放，但堆内存没有被释放，会造成堆溢出
}


/*
* 注意形参改变是不会影响到实参的值。我们再分析allocateSpace(p)，实参是一个空指针p，
* 形参为memorystr，调用时，把p赋给memorystr，然后执行memorystr = (char*)malloc(100)，
* 这时候 memorystr获得了100个char空间，但是因为"形参"改变不会影响到"实参"的值，p的值并没
* 改变，还是NULL，所以上面拷贝不成功。
*/
void test02()
{
	char* p = NULL;
	printf("\np = %s\n", p); //p = (null)
	allocateSpace(p);        //这里传的是p变量，不是指针地址，所以打印仍是空
	printf("p = %s\n", p);   //p = (null)
}
//ps: 我们平常使用指针把参数从函数中传递出来，传递的是指针所指向的内容，
//    而非指针本身，而上的例子企图改变的是指针本身。


/*
* 双重指针的用法
* https://blog.csdn.net/gdjason/article/details/51123978
*/
//可以看成*(*p)指向指针的变量，二级指针里存储的是一级指针*p
void allocateSpace02(char** p)
{
	printf("%p\n", *p); //指针地址：00000000

	//使用一个临时指针变量来接收
	char* temp = (char*) malloc(100);  //改变了指针地址
	memset(temp, 0, 100);              //清零，初始化
	strcpy(temp, "hello world!");

	*p = temp;
}

void test03()
{
	char* p = NULL;
	printf("%p\n", p);     //指针地址：00000000

	allocateSpace02(&p);

	printf("%p\n", p);     //指针地址改变：009B59F0
	printf("p = %s\n", p); //p = hello world!
}


int main() {

	test01();
	test02();
	test03();

	int* a = (int*) 20;
	int** b = &a;
	printf("%d\n", a);   //20
	printf("%d\n", *b);  //20
	printf("%p\n", a);   //00000014
	printf("%p\n", *b);  //00000014   //**b里存储的是*b的指针地址

	system("pause");
	return EXIT_SUCCESS;
}