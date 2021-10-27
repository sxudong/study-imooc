package com.myimooc.spring.simple.postprocessor;

public class BeanTest {

    private String name;

    public BeanTest() {
      System.out.println("执行构造函数");
    }

    public BeanTest(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

