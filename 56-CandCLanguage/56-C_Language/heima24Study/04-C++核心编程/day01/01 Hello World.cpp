#define _CRT_SECURE_NO_WARNINGS
#include <iostream> //标准输入输出流  in输入  out 输出
//using namespace std;//使用命名空间 std 打开一个叫std房间

//C++引入头文件的方式
#include <math.h>
#include <cmath>

//函数入口地址
int main()
{
	// cout 标准的输出
	// <<  左移运算符
	// endl 结束换行(end line)
	std::cout << "hello world" << 123456 << std::endl;

	system("pause"); //阻塞功能
	return EXIT_SUCCESS; //返回正常退出
}
/* Output:
hello world123456
请按任意键继续. . .
*/