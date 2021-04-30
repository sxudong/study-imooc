// TIJ4code
package io.util;

/**
 * 18.9 进程控制
 * 独立异常来报告这些错误
 */
public class OSExecuteException extends RuntimeException {
    public OSExecuteException(String why) {
        super(why);
    }
} ///:~
