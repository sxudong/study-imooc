package com.SpringSource.ch02.basic;

/**
 * 2.1 容器的基本用法
 * 《Spring源码深度解析》P10
 */
public class MyTestBean {

    private String testStr = "testStr";


    public String getTestStr() {
        return testStr;
    }

    public void setTestStr(String testStr) {
        this.testStr = testStr;
    }
}
