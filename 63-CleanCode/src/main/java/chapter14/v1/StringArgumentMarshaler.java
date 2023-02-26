package chapter14.v1;

import java.util.Iterator;
import java.util.NoSuchElementException;

import static chapter14.v1.ArgsException.ErrorCode.*;

/**
 * 代码清单 14-5 StringArgumentMarshaler.java
 */
public class StringArgumentMarshaler implements ArgumentMarshaler {
    private String stringValue = "";

    public void set(Iterator<String> currentArgument) throws ArgsException {
        try {
            // 获取 -d 参数后的值，数组下标向后移一位，下次遍历时是下一个带“-”的参数
            stringValue = currentArgument.next();
        } catch (NoSuchElementException e) {
            throw new ArgsException(MISSING_STRING);
        }
    }

    public static String getValue(ArgumentMarshaler am) {
        if (am != null && am instanceof StringArgumentMarshaler)
            return ((StringArgumentMarshaler) am).stringValue;
        else
            return "";
    }
}