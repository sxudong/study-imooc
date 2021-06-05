#pragma  once

/*
* 如果是不是C++的代码,套在这里面的方法都会按C语言处理
*/
#ifdef __cplusplus //两个_下划线
extern "C" {
#endif // !__cplusplus


#include <stdio.h>
	void show();


#ifdef __cplusplus //两个_下划线
}
#endif // !__cplusplus

