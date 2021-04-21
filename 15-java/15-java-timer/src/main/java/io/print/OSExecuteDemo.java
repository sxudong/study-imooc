// TIJ4code
//: io/OSExecuteDemo.java
// Demonstrates standard I/O redirection.
// 演示标准 I/O 重定向。
package io.print;

import io.util.OSExecute;

/**
 * 18.9 进程控制
 * 控制程序的输入和输出，将产生的输出发送到控制台。
 *
 * 使用这个工具，可能会产生两种类型的错误：
 * 普通的导致异常的错误 —— 对这些错误我们只需重新抛出一个运行时异常。
 */
public class OSExecuteDemo {
  // 运行测试程序，需要在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”
  // 设置当前工个目录“D:\IDEAworkspase\TIJ4code\target\classes\io”
  public static void main(String[] args) {
    //OSExecute.command("dir"); // 正常输出，没有报错
    OSExecute.command("javap OSExecuteDemo"); //演示抛异常
  }
} /* Output:
Compiled from "OSExecuteDemo.java"
public class com.bjsxt.io.print.OSExecuteDemo {
  public com.bjsxt.io.print.OSExecuteDemo();
  public static void main(java.lang.String[]);
}
警告: 二进制文件OSExecuteDemo包含com.bjsxt.io.print.OSExecuteDemo
Exception in thread "main" com.bjsxt.io.util.OSExecuteException: Errors executing javap OSExecuteDemo
	at com.bjsxt.io.util.OSExecute.command(OSExecute.java:52)
	at com.bjsxt.io.print.OSExecuteDemo.main(OSExecuteDemo.java:19)
*///:~
