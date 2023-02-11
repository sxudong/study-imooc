package com.objectmentor.utilities.args.v1;

import java.util.Iterator;
import java.util.NoSuchElementException;

import static com.objectmentor.utilities.args.v1.ArgsException.ErrorCode.*;

/**
 * 代码清单 14-5 StringArgumentMarshaler.java
 */
public class StringArgumentMarshaler implements ArgumentMarshaler {
    private String stringValue = "";

    public void set(Iterator<String> currentArgument) throws ArgsException {
        try {
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