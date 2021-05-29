#pragma once

#ifdef __cplusplus
extern "C"{
#endif


	//内部函数 ，外部函数(导出函数)
	__declspec(dllexport) int myAdd(int a, int b);



#ifdef __cplusplus
}
#endif
