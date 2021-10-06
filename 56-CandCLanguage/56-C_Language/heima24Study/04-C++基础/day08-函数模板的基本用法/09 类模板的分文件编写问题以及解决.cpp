#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;
//#include "Person.cpp"  //引入#include "Person.h"头文件会报错，程序无法运行。
#include "Person.hpp"


/*
8 类模板的分文件编写问题以及解决
	8.1.h.cpp 分别写“声明”和“实现”
	8.2	但是由于“类模板的成员函数”运行阶段才去创建，导致包含“.h”头文件，不会创建函数的实现，无法解析外部命令。
	8.3	解决方案：包含.cpp文件，如：#include "Person.cpp" （不推荐）
	8.4	不要进行“分文件”编写，写到“同一个文件”中，进行声明和实现，后缀名改为“.hpp”。
	8.5	约定俗成的
*/


/*
* 建议：模板“不要做分文件编写”，写到一个类中即可，类内进行“声明”和“实现”，
* 最后把后缀名改为“.hpp”约定俗成。
*/
int main(){

	Person<string, int> p("猪八戒", 10);
	p.showPerson();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
姓名：猪八戒  年龄：  10
请按任意键继续. . .
*/