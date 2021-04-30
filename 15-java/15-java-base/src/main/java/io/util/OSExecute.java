// TIJ4code
//: net/mindview/util/OSExecute.java
// Run an operating system command and send the output to the console.
// 运行操作系统命令并将输出发送到控制台。
package io.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * 18.9 进程控制
 *
 * 执行控制台命令工具
 */
public class OSExecute {
    public static void command(String command) {
        boolean err = false;
        try {
            /**
             * 此类用于创建操作系统进程。
             * 每一个 ProcessBuilder 实例管理一个进程属性集。
             * start() 方法利用这些属性创建一个新的 Process 实例。
             * start() 方法能够从同一实例反复调用，以利用同样的或相关的属性创建新的子进程。
             */
            Process process = new ProcessBuilder(command.split(" ")).start();
            BufferedReader results = new BufferedReader(
                    new InputStreamReader(process.getInputStream(),"GBK")); // 加上Windows默认编码“GBK”
            String s;
            while ((s = results.readLine()) != null)
                System.out.println(s);
            // 捕获“标准错误流”
            BufferedReader errors = new BufferedReader(
                    new InputStreamReader(process.getErrorStream(), "GBK"));
            // Report errors and return nonzero value to calling process if there are problems:
            // 如果出现问题，报告错误并将非零值返回给调用进程：
            while ((s = errors.readLine()) != null) {
                // 打印异常信息，标准错误输出
                System.err.println(s);
                err = true;
            }
        } catch (Exception e) {
            // Compensate for Windows 2000, which throws an exception for the default command line:
            // 补偿 Windows 2000，它会抛出默认命令行的异常：
            // 如果不是CMD开头，就加上重新执行（“/C”意思是执行完后关掉）
            if (!command.startsWith("CMD /C"))
                command("CMD /C " + command);
            else
                // 如果命令出错，抛出运行时异常
                throw new RuntimeException(e);
        }
        if (err)
            // 抛出OSExecuteException
            throw new OSExecuteException("Errors executing " + command);
    }
} ///:~
