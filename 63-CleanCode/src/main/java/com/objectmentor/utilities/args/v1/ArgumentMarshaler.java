package com.objectmentor.utilities.args.v1;

import java.util.Iterator;

/**
 * 代码清单 14-3 ArgumentMarshaler.java
 */
public interface ArgumentMarshaler {
    void set(Iterator<String> currentArgument) throws ArgsException;
}