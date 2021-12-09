/**
 * Java开发一个native方法
 * https://blog.csdn.net/haidian_fengyu/article/details/109160195
 *
 * 1.新建一个文件: JNITest.java
 * 2.编译成class文件：javac JNITest.java
 * 3.把上一步得到的class编译成c的头文件：javah -jni JNITest
 * 4.编写JNITest.cpp文件，实现native方法
 * 5.把 jdk1.8.0_172\include\jni.h 和 jdk1.8.0_172\include\win32\jni_md.h 文件拷贝到当前目录
 * 6.把cpp文件编译成dll文件：gcc JNITest.cpp -shared -o JNITest.dll
 * 7.运行 JNITest
 */
public class JNITest {

	public native void testN();

	static {
         //System.load("D:\\Work\\Java_Native_Demo\\JNITest.dll");
		System.load("G:\\IDworkspace\\study-imooc\\15-java\\15-java-native_demo\\src\\main\\java\\JNITest.dll");
	}

	public static void main(String[] args){
         new JNITest().testN();
	}
}
/* Output:
Hello native method!!
*///~