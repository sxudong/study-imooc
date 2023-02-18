package com.objectmentor.utilities.args;

import java.util.Iterator;
import java.util.NoSuchElementException;
import static com.objectmentor.utilities.args.ArgsException.ErrorCode.*;

/**
 * 代码清单 14-6 IntegerArgumentMarshaler.java
 */
public class IntegerArgumentMarshaler implements ArgumentMarshaler {
    private int intValue = 0;

    public void set(Iterator<String> currentArgument) throws ArgsException {
        String parameter = null;
        try {
            // 获取 -p 参数后的值，数组下标向后移一位，下次遍历时是下一个带“-”的参数
            parameter = currentArgument.next();
            intValue = Integer.parseInt(parameter);
        } catch (NoSuchElementException e) {
            throw new ArgsException(MISSING_INTEGER);
        } catch (NumberFormatException e) {
            throw new ArgsException(INVALID_INTEGER, parameter);
        }
    }

    public static int getValue(ArgumentMarshaler am) {
        if (am != null && am instanceof IntegerArgumentMarshaler)
            return ((IntegerArgumentMarshaler) am).intValue;
        else
            return 0;
    }

    public Object get() {
        return intValue;
    }
}