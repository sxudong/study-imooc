package chapter14.v1;

import java.util.Iterator;

/**
 * 代码清单 14-3 ArgumentMarshaler.java
 * 参数封送处理器
 */
public interface ArgumentMarshaler {
    void set(Iterator<String> currentArgument) throws ArgsException;
}