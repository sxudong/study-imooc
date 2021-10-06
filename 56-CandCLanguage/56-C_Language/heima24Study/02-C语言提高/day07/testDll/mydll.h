#pragma once

/*
* 12.3.1 动态库的创建
*/

#ifdef __cplusplus
extern "C"{
#endif

	/*
	* 内部函数 ，外部函数(导出函数)
	*
	* 内部函数：归动态库自己使用的，不对外开发。
	*/

	__declspec(dllexport) int myAdd(int a, int b);  //外部函数，也叫导出函数。导出函数可以被外部使用。

	void func() {} //内部函数

#ifdef __cplusplus
}
#endif

