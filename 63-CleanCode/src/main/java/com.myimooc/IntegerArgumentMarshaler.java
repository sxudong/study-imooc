package com.myimooc;

import java.util.Iterator;

public class IntegerArgumentMarshaler extends ArgumentMarshaler {
    private Integer integerValue;

    public void set(Iterator<String> currentArgument) throws ArgsException {
        try {
            this.integerValue = Integer.valueOf(currentArgument.next());
        } catch (NumberFormatException e) {
            throw new ArgsException(ArgsException.ErrorCode.INALID_INTEGER);
        }
    }

    public Object get() {
        return integerValue == null ? 0 : integerValue;
    }
}

