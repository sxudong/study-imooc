package com.myimooc;

import java.util.Iterator;

public abstract class ArgumentMarshaler {

    public abstract void set(Iterator<String> integerValue) throws ArgsException;

    public abstract Object get();
}

