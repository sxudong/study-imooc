package com.myimooc.spring.simple.ioc.interfaces;

/**
 * 面向接口编程测试类
 */
public class Main {

    public static void main(String[] args) {
        OneInterfacesImpl oneInterface = new OneInterfacesImpl();
        System.out.println(oneInterface.hello("word"));
    }
}
