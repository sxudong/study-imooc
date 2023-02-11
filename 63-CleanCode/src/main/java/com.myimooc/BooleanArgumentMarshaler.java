package com.myimooc;

import java.util.Iterator;

public class BooleanArgumentMarshaler extends ArgumentMarshaler {

    private boolean booleanValue = false;

    public void set(Iterator<String> currentArgument) {
        booleanValue = true;
    }

    public Object get() {
        return booleanValue;
    }
}

