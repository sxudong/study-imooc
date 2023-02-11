package com.myimooc;

import java.util.Iterator;

public class StringArgumentMarshaler extends ArgumentMarshaler {
    private String stringValue;

    public void set(Iterator<String> currentArgument) throws ArgsException {
        try {
            this.stringValue = currentArgument.next();
        } catch (ArrayIndexOutOfBoundsException e) {
            throw new ArgsException(ArgsException.ErrorCode.MISSING_STRING);
        } catch (ClassCastException e) {
            throw new ArgsException(ArgsException.ErrorCode.INALID_STRING);
        }
    }

    public String get() {
        return stringValue == null ? "" : stringValue;
    }
}

