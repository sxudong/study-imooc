#include "JNITest.h"

/* Java JNITest#testN() native方法调用 C++ */
JNIEXPORT void JNICALL Java_JNITest_testN(JNIEnv *, jobject)
{
	printf("Hello native method!!");
}