package com.SpringSource.ch07.dynamicAOP;


/**
 * 《Spring源码尝试解析》7.1 动态AOP使用示例
 */
public class TestBean {
    private String testStr = "testStr";

    public String getTestStr() {
        return testStr;
    }

    public void setTestStr(String testStr) {
        this.testStr = testStr;
    }

    public void test() {
        System.out.println("test");
    }
}
