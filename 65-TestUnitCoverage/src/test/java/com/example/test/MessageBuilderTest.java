package com.example.test;
 
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * jacoco 代码覆盖率
 * https://blog.csdn.net/qq_39208536/article/details/125653263
 */
public class MessageBuilderTest {
 
    @Test
    public void testGetMessage1() {
        MessageBuilder obj = new MessageBuilder();
        assertEquals("Hello test", obj.getMessage("test"));
    }
 
    @Test
    public void testGetMessage2() {
        MessageBuilder obj = new MessageBuilder();
        assertEquals("zhangsan", obj.getMessage1("zhangsan"));
    }
 
    @Test
    public void testGetMessage3() {
        MessageBuilder obj = new MessageBuilder();
        assertEquals("lisi", obj.getMessage2("lisi"));
    }
}